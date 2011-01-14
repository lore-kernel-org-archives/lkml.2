Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1ANN2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:28:52 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:45887 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab1ANN2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:28:44 -0500
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so we
 always kfree() and remember to call va_end()
From: David Safford <safford@watson.ibm.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: David Howells <dhowells@redhat.com>, David Safford <safford@us.ibm.com>,
        James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 Jan 2011 08:28:02 -0500
Message-ID: <1295011682.7804.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 21:07 +0100, Jesper Juhl wrote:
> In security/keys/trusted_defined.c::TSS_rawhmac() we may leak the storage 
> allocated to 'sdesc' if
>   data = va_arg(argp, unsigned char *);
> results in a NULL 'data' and we then leave the function by returning 
> -EINVAL. We also neglect calling va_end(argp) in that case and furthermore 
> we neglect va_end(argp) if
>   ret = crypto_shash_update(&sdesc->shash, data, dlen);
> results in ret being negative and we then jump to the 'out' label.
> 
> I believe this patch takes care of these issues. Please review and 
> consider for inclusion.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

thanks for catching this.

Acked-by: David Safford <safford@watson.ibm.com>

> ---
>  trusted_defined.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
>   compile tested only.
> 
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index 975e9f2..0ec7ab8 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -101,16 +101,18 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
>  		if (dlen == 0)
>  			break;
>  		data = va_arg(argp, unsigned char *);
> -		if (data == NULL)
> -			return -EINVAL;
> +		if (data == NULL) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>  		ret = crypto_shash_update(&sdesc->shash, data, dlen);
>  		if (ret < 0)
>  			goto out;
>  	}
> -	va_end(argp);
>  	if (!ret)
>  		ret = crypto_shash_final(&sdesc->shash, digest);
>  out:
> +	va_end(argp);
>  	kfree(sdesc);
>  	return ret;
>  }
> 
> 
> 

