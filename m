Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0DHDv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:51:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39301 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0DHDvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qWCq8AnFwjiuRibojFOQDcjdmjQFKYEQ7s362k7IgWt4bSVr26UCyhybulmQ3WE+Kh
         vmBL0stYYWJzoGSbj3ZhTAds+uc8MN9sYaoNsvCRY9GmQwwhmfix38a4lg6ELljqEPwP
         RNjcppnLSi6+Iqq08IqZ5IyonxlNTEb54K1ts=
MIME-Version: 1.0
In-Reply-To: <1270511567-18567-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> 
	<1270511567-18567-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 7 Apr 2010 23:51:04 -0400
Message-ID: <y2z8bd0f97a1004072051i3d309852zf3dc1b3ffb06d0ac@mail.gmail.com>
Subject: Re: [PATCH -mm 09/12] blackfin: use use asm-generic/scatterlist.h
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 19:52, FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Mike Frysinger <vapier@gentoo.org>
> ---
>  arch/blackfin/include/asm/scatterlist.h |   22 +---------------------
>  1 files changed, 1 insertions(+), 21 deletions(-)
>
> diff --git a/arch/blackfin/include/asm/scatterlist.h b/arch/blackfin/include/asm/scatterlist.h
> index 04f4487..64d41d3 100644
> --- a/arch/blackfin/include/asm/scatterlist.h
> +++ b/arch/blackfin/include/asm/scatterlist.h
> @@ -1,27 +1,7 @@
>  #ifndef _BLACKFIN_SCATTERLIST_H
>  #define _BLACKFIN_SCATTERLIST_H
>
> -#include <linux/mm.h>
> -
> -struct scatterlist {
> -#ifdef CONFIG_DEBUG_SG
> -       unsigned long sg_magic;
> -#endif
> -       unsigned long page_link;
> -       unsigned int offset;
> -       dma_addr_t dma_address;
> -       unsigned int length;
> -};
> -
> -/*
> - * These macros should be used after a pci_map_sg call has been done
> - * to get bus addresses of each of the SG entries and their lengths.
> - * You should only work with the number of sg entries pci_map_sg
> - * returns, or alternatively stop on the first sg_dma_len(sg) which
> - * is 0.
> - */
> -#define sg_dma_address(sg)      ((sg)->dma_address)
> -#define sg_dma_len(sg)          ((sg)->length)
> +#include <asm-generic/scatterlist.h>
>
>  #define ISA_DMA_THRESHOLD      (0xffffffff)

this is the same value as the common asm-generic one, so this define
should be punted, especially since this would probably introduce
redefined warnings.

once that is done, this header is simply a redirect, so it'd be better
if it was just one line:
#include <asm-generic/scatterlist.h>

one of the reasons i hadnt converted sooner was that it seems like the
common header introduces bloat.  the Blackfin header has just "length"
while the asm-generic has both "length" and "dma_length".  unless i
missed something, this hasnt been a problem for us.  perhaps the
common header should have something like:
#if __BITS_PER_LONG == 64
    unsigned int    dma_length;
#endif
this would match the existing sg_dma_len code.  or perhaps declare the
two lengths as an anonymous union.
-mike
