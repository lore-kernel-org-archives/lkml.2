Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab2AZJMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:12:16 -0500
Received: from mga10.intel.com ([192.55.52.92]:7215 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154Ab2AZJMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:12:13 -0500
MIME-Version: 1.0
In-Reply-To: <DBB740589CE8814680DECFE34BE197AB166593@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1324967446-28939-1-git-send-email-b29237@freescale.com>
	<DBB740589CE8814680DECFE34BE197AB166593@039-SN1MPN1-006.039d.mgd.msft.net>
Date: Thu, 26 Jan 2012 01:12:11 -0800
Message-ID: <CABE8wwv+iA_apPUCrLHgG-QiyHTuOfvZwPbJ7=zbTEQ3TgKQCw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: async_xor, fix zero address issue when xor
 highmem page
From: Dan Williams <dan.j.williams@intel.com>
To: Shi Xuelin-B29237 <B29237@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/10 Shi Xuelin-B29237 <B29237@freescale.com>:
> Hello Dan Williams,
>
> Do you have any comment about this patch?

Hi, sorrry for the delay.

>
> Thanks,
> Forrest
>
> -----Original Message-----
> From: Shi Xuelin-B29237
> Sent: 2011年12月27日 14:31
> To: vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Li Yang-R58472
> Cc: Shi Xuelin-B29237
> Subject: [PATCH] dmaengine: async_xor, fix zero address issue when xor highmem page
>
> From: Forrest shi <b29237@freescale.com>
>
>        we may do_sync_xor high mem pages, in this case, page_address will
>        return zero address which cause a failure.

In what scenarios do we xor highmem?

In the case of raid we currently always xor on kmalloc'd memory.

>
>        this patch uses kmap_atomic before xor the pages and kunmap_atomic
>        after it.
>
>        Signed-off-by: b29237@freescale.com <xuelin.shi@freescale.com>
> ---
>  crypto/async_tx/async_xor.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c index bc28337..5b416d1 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -26,6 +26,7 @@
>  #include <linux/kernel.h>
>  #include <linux/interrupt.h>
>  #include <linux/mm.h>
> +#include <linux/highmem.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/raid/xor.h>
>  #include <linux/async_tx.h>
> @@ -126,7 +127,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
>            int src_cnt, size_t len, struct async_submit_ctl *submit)  {
>        int i;
> -       int xor_src_cnt = 0;
> +       int xor_src_cnt = 0, kmap_cnt=0;
>        int src_off = 0;
>        void *dest_buf;
>        void **srcs;
> @@ -138,11 +139,13 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
>
>        /* convert to buffer pointers */
>        for (i = 0; i < src_cnt; i++)
> -               if (src_list[i])
> -                       srcs[xor_src_cnt++] = page_address(src_list[i]) + offset;
> +               if (src_list[i]) {
> +                       srcs[xor_src_cnt++] = kmap_atomic(src_list[i], KM_USER1) + offset;
> +               }
> +       kmap_cnt = xor_src_cnt;

I guess this works now that we have stack based kmap_atomic, but on
older kernels you could not simultaneously map that many buffers with
a single kmap slot.  So if you resend, drop the second parameter to
kmap_atomic.

...but unless you have a non md/raid456 use case in mind, or have
patches to convert md/raid to xor straight out of the incoming biovecs
I don't think this patch is needed right?
