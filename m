Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2AJKS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:18:56 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:34915 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2AJKSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:18:55 -0500
Date: Tue, 10 Jan 2012 11:18:13 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <20120110092046.GB32291@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.02.1201101114300.1750@c4eb>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org> <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org> <20120110100541.38a3940f@de.ibm.com> <20120110092046.GB32291@core.coreip.homeip.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
x-cbid: 12011010-8372-0000-0000-00000150C4FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012, Dmitry Torokhov wrote:
> On Tue, Jan 10, 2012 at 10:05:41AM +0100, Martin Schwidefsky wrote:
> > On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
> > > drivers/s390/cio/device.c:1687:       put_driver(drv);
> > > 
> > > Martin, these calls seem to be useless.  The calls in ccwgroup.c are 
> > > definitely useless; there's no reason to take a reference to a driver 
> > > while it's being unregistered, since it can't go away until the 
> > > unregistration is finished.
> > 
> > The get_driver/put_driver in ccwgroup.c are obviously useless, the caller
> > passed ccwgroup_driver_unregister a ccwgroup_driver reference.
> > I am not so sure about the code in device.c. get_ccwdev_by_busid() gets
> > used e.g. by vmur like this:
> 
> It does not matter how it is being used. Either get_ccwdev_by_busid()
> gets a valid driver structure or you already lost. You can not say that
> get_driver() protects anything, since if there is a chance driver can
> disappear it can disappear before we get to executing get_driver() code.
> 
> So while you might want to audit callers get/put_driver inside of
> get_ccwdev_by_busid() is utterly useless.

Yes, the caller has to ensure valid driver pointers. We have one offender
here:

[PATCH] zfcp: fops add owner

Set the owner member of zfcp_cfdc_fops, to ensure that the
caller of these functions holds a module reference.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_cfdc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -13,6 +13,7 @@
 
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
@@ -249,6 +250,7 @@ static long zfcp_cfdc_dev_ioctl(struct f
 }
 
 static const struct file_operations zfcp_cfdc_fops = {
+	.owner = THIS_MODULE,
 	.open = nonseekable_open,
 	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
 #ifdef CONFIG_COMPAT



> 
> Thanks.
> 
> -- 
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

