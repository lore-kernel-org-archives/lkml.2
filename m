Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2A0Wr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:47:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab2A0Wrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:47:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dedekind1@gmail.com
Subject: Re: [PATCH] PM / MTD: Fix regressions related to mtd_suspend()
Date: Fri, 27 Jan 2012 23:51:32 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201201151443.30897.rjw@sisk.pl> <201201160018.02305.rjw@sisk.pl> <1326705441.14299.10.camel@sauron.fi.intel.com>
In-Reply-To: <1326705441.14299.10.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201272351.32455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012, Artem Bityutskiy wrote:
> Thanks Rafael!
> 
> I've pushed this patch to l2-mtd-2.6.git (David, would you please merge
> it upstream?).
> 
> Rafael, should I add some tags with your name like Tested-by or
> Acked-by?
> 
> 
> From d0eb0d769923d562781fcf43fdc6fa28e3823756 Mon Sep 17 00:00:00 2001
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Date: Mon, 16 Jan 2012 11:07:16 +0200
> Subject: [PATCH] mtd: fix MTD suspend
> 
> Commits 3fe4bae88460869a8e553397cd9057a4ee7ca341 and
> 079c985e7a6f4ce60f931cebfdd5ee3c3 broke MTD suspend in 2 ways:
> 
> 1. When the '->suspend' method is not present, we return -EOPNOTSUPP, but
>    the callers of 'mtd_suspend()' expects 0 instead.
> 2. Checking of the 'mtd' parameter against NULL has been incorrectly removed
>    in 'mtd_cls_suspend()'.
> 
> This patch fixes the breakages. This has been found, analyzed, reported
> and tested by Rafael J. Wysocki <rjw@sisk.pl>.

Reported-and-tested-by: Rafael J. Wysocki <rjw@sisk.pl>

Is there any plan to push this patch to Linus for 3.3?  It fixes a rather
nasty suspend regression.

Thanks,
Rafael


> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  drivers/mtd/mtdcore.c   |    2 +-
>  include/linux/mtd/mtd.h |    4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index b265188..de96865 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -119,7 +119,7 @@ static int mtd_cls_suspend(struct device *dev, pm_message_t state)
>  {
>         struct mtd_info *mtd = dev_get_drvdata(dev);
>  
> -       return mtd_suspend(mtd);
> +       return mtd ? mtd_suspend(mtd) : 0;
>  }
>  
>  static int mtd_cls_resume(struct device *dev)
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 1a81fde..d8c7aad 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -427,9 +427,7 @@ static inline int mtd_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>  
>  static inline int mtd_suspend(struct mtd_info *mtd)
>  {
> -       if (!mtd->suspend)
> -               return -EOPNOTSUPP;
> -       return mtd->suspend(mtd);
> +       return mtd->suspend ? mtd->suspend(mtd) : 0;
>  }
>  
>  static inline void mtd_resume(struct mtd_info *mtd)
> 

