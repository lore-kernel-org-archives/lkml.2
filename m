Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2I2Tr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 15:47:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52253 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab2I2Try (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 15:47:54 -0400
Message-ID: <50675038.9000108@zytor.com>
Date: Sat, 29 Sep 2012 12:47:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping on this patch?

	-hpa

On 08/13/2012 10:26 AM, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
>
> When we write entropy into a non-empty pool, we currently don't
> account at all for the fact that we will probabilistically overwrite
> some of the entropy in that pool.  This means that unless the pool is
> fully empty, we are currently *guaranteed* to overestimate the amount
> of entropy in the pool!
>
> Assuming Shannon entropy with zero correlations we end up with an
> exponentally decaying value of new entropy added:
>
> 	entropy <- entropy + (pool_size - entropy) *
> 		(1 - exp(-add_entropy/pool_size))
>
> However, calculations involving fractional exponentials are not
> practical in the kernel, so apply a piecewise linearization:
>
> 	  For add_entropy <= pool_size then
>
> 	  (1 - exp(-add_entropy/pool_size)) >= (add_entropy/pool_size)*0.632...
>
> 	  ... so we can approximate the exponential with
> 	  add_entropy/(pool_size*2) and still be on the
> 	  safe side by adding at most one pool_size at a time.
>
> In order for the loop not to take arbitrary amounts of time if a bad
> ioctl is received, terminate if we are within one bit of full.  This
> way the loop is guaranteed to terminate after no more than
> log2(poolsize) iterations, no matter what the input value is.  The
> vast majority of the time the loop will be executed exactly once.
>
> The piecewise linearization is very conservative, approaching 1/2 of
> the usable input value for small inputs, however, our entropy
> estimation is pretty weak at best, especially for small values; we
> have no handle on correlation; and the Shannon entropy measure (Rényi
> entropy of order 1) is not the correct one to use in the first place,
> but rather the correct entropy measure is the min-entropy, the Rényi
> entropy of infinite order.
>
> As such, this conservatism seems more than justified.  Note, however,
> that attempting to add one bit of entropy will never succeed; nor will
> two bits unless the pool is completely empty.  These roundoff
> artifacts could be improved by using fixed-point arithmetic and adding
> some number of fractional entropy bits.
>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: DJ Johnston <dj.johnston@intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/char/random.c | 104 ++++++++++++++++++++++++++++++++++----------------
>   1 file changed, 72 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index b86eae9..5d870ad 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -272,10 +272,12 @@
>   /*
>    * Configuration information
>    */
> -#define INPUT_POOL_WORDS 128
> -#define OUTPUT_POOL_WORDS 32
> -#define SEC_XFER_SIZE 512
> -#define EXTRACT_SIZE 10
> +#define INPUT_POOL_SHIFT	12
> +#define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
> +#define OUTPUT_POOL_SHIFT	10
> +#define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
> +#define SEC_XFER_SIZE		512
> +#define EXTRACT_SIZE		10
>
>   #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
>
> @@ -309,40 +311,41 @@ static DEFINE_PER_CPU(int, trickle_count);
>    * scaled squared error sum) except for the last tap, which is 1 to
>    * get the twisting happening as fast as possible.
>    */
> -static struct poolinfo {
> +static const struct poolinfo {
> +	int poolshift;		/* log2(POOLBITS) */
>   	int poolwords;
>   	int tap1, tap2, tap3, tap4, tap5;
>   } poolinfo_table[] = {
> -	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
> -	{ 128,	103,	76,	51,	25,	1 },
> -	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
> -	{ 32,	26,	20,	14,	7,	1 },
> +	/*    x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
> +	{ 12, 128,	103,	76,	51,	25,	1 },
> +	/*    x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
> +	{ 10, 32,	26,	20,	14,	7,	1 },
>   #if 0
> -	/* x^2048 + x^1638 + x^1231 + x^819 + x^411 + x + 1  -- 115 */
> -	{ 2048,	1638,	1231,	819,	411,	1 },
> +	/*    x^2048 + x^1638 + x^1231 + x^819 + x^411 + x + 1  -- 115 */
> +	{ 16, 2048,	1638,	1231,	819,	411,	1 },
>
> -	/* x^1024 + x^817 + x^615 + x^412 + x^204 + x + 1 -- 290 */
> -	{ 1024,	817,	615,	412,	204,	1 },
> +	/*    x^1024 + x^817 + x^615 + x^412 + x^204 + x + 1 -- 290 */
> +	{ 15, 1024,	817,	615,	412,	204,	1 },
>
> -	/* x^1024 + x^819 + x^616 + x^410 + x^207 + x^2 + 1 -- 115 */
> -	{ 1024,	819,	616,	410,	207,	2 },
> +	/*    x^1024 + x^819 + x^616 + x^410 + x^207 + x^2 + 1 -- 115 */
> +	{ 15, 1024,	819,	616,	410,	207,	2 },
>
> -	/* x^512 + x^411 + x^308 + x^208 + x^104 + x + 1 -- 225 */
> -	{ 512,	411,	308,	208,	104,	1 },
> +	/*    x^512 + x^411 + x^308 + x^208 + x^104 + x + 1 -- 225 */
> +	{ 14, 512,	411,	308,	208,	104,	1 },
>
> -	/* x^512 + x^409 + x^307 + x^206 + x^102 + x^2 + 1 -- 95 */
> -	{ 512,	409,	307,	206,	102,	2 },
> -	/* x^512 + x^409 + x^309 + x^205 + x^103 + x^2 + 1 -- 95 */
> -	{ 512,	409,	309,	205,	103,	2 },
> +	/*    x^512 + x^409 + x^307 + x^206 + x^102 + x^2 + 1 -- 95 */
> +	{ 14, 512,	409,	307,	206,	102,	2 },
> +	/*    x^512 + x^409 + x^309 + x^205 + x^103 + x^2 + 1 -- 95 */
> +	{ 14, 512,	409,	309,	205,	103,	2 },
>
> -	/* x^256 + x^205 + x^155 + x^101 + x^52 + x + 1 -- 125 */
> -	{ 256,	205,	155,	101,	52,	1 },
> +	/*    x^256 + x^205 + x^155 + x^101 + x^52 + x + 1 -- 125 */
> +	{ 13, 256,	205,	155,	101,	52,	1 },
>
> -	/* x^128 + x^103 + x^78 + x^51 + x^27 + x^2 + 1 -- 70 */
> -	{ 128,	103,	78,	51,	27,	2 },
> +	/*    x^128 + x^103 + x^78 + x^51 + x^27 + x^2 + 1 -- 70 */
> +	{ 12, 128,	103,	78,	51,	27,	2 },
>
> -	/* x^64 + x^52 + x^39 + x^26 + x^14 + x + 1 -- 15 */
> -	{ 64,	52,	39,	26,	14,	1 },
> +	/*    x^64 + x^52 + x^39 + x^26 + x^14 + x + 1 -- 15 */
> +	{ 11, 64,	52,	39,	26,	14,	1 },
>   #endif
>   };
>
> @@ -424,7 +427,7 @@ module_param(debug, bool, 0644);
>   struct entropy_store;
>   struct entropy_store {
>   	/* read-only data: */
> -	struct poolinfo *poolinfo;
> +	const struct poolinfo *poolinfo;
>   	__u32 *pool;
>   	const char *name;
>   	struct entropy_store *pull;
> @@ -585,11 +588,13 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
>   }
>
>   /*
> - * Credit (or debit) the entropy store with n bits of entropy
> + * Credit (or debit) the entropy store with n bits of entropy.
> + * The nbits value is given in units of 2^-16 bits, i.e. 0x10000 == 1 bit.
>    */
>   static void credit_entropy_bits(struct entropy_store *r, int nbits)
>   {
>   	int entropy_count, orig;
> +	int pool_size = r->poolinfo->POOLBITS;
>
>   	if (!nbits)
>   		return;
> @@ -597,13 +602,48 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
>   	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
>   retry:
>   	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
> -	entropy_count += nbits;
> +	if (nbits < 0) {
> +		/* Debit. */
> +		entropy_count += nbits;
> +	} else {
> +		/*
> +		 * Credit: we have to account for the possibility of
> +		 * overwriting already present entropy.  Even in the
> +		 * ideal case of pure Shannon entropy, new contributions
> +		 * approach the full value asymptotically:
> +		 *
> +		 * entropy <- entropy + (pool_size - entropy) *
> +		 *	(1 - exp(-add_entropy/pool_size))
> +		 *
> +		 * For add_entropy <= pool_size then
> +		 * (1 - exp(-add_entropy/pool_size)) >=
> +		 *    (add_entropy/pool_size)*0.632...
> +		 * so we can approximate the exponential with
> +		 * add_entropy/(pool_size*2) and still be on the
> +		 * safe side by adding at most one pool_size at a time.
> +		 *
> +		 * The use of pool_size-1 in the while statement is to
> +		 * prevent rounding artifacts from making the loop
> +		 * arbitrarily long; this limits the loop to poolshift
> +		 * turns no matter how large nbits is.
> +		 */
> +		int pnbits = nbits;
> +		int s      = r->poolinfo->poolshift + 1;
> +
> +		do {
> +			int anbits = min(pnbits, pool_size);
> +
> +			entropy_count +=
> +				((pool_size - entropy_count)*anbits) >> s;
> +			pnbits -= anbits;
> +		} while (unlikely(entropy_count < pool_size-1 && pnbits));
> +	}
>
>   	if (entropy_count < 0) {
>   		DEBUG_ENT("negative entropy/overflow\n");
>   		entropy_count = 0;
> -	} else if (entropy_count > r->poolinfo->POOLBITS)
> -		entropy_count = r->poolinfo->POOLBITS;
> +	} else if (entropy_count > pool_size)
> +		entropy_count = pool_size;
>   	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
>   		goto retry;
>
>


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

