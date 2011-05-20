Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948Ab1ETSVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:21:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55567 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748Ab1ETSVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yHUnGGJzdTXaDyqBDS8yT3Pj4AATaScNSPrKTzHPlQWeypgJBqSsqGIDxxv4kfZUAo
         TKpubeUUqJQzsNKkZMvknijTISaA1VErkG0IWxvN8MfQr8bBu/T3/ujUSM03u+i/Ra2l
         hiiYxeiqkBzAOaW5GWgue/1We7SNfLeop0B/o=
MIME-Version: 1.0
In-Reply-To: <20110520154341.GL31426@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
	<20633.1305565337@localhost>
	<BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com>
	<201105182144.37713.rjw@sisk.pl>
	<BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com>
	<BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
	<10124.1305906020@localhost>
	<20110520154341.GL31426@htj.dyndns.org>
Date: Fri, 20 May 2011 11:21:31 -0700
Message-ID: <BANLkTik0WV4+p+YWEKC0XataCh0Po_cEPg@mail.gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
From: Jian Peng <jipeng2005@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that I need fix my gmail setting to make it show up in LKML.

Hi, Tejun/Valdis,

Since this is an interoperability issue of SATA host controller, the
first step I want to try it to make sure the tweak that MAKE my
controller WORK does not break other controllers.
You are both right that adding this majic 5ms delay at this place
should not be the final solution.

If this magic 5ms delay works on other affected systems, I plan to
post a new patch that inside ahci_start_engine(), still perform same
check, and show warning message if failed, but will set a flag, then
still set START bit, and if there is such failure flag, add 5ms delay.

Valdis, could you apply the following patch and retest it?

Tejun, please review it.

--- a/drivers/ata/libahci.c 2011-05-18 14:23:36.564665643 -0700

+++ c/drivers/ata/libahci.c 2011-05-20 09:48:06.194663506 -0700
@@ -540,6 +540,7 @@

  void __iomem *port_mmio = ahci_port_base(ap);
  u32 tmp;
  u8 status;

+ int err = 0;


  status = readl(port_mmio + PORT_TFDATA) & 0xFF;


@@ -553,12 +554,12 @@

   * specific controller will fail under this condition
   */
  if (status & (ATA_BUSY | ATA_DRQ))
-  return;

+  err = 1;

  else {
   ahci_scr_read(&ap->link, SCR_STATUS, &tmp);

   if ((tmp & 0xf) != 0x3)
-   return;

+   err = 1;
  }

  /* start DMA */
@@ -566,6 +567,13 @@
  tmp |= PORT_CMD_START;
  writel(tmp, port_mmio + PORT_CMD);
  readl(port_mmio + PORT_CMD); /* flush */
+
+ /* Some controllers need longer time to be ready */
+ if(err) {
+  printk(KERN_WARNING
+   "Controller in wrong state when setting START bit\n");
+  msleep(5);
+ }
 }
 EXPORT_SYMBOL_GPL(ahci_start_engine);

On Fri, May 20, 2011 at 8:43 AM, Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, May 20, 2011 at 11:40:20AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 18 May 2011 17:14:56 PDT, Jian Peng said:
> >
> > > > @@ -1353,6 +1332,8 @@
> > > >
> > > >
> > > >   ahci_start_engine(ap);
> > > >
> > > > + msleep(5);
> > > > +
> > > >   if (online)
> > > >
> > > >    *class = ahci_dev_classify(ap);
> > > >
> >
> > It may very well be that adding a magic msleep(5) here just Makes It Work, but
> > I have a gut feeling that it's in the wrong place (for starters, 'online' can't change
> > during the msleep() unless somebody *else* sets it - in which case the locking
> > is screwed up as we're not forcing a re-read of the value).  The msleep() probably
> > needs to be before something else further down in the code (but I have no idea
> > exactly what).
>
> At this point, I think it would be better to simply add a flag and
> enable the check for the affected controller.
>
> Thanks.
>
> --
> tejun
