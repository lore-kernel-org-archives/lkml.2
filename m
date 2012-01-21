Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2AUAsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:48:52 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44937 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751906Ab2AUAsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:48:51 -0500
Message-ID: <4F1A1927.7020206@xenotime.net>
Date: Fri, 20 Jan 2012 17:47:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: djwong@us.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] crc32: Don't reference unnecessary crc32 tables in	single-bit
 mode
References: <20120121003652.GD2749@tux1.beaverton.ibm.com>
In-Reply-To: <20120121003652.GD2749@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 04:36 PM, Darrick J. Wong wrote:
> When compiling with single bit mode (CRC32_BIT=y) we shouldn't reference the
> crc32 tables, since they aren't built in single-bit mode.  Many thanks to Randy
> Dunlap for finding this bug:
> http://marc.info/?l=linux-kernel&m=132709702422141&w=2
> 
> This patch is against next-20120120.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> 
>  lib/crc32.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/crc32.c b/lib/crc32.c
> index ebc5911..b0d278f 100644
> --- a/lib/crc32.c
> +++ b/lib/crc32.c
> @@ -174,16 +174,26 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
>  	return crc;
>  }
>  
> +#if CRC_LE_BITS == 1
> +u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
> +}
> +u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
> +}
> +#else
>  u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
>  {
>  	return crc32_le_generic(crc, p, len, crc32table_le, CRCPOLY_LE);
>  }
> -EXPORT_SYMBOL(crc32_le);
> -
>  u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
>  {
>  	return crc32_le_generic(crc, p, len, crc32ctable_le, CRC32C_POLY_LE);
>  }
> +#endif
> +EXPORT_SYMBOL(crc32_le);
>  EXPORT_SYMBOL(__crc32c_le);
>  
>  /**
> @@ -233,10 +243,17 @@ static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
>  	return crc;
>  }
>  
> +#if CRC_LE_BITS == 1
> +u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
> +}
> +#else
>  u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
>  {
>  	return crc32_be_generic(crc, p, len, crc32table_be, CRCPOLY_BE);
>  }
> +#endif
>  EXPORT_SYMBOL(crc32_be);
>  
>  #ifdef CONFIG_CRC32_SELFTEST
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
