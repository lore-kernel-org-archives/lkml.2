Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2AOXix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 18:38:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab2AOXiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 18:38:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dedekind1@gmail.com
Subject: Re: [PATCH] PM / MTD: Fix regressions related to mtd_suspend()
Date: Mon, 16 Jan 2012 00:18:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
References: <201201151443.30897.rjw@sisk.pl> <1326637306.2201.22.camel@koala>
In-Reply-To: <1326637306.2201.22.camel@koala>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201160018.02305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 15, 2012, Artem Bityutskiy wrote:
> On Sun, 2012-01-15 at 14:43 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit 3fe4bae88460869a8e553397cd9057a4ee7ca341 (mtd: introduce
> > mtd_suspend interface) introduced the mtd_suspend() routine
> > which didn't check whether or not mtd and mtd->suspend were
> > both valid pointers.  Later commit 079c985e7a6f4ce60f931cebfdd5ee3c3
> > (mtd: do not use mtd->suspend and mtd->resume directly) added the
> > check for mtd->suspend, but still it failed to check mtd.  Moreover,
> > it caused mtd_suspend() to return an error code for NULL
> > mtd->suspend, which makes system suspend fail on one of my test
> > systems on every attempt and which is a regression from v3.2.
> > 
> > Fix mtd_suspend() by making it check if mtd is not NULL and
> > return 0 if mtd or mtd->suspend is NULL, which shouldn't prevent
> > the system from suspending.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  include/linux/mtd/mtd.h |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Index: linux/include/linux/mtd/mtd.h
> > ===================================================================
> > --- linux.orig/include/linux/mtd/mtd.h
> > +++ linux/include/linux/mtd/mtd.h
> > @@ -427,9 +427,7 @@ static inline int mtd_is_locked(struct m
> >  
> >  static inline int mtd_suspend(struct mtd_info *mtd)
> >  {
> > -	if (!mtd->suspend)
> > -		return -EOPNOTSUPP;
> > -	return mtd->suspend(mtd);
> > +	return mtd && mtd->suspend ? mtd->suspend(mtd) : 0;
> >  }
> 
> Thanks! But All the MTD API functions assume that the "mtd" pointer is
> non-NULL, and this function should to the same for consistency.
> 
> Would you please give this patch a test?

Yes, this works too.

Thanks,
Rafael


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
> 

