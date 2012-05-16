Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2EPOfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2EPOfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:35:05 -0400
Date: Wed, 16 May 2012 16:34:48 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] Support non-BMP characters in UDF
Message-ID: <20120516143448.GD27661@quack.suse.cz>
References: <4FB2E25E.900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB2E25E.900@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-05-12 01:10:22, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> I also have a counterpart for mkudffs/udf-tools but sourceforge homepage
> seems to be abandoned does anybody know if there is a new homepage for
> mkudffs?
  Thanks for the patch! It looks OK but shouldn't we rather use the helper
functions you introduced in the NLS code? It look wrong to replicate
decoding of UTF16 here.

								Honza
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> ---
>  fs/udf/unicode.c |   28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index 9b1b2de..2d8cc12 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -280,6 +280,14 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
>  		if (cmp_id == 16)
>  			c = (c << 8) | ocu[i++];
>  
> +		if (cmp_id == 16 && (c & 0xfc00) == 0xd800
> +		    && i + 1 < ocu_len && ((ocu[i] & 0xfc) == 0xdc)) {
> +			uint16_t l;
> +			l = ocu[i++] << 8;
> +			l |= ocu[i++];
> +			c = (((c & 0x3ff) << 10) | (l & 0x3ff)) + 0x10000;
> +		}
> +
>  		len = nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
>  				    UDF_NAME_LEN - utf_o->u_len);
>  		/* Valid character? */
> @@ -312,20 +320,30 @@ try_again:
>  		if (!len)
>  			continue;
>  		/* Invalid character, deal with it */
> -		if (len < 0 || uni_char > 0xffff) {
> +		if (len < 0 || uni_char > 0x10ffff) {
>  			len = 1;
>  			uni_char = '?';
>  		}
>  
>  		if (uni_char > max_val) {
> -			max_val = 0xffffU;
> +			max_val = 0x10ffffU;
>  			ocu[0] = (uint8_t)0x10U;
>  			goto try_again;
>  		}
>  
> -		if (max_val == 0xffffU)
> -			ocu[++u_len] = (uint8_t)(uni_char >> 8);
> -		ocu[++u_len] = (uint8_t)(uni_char & 0xffU);
> +		if (uni_char > 0xffff) {
> +			u16 h, l;
> +			h = 0xd800 | (((uni_char - 0x10000) >> 10) & 0x3ff);
> +			l = 0xdc00 | ((uni_char - 0x10000) & 0x3ff);
> +			ocu[++u_len] = (uint8_t)(h >> 8);
> +			ocu[++u_len] = (uint8_t)(h & 0xffU);
> +			ocu[++u_len] = (uint8_t)(l >> 8);
> +			ocu[++u_len] = (uint8_t)(l & 0xffU);
> +		} else {
> +			if (max_val == 0x10ffffU)
> +				ocu[++u_len] = (uint8_t)(uni_char >> 8);
> +			ocu[++u_len] = (uint8_t)(uni_char & 0xffU);
> +		}
>  		i += len - 1;
>  	}
>  
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
