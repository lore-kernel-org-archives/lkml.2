Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0DNWkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:40:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50847 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab0DNWkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rPmKOQj4WJwRC6kPhdOK56FvzyRky2Mp3P4S0lLgDZpPCdtlAOIqBJSxYufBN7pnhU
         CtQWx/C2UGhS/J/iB1wrMrZUKBYo57i47mW/q/tDVerLgqIiz2NP5o/K1dLEJJq+O16N
         /AZAb4yWtR7cfG3cEUYzfKqRzJW8T0E2wfZlY=
MIME-Version: 1.0
In-Reply-To: <1270681973-5763-1-git-send-email-linus.walleij@stericsson.com>
References: <1270681973-5763-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 14 Apr 2010 15:40:02 -0700
X-Google-Sender-Auth: e8a36dd855403b51
Message-ID: <r2re9c3a7c21004141540o90fcbb07ja92dffcd71364f8b@mail.gmail.com>
Subject: Re: [PATCH 05/11] ARM: add generic PrimeCell interface to COH 901 318 
	v5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Apr 7, 2010 at 4:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This extends the DMA engine driver for the COH 901 318 used in the
> U300 platform with the generic PrimeCell interface.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/dma/coh901318.c     |  146 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/coh901318_lli.c |   78 ++++++++++++++++++++++-
>  2 files changed, 221 insertions(+), 3 deletions(-)
>
[..]
> diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
> index 9f7e0e6..f37db49 100644
> --- a/drivers/dma/coh901318_lli.c
> +++ b/drivers/dma/coh901318_lli.c
> @@ -153,6 +153,39 @@ coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
>        lli->src_addr = src;
>        lli->dst_addr = dst;
>
> +       /*
> +        * The DMA hardware will increase its pointer by 1,
> +        * 2 or 4 bytes at a time depending on configuration.
> +        * If using som oddly-aligned buffer this will cause

s/som/some/

> +        * performance problems.
> +        */
> +#if 0
> +       ctrl_chained &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
> +       ctrl_eom &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
> +       ctrl_chained &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
> +       ctrl_eom &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
> +       if (src & 0x01) {
> +               ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
> +       } else if (src & 0x02) {
> +               ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
> +       } else {
> +               ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
> +       }
> +       if (dst & 0x01) {
> +               ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_SRC_DST_SIZE_8_BITS;
> +       } else if (dst & 0x02) {
> +               ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
> +       } else {
> +               ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
> +               ctrl_eom |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
> +       }
> +#endif

It looks like this bit twiddling code is duplicated three times.  Can
it be moved to a static inline in a header file and hide the #if 0
there as well.  I assume you want it for documentation purposes in
case someone in the future has an unaligned usage model?

--
Dan
