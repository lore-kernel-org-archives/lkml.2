Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab2FDP3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:29:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760747Ab2FDP3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:29:40 -0400
Date: Mon, 4 Jun 2012 17:29:37 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add UTF-16 convenience functions
Message-ID: <20120604152937.GG11010@quack.suse.cz>
References: <4FC81678.5040106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FC81678.5040106@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-06-12 03:10:16, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> This is used for UDF and some other FS non-BMP support.
> This series requires my previously sent
> [PATCH 1/8] Support full unicode in uni2char and char2uni
> Can resend if needed.
  Thanks for the patches Vladimir. I've read them and they all look OK to
me so feel free to add:
  Reviewed-by: Jan Kara <jack@suse.cz>

  to them. Al Viro <viro@zeniv.linux.org.uk> should merge these patches but
he tends to be rather busy so I suggest to also include the above mentioned
necessary patch in the series and resend all five patches to him, CCing the
lists. You can also CC Andrew Morton <akpm@linux-foundation.org> since he
sometimes carries and resends patches to Al when he does not include them.

									Honza
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> ---
>  fs/nls/nls_base.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nls/nls_utf8.c   |    2 +-
>  include/linux/nls.h |    6 +++++
>  3 files changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
> index 4f6d1ae..0c1ad5b 100644
> --- a/fs/nls/nls_base.c
> +++ b/fs/nls/nls_base.c
> @@ -171,6 +171,32 @@ int utf8s_to_utf16s(const u8 *s, int inlen, enum utf16_endian endian,
>  }
>  EXPORT_SYMBOL(utf8s_to_utf16s);
>  
> +int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
> +		      wchar_t *pwcs, int maxout)
> +{
> +	u16 *op = pwcs;
> +
> +	op = pwcs;
> +
> +	if (u >= PLANE_SIZE) {
> +		if (maxout < 2)
> +			return -1;
> +		u -= PLANE_SIZE;
> +		put_utf16(op++, SURROGATE_PAIR |
> +			  ((u >> 10) & SURROGATE_BITS),
> +			  endian);
> +		put_utf16(op++, SURROGATE_PAIR |
> +			  SURROGATE_LOW |
> +			  (u & SURROGATE_BITS),
> +			  endian);
> +		return 2;
> +	} else {
> +		put_utf16(op++, u, endian);
> +		return 1;
> +	}
> +}
> +EXPORT_SYMBOL(unicode_to_utf16s);
> +
>  static inline unsigned long get_utf16(unsigned c, enum utf16_endian endian)
>  {
>  	switch (endian) {
> @@ -232,6 +258,43 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
>  }
>  EXPORT_SYMBOL(utf16s_to_utf8s);
>  
> +int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
> +		      unicode_t *uni)
> +{
> +	unsigned long u, v;
> +	const wchar_t *pwcs0 = pwcs;
> +
> +	while (inlen > 0) {
> +		u = get_utf16(*pwcs, endian);
> +		if (!u)
> +			break;
> +		pwcs++;
> +		inlen--;
> +		if ((u & SURROGATE_MASK) == SURROGATE_PAIR) {
> +			if (u & SURROGATE_LOW) {
> +				/* Ignore character and move on */
> +				continue;
> +			}
> +			if (inlen <= 0)
> +				break;
> +			v = get_utf16(*pwcs, endian);
> +			if ((v & SURROGATE_MASK) != SURROGATE_PAIR ||
> +			    !(v & SURROGATE_LOW)) {
> +				/* Ignore character and move on */
> +				continue;
> +			}
> +			u = PLANE_SIZE + ((u & SURROGATE_BITS) << 10)
> +				+ (v & SURROGATE_BITS);
> +			pwcs++;
> +			inlen--;
> +		}
> +		*uni = u;
> +		return pwcs - pwcs0;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(utf16s_to_unicode);
> +
>  int register_nls(struct nls_table * nls)
>  {
>  	struct nls_table ** tmp = &tables;
> diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
> index eb6392e..a3b3de0 100644
> --- a/fs/nls/nls_utf8.c
> +++ b/fs/nls/nls_utf8.c
> @@ -37,7 +37,7 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
>  		*uni = 0x003f;	/* ? */
>  		return -EINVAL;
>  	}
> -	*uni = (wchar_t) u;
> +	*uni = u;
>  	return n;
>  }
>  
> diff --git a/include/linux/nls.h b/include/linux/nls.h
> index c0292dd..7de1765 100644
> --- a/include/linux/nls.h
> +++ b/include/linux/nls.h
> @@ -50,12 +50,18 @@ extern struct nls_table *load_nls(char *);
>  extern void unload_nls(struct nls_table *);
>  extern struct nls_table *load_nls_default(void);
>  
> +#define MAX_UTF16_PER_UNICODE 2
> +
>  extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
>  extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
>  extern int utf8s_to_utf16s(const u8 *s, int len,
>  		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
>  extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
>  		enum utf16_endian endian, u8 *s, int maxlen);
> +int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
> +		      wchar_t *pwcs, int maxout);
> +int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
> +		      unicode_t *uni);
>  
>  static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
>  {
> -- 
> 1.7.10
> 
> -- 
> Regards
> Vladimir 'φ-coder/phcoder' Serbinenko
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
