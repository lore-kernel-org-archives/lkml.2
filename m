Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2DCNp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:45:57 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32582 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2DCNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:45:56 -0400
Date: Tue, 3 Apr 2012 08:45:54 -0500
From: scameron@beardog.cce.hp.com
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com,
        mike.miller@beardog.cce.hp.com, mike.miller@hp.com,
        iss_storagedev@hp.com
Subject: Re: [PATCH] cciss: use check_signature 
Message-ID: <20120403134554.GO32669@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use check_signature to find a signature in the mmio address.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
> ---
>  drivers/block/cciss.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index bda6d12..e04c63e 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -42,8 +42,8 @@
>  #include <linux/compat.h>
>  #include <linux/mutex.h>
>  #include <linux/bitmap.h>
> +#include <linux/io.h>
>  #include <asm/uaccess.h>
> -#include <asm/io.h>
>  
>  #include <linux/dma-mapping.h>
>  #include <linux/blkdev.h>
> @@ -4267,10 +4267,7 @@ static void __devinit cciss_find_board_params(ctlr_info_t *h)
>  
>  static inline bool CISS_signature_present(ctlr_info_t *h)
>  {
> -       if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
> -           (readb(&h->cfgtable->Signature[1]) != 'I') ||
> -           (readb(&h->cfgtable->Signature[2]) != 'S') ||
> -           (readb(&h->cfgtable->Signature[3]) != 'S')) {
> +       if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {

I noticed that in lib/Makefile, there's this:

[scameron@localhost linux-3.4-rc1]$ grep CHECK_SIG lib/Makefile
obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
[scameron@localhost linux-3.4-rc1]$

although I don't see an '#if CONFIG_CHECK_SIGNATURE' in include/linux/io.h

Does there need to be a "select CHECK_SIGNATURE" added into
in drivers/block/Kconfig in this area?

config BLK_CPQ_CISS_DA
        tristate "Compaq Smart Array 5xxx support"
        depends on PCI
        help

Or is this dependency handled in some way I'm just not seeing?

-- steve

>                  dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
>                  return false;
>          }
> -- 
> 1.7.4.4
