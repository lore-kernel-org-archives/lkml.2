Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2AJKWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:22:19 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42536 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2AJKWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:22:17 -0500
Date: Tue, 10 Jan 2012 11:21:43 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <20120110100541.38a3940f@de.ibm.com>
Message-ID: <alpine.LFD.2.02.1201101119230.1750@c4eb>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org> <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org> <20120110100541.38a3940f@de.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
x-cbid: 12011010-8372-0000-0000-00000150C89F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jan 2012, Martin Schwidefsky wrote:

> On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
> > drivers/s390/cio/device.c:1687:       put_driver(drv);
> > 
> > Martin, these calls seem to be useless.  The calls in ccwgroup.c are 
> > definitely useless; there's no reason to take a reference to a driver 
> > while it's being unregistered, since it can't go away until the 
> > unregistration is finished.
> 
> The get_driver/put_driver in ccwgroup.c are obviously useless, the caller
> passed ccwgroup_driver_unregister a ccwgroup_driver reference.
> I am not so sure about the code in device.c. get_ccwdev_by_busid() gets
> used e.g. by vmur like this:
> 
> static struct ccw_driver ur_driver = { .. };
> 
> static struct urdev *urdev_get_from_devno(u16 devno)
> {
> 	..
> 	sprintf(bus_id, "0.0.%04x", devno);
>         cdev = get_ccwdev_by_busid(&ur_driver, bus_id);
> 	..
> }
> 
> static int ur_open(struct inode *inode, struct file *file)
> {
> 	..
> 	urd = urdev_get_from_devno(devno);
> 	..
> }
> 
> For vmur we should be safe by the fact that ur_open is only possible if
> a try_module_get has been successful and the ccw_driver is unregistered
> only in the module exit function. But we have to check if this is true
> for all users of the get_ccwdev_by_busid() function.

Done.
[PATCH] cio: remove {get,put}_driver

Remove useless {get,put}_driver - the caller of the functions
has to ensure valid driver pointers.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/s390/cio/ccwgroup.c |    2 --
 drivers/s390/cio/device.c   |    8 +-------
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -580,7 +580,6 @@ void ccwgroup_driver_unregister(struct c
 	struct device *dev;
 
 	/* We don't want ccwgroup devices to live longer than their driver. */
-	get_driver(&cdriver->driver);
 	while ((dev = driver_find_device(&cdriver->driver, NULL, NULL,
 					 __ccwgroup_match_all))) {
 		struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
@@ -592,7 +591,6 @@ void ccwgroup_driver_unregister(struct c
 		mutex_unlock(&gdev->reg_mutex);
 		put_device(dev);
 	}
-	put_driver(&cdriver->driver);
 	driver_unregister(&cdriver->driver);
 }
 EXPORT_SYMBOL(ccwgroup_driver_unregister);
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1676,15 +1676,9 @@ struct ccw_device *get_ccwdev_by_busid(s
 				       const char *bus_id)
 {
 	struct device *dev;
-	struct device_driver *drv;
 
-	drv = get_driver(&cdrv->driver);
-	if (!drv)
-		return NULL;
-
-	dev = driver_find_device(drv, NULL, (void *)bus_id,
+	dev = driver_find_device(&cdrv->driver, NULL, (void *)bus_id,
 				 __ccwdev_check_busid);
-	put_driver(drv);
 
 	return dev ? to_ccwdev(dev) : NULL;
 }



> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

