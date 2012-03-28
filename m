Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab2C1TuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:50:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17924 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab2C1TuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:50:17 -0400
Date: Wed, 28 Mar 2012 15:45:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen/xenbus: Add quirk to deal with
 misconfigured backends.
Message-ID: <20120328194540.GA11825@phenom.dumpdata.com>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1203221040030.15151@kaball-desktop>
 <1332413546.8817.64.camel@zakaz.uk.xensource.com>
 <20120322132102.GA22545@phenom.dumpdata.com>
 <alpine.DEB.2.00.1203221511380.15151@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203221511380.15151@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F736B73.0062,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 03:16:43PM +0000, Stefano Stabellini wrote:
> On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > On Thu, Mar 22, 2012 at 10:52:26AM +0000, Ian Campbell wrote:
> > > On Thu, 2012-03-22 at 10:44 +0000, Stefano Stabellini wrote:
> > > > On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > > > > A rather annoying and common case is when booting a PVonHVM guest
> > > > > and exposing the PV KBD and PV VFB - as both of those do not
> > > > > make any sense. The HVM guest is using the VGA driver and the emulated
> > > > > keyboard for this. So we provide a very basic quirk framework
> > > > > (can be expanded in the future) to not wait for 6 minutes for those devices
> > > > > to initialize - they never wont.
> > > > > 
> > > > > To trigger this, put this in your guest config:
> > > > > 
> > > > > vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> > > > > 
> > > > > instead of this:
> > > > > vnc=1
> > > > > vnclisten="0.0.0.0"
> > > > 
> > > > While I do understand the issue you are trying to solve, it actually
> > > > makes sense to have PV KBD (and PV VFB maybe in the future) in a PVonHVM
> > > > guest. In particular PV KVB is already enabled in upstream QEMU for
> > > > PVonHVM guests because it allows users to have a keyboard and mouse
> > 
> > How about looking for a particular Xen version? The patch
> > could check for anything less than 4.2 (does 4.2 use that version of
> > QEMU that has this implemented?). I can't find any way to get the QEMU
> > version from within the guest - DMI reports:
> > 
> > DMI: Xen HVM domU, BIOS 4.1-120322 03/22/2012
> 
> I am not a great fun of enabling/disabling features depending on the Xen
> version. What happens for example if a Linux distro decided to patch
> QEMU 4.1 to enable PV KBD for PVonHVM guests?
> I realize that it is unlikely but it is possible.
> Maybe we can reduce the timeout for non essential devices (everything
> expect disk, network and console) like Ian suggested?

Please take a look:

>From 85c9c09c69e3b4a277b2c930ca0a295f5bacc696 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 28 Mar 2012 14:55:45 -0400
Subject: [PATCH] xen/xenbus: Add quirk to deal with misconfigured backends.

A rather annoying and common case is when booting a PVonHVM guest
and exposing the PV KBD and PV VFB - as both of those do not
make any sense. The HVM guest is using the VGA driver and the emulated
keyboard for this (in Xen 4.2 and lower). We provide a very basic quirk
framework to not wait for 6 minutes for those devices to initialize.

To trigger this, put this in your guest config:

vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']

instead of this:
vnc=1
vnclisten="0.0.0.0"

Note: The upstream QEMU can do PV KBD, so we can't just outright ignore
the keyboard driver. Instead we change the timeout for that particular
device to be much less.

[v1: Redo with timeout per Ian and Stefano suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_probe_frontend.c |   39 ++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index f20c5f1..09da9cf 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -157,7 +157,40 @@ static int is_device_connecting(struct device *dev, void *data)
 		(xendev->state == XenbusStateConnected &&
 		 xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
+static int check_for_quirks(struct device *dev, void *data)
+{
+	struct xenbus_device *xendev = to_xenbus_device(dev);
+	struct device_driver *drv = data;
+
+	/* Is this operation limited to a particular driver? */
+	if (drv && (dev->driver != drv))
+		return false;
+
+	if (xen_pv_domain())
+		return false;
 
+	/* With older QEMU, for PVonHVM guests the guest config files could
+	 * contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
+	 * which is nonsensical as there is no PV FB (or PV KBD) when
+	 * running as HVM guest - at least with Xen 4.1 and Xen 4.2. */
+
+	if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
+		return true;
+
+	if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
+		return true;
+
+	return false;
+}
+#define QUIRKS_TIMEOUT		30
+#define DEFAULT_TIMEOUT		300
+static unsigned int check_for_timeout_quirks(struct device_driver *drv, unsigned int timeout)
+{
+	if (bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
+				check_for_quirks))
+		return QUIRKS_TIMEOUT;
+	return timeout;
+}
 static int exists_connecting_device(struct device_driver *drv)
 {
 	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
@@ -211,18 +244,20 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	unsigned long start = jiffies;
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 	unsigned int seconds_waited = 0;
+	unsigned int max_delay = DEFAULT_TIMEOUT;
 
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
+	max_delay = min(check_for_timeout_quirks(drv, max_delay), max_delay);
 	while (exists_connecting_device(drv)) {
 		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
 			if (!seconds_waited)
 				printk(KERN_WARNING "XENBUS: Waiting for "
 				       "devices to initialise: ");
 			seconds_waited += 5;
-			printk("%us...", 300 - seconds_waited);
-			if (seconds_waited == 300)
+			printk("%us...", max_delay - seconds_waited);
+			if (seconds_waited == max_delay)
 				break;
 		}
 
-- 
1.7.7.5

