Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab2JaIzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:55:37 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:57608 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934894Ab2JaIz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:55:29 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 04:55:29 EDT
Message-ID: <20121031104520.45391yrgl3tgaza8@www.dalek.fi>
Date: Wed, 31 Oct 2012 10:45:20 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Behan Webster <behanw@converseincode.com>
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan-Simon =?iso-8859-1?b?TfZsbGVy?= <dl9pf@gmx.de>,
        pageexec@freemail.hu
Subject: Re: [PATCH 2/2] Remove VLAIS usage from crypto/testmgr.c
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
 <1351622249-18084-3-git-send-email-behanw@converseincode.com>
In-Reply-To: <1351622249-18084-3-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Behan Webster <behanw@converseincode.com>:

> From: Jan-Simon Möller <dl9pf@gmx.de>
>
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). This patch instead allocates the appropriate amount  
> of memory
> using an char array.
>
> Patch from series at
> http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> by PaX Team.
>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Cc: pageexec@freemail.hu
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  crypto/testmgr.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 941d75c..5b7b3a6 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1578,16 +1578,19 @@ static int alg_test_crc32c(const struct  
> alg_test_desc *desc,
>  	}
>
>  	do {
> -		struct {
> -			struct shash_desc shash;
> -			char ctx[crypto_shash_descsize(tfm)];
> -		} sdesc;
> -
> -		sdesc.shash.tfm = tfm;
> -		sdesc.shash.flags = 0;
> -
> -		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
> -		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
> +		char sdesc[sizeof(struct shash_desc)
> +			+ crypto_shash_descsize(tfm)
> +			+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
> +		struct shash_desc *shash = (struct shash_desc *)sdesc;
> +		u32 *ctx = (u32 *)((unsigned long)(sdesc
> +			+ sizeof(struct shash_desc) + CRYPTO_MINALIGN - 1)
> +			& ~(CRYPTO_MINALIGN - 1));

I think you should use '(u32 *)shash_desc_ctx(shash)' instead of  
getting ctx pointer manually.

> +
> +		shash->tfm = tfm;
> +		shash->flags = 0;
> +
> +		*ctx = le32_to_cpu(420553207);
> +		err = crypto_shash_final(shash, (u8 *)&val);
>  		if (err) {
>  			printk(KERN_ERR "alg: crc32c: Operation failed for "
>  			       "%s: %d\n", driver, err);



