Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab0HJEQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:16:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36954 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0HJEP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=PGG9tDGgTS14ugyJZGvbHbMvslMRNOuzbJHu4fXzYMvfzd7KYd2CiVkziQIuz9tsIQ
         1txGKAxHny5l1mXLuFQYoc9y7lt34HN7dpJ3caN6aPgNvWjK4NIwwSfR+IyxAlDxQ2uE
         Mo6iRwtl6vW1jVWajbvgnITvB2iNq/byABUp0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCHv2 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
Date: Tue, 10 Aug 2010 06:15:52 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com> <419733287a42072a658f0f74d0b1901132178b75.1281295424.git.mina86@mina86.com>
In-Reply-To: <419733287a42072a658f0f74d0b1901132178b75.1281295424.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008100615.52510.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
> Compared to previous version: the code is used only if:
> 1. if long long is 64-bit (ie. ULLONG_MAX == 2**64-1), and
> 2. user did not select optimisation for size with Kconfig.

I measured the size and it does not seem to make sense
to exclude it on -Os. On x86:

put_dec_full change: 0x93 -> 0x47 bytes
put_dec      change: 0x12c -> 0x137 bytes

IOW, there is net code size reduction (compared to current kernel,
it may be a slight growth compared to patch 1).

So, please use the optimized code even for CONFIG_CC_OPTIMIZE_FOR_SIZE.


> Here are the results (normalised to the fastest/smallest):
>                     :        ARM       Atom
> -- Speed ----------------------------------
> orig_put_dec        :   9.333822   2.083110  Original
> mod1_put_dec        :   9.282045   1.904564
> mod2_put_dec        :   9.260409   1.910302
> mod3_put_dec        :   9.320053   1.905689  Proposed by previous patch
> mod4_put_dec        :   9.297146   1.933971
> mod5_put_dec        :  13.034318   2.434942
> mod6_put_dec        :   1.000000   1.000000  Proposed by this patch
> mod7_put_dec        :   1.009574   1.014147
> mod8_put_dec        :   7.226004   1.953460
> -- Size -----------------------------------
> orig_put_dec        :   1.000000   1.000000  Original
> mod1_put_dec        :   1.000000   1.000000
> mod2_put_dec        :   1.361111   1.403226
> mod3_put_dec        :   1.000000   1.000000  Proposed by previous patch
> mod4_put_dec        :   1.361111   1.403226
> mod5_put_dec        :   1.000000   1.000000
> mod6_put_dec        :   2.555556   3.508065  Proposed by this patch
> mod7_put_dec        :   2.833333   3.911290
> mod8_put_dec        :   2.027778   2.258065

I believe these are old results? Size growth is just too big.


> As it can be obsevred, proposed version of the put_dec function is
> twice as fast as the original version on Atom and almost 10 times
> faster on ARM.  I imagine that it may be similar on other "embedded"
> processors.
> 
> This may be skewed by the fact that the benchmark is using GCC's
> 64-bit division operator instead of kernel's do_div but it would
> appear that by avoiding 64-bit division something can be gained.

Re speed: on Phenom II in 32-bit mode, I see ~x3.3 speedup
on conversions involving large integers (might be skewed
by gcc's full-blown 64-bit division in "old" code - kernel's
div is smarter).


> PS. From Mr. Jones site: "Nonetheless, before relying on the material
> here, it would be prudent to check the arithmetic!" hence I checked
> all the calculations myself and everything seemed fine.  I've also run
> test applitacion several times so it tested a few 64-bit numbers..."

I tested [0, 100 million] and [2^64-100 million, 2^64-1] ranges.
No errors.


> +#if BITS_PER_LONG != 32 || defined CONFIG_CC_OPTIMIZE_FOR_SIZE || \
> +	ULLONG_MAX != 18446744073709551615ULL

I think it's better to say "if BITS_PER_LONG > 32 and ULLONG_MAX > 2^64-1",
since it expresses your intent better. Also, add comments explaining
what case you optimize for:

#if BITS_PER_LONG > 32 || ULLONG_MAX > 18446744073709551615ULL

/* Generic code */
...

#else /* BITS_PER_LONG <= 32 && ULLONG_MAX <= 2^64-1 */

/* Optimized code for arches with 64-bit long longs */
...


> +static noinline_for_stack
> +char *put_dec(char *buf, unsigned long long n)
> +{
> +	uint32_t d3, d2, d1, q;
> +
> +	if (!n) {
> +		*buf++ = '0';
> +		return buf;
> +	}

You may as well use the above shortcut for n <= 9, not only for 0.

> +	buf = put_dec_full4(buf, q % 10000);
> +	q   = q / 10000;
> +
> +	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
> +	buf = put_dec_full4(buf, d1 % 10000);
> +	q   = d1 / 10000;

I experimented with moving division up, before put_dec_full4:
q   = d1 / 10000;
buf = put_dec_full4(buf, d1 % 10000);
but gcc appears to be smart emough to do this transformation
itself. But you may still do it for older (dumber) gcc's.

-- 
vda
