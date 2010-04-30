Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab0D3SC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:02:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933636Ab0D3SAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:00:47 -0400
Date: Fri, 30 Apr 2010 12:14:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       USB list <linux-usb@vger.kernel.org>, <linux-next@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: remove leftover references to udev->autosuspend_disabled
In-Reply-To: <20100430144128.GC1824@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1004301211040.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1373) fixes a couple of drivers outside the USB
subtree.  Devices are now disabled or enabled for autosuspend by
calling a core function instead of setting a flag.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Fri, 30 Apr 2010, Greg KH wrote:

> On Fri, Apr 30, 2010 at 03:52:24PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the staging-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
> > drivers/media/video/tlg2300/pd-main.c:457: error: 'struct usb_device' has no member named 'autosuspend_disabled'
> > drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
> > drivers/net/wimax/i2400m/usb.c:508: error: 'struct usb_device' has no member named 'autosuspend_disabled'
> > 
> > Caused by commit 3a03bb2443e8fb3b35666dc598e7f626519c544a ("USB: use PM
> > core routines to enable/disable autosuspend") from the usb tree.  I have
> > reverted that commit for today.
> 
> It would be good to get that back into the tree.  Alan, care to fix this
> up?
> 
> thanks,
> 
> greg k-h

Here's the fix.  I haven't compile-tested it, but the changes are
pretty simple.

Alan Stern


Index: usb-2.6/drivers/media/video/tlg2300/pd-main.c
===================================================================
--- usb-2.6.orig/drivers/media/video/tlg2300/pd-main.c
+++ usb-2.6/drivers/media/video/tlg2300/pd-main.c
@@ -455,8 +455,8 @@ static int poseidon_probe(struct usb_int
 
 	device_init_wakeup(&udev->dev, 1);
 #ifdef CONFIG_PM
-	pd->udev->autosuspend_disabled = 0;
 	pd->udev->autosuspend_delay = HZ * PM_SUSPEND_DELAY;
+	usb_enable_autosuspend(pd->udev);
 
 	if (in_hibernation(pd)) {
 		INIT_WORK(&pd->pm_work, hibernation_resume);
Index: usb-2.6/drivers/net/wimax/i2400m/usb.c
===================================================================
--- usb-2.6.orig/drivers/net/wimax/i2400m/usb.c
+++ usb-2.6/drivers/net/wimax/i2400m/usb.c
@@ -505,7 +505,7 @@ int i2400mu_probe(struct usb_interface *
 	iface->needs_remote_wakeup = 1;		/* autosuspend (15s delay) */
 	device_init_wakeup(dev, 1);
 	usb_dev->autosuspend_delay = 15 * HZ;
-	usb_dev->autosuspend_disabled = 0;
+	usb_enable_autosuspend(usb_dev);
 #endif
 
 	result = i2400m_setup(i2400m, I2400M_BRI_MAC_REINIT);

