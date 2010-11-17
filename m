Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab0KQP4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:56:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55197 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934749Ab0KQP4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:56:04 -0500
Date: Wed, 17 Nov 2010 10:56:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        USB list <linux-usb@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the usb tree
In-Reply-To: <20101117042053.GB2999@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1011171049130.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Greg KH wrote:

> On Wed, Nov 17, 2010 at 01:14:53PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
> > drivers/media/video/tlg2300/pd-main.c:455: error: 'struct usb_device' has no member named 'autosuspend_delay'
> > drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
> > drivers/net/wimax/i2400m/usb.c:517: error: 'struct usb_device' has no member named 'autosuspend_delay'
> > 
> > Caused by commit fcc4a01eb8661226e80632327673f67bf6a5840b ("USB: use the
> > runtime-PM autosuspend implementation").  More grepping required ...
> > 
> > I have used the usb tree from next-20101116 for today.
> 
> Ick.  Alan, care to provide a patch?

Here it is.  I'm not sure that having this code at all is really the
best approach.  It means the drivers will override any autosuspend
values set by userspace when their devices are first detected.

Also there are bogus calls to device_init_wakeup(), and truly silly
preprocessor tests of the kernel version in the staging-tree file.  
Nevertheless, this is the minimal fix.

Alan Stern


---------------------------------------------------------------------------

USB: fix leftover references to udev->autosuspend_delay

This patch (as1436) takes care of leftover references to
udev->autosuspend_delay that didn't get removed during the earlier
conversion to the runtime-PM autosuspend API.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/media/video/tlg2300/pd-main.c
===================================================================
--- usb-2.6.orig/drivers/media/video/tlg2300/pd-main.c
+++ usb-2.6/drivers/media/video/tlg2300/pd-main.c
@@ -452,7 +452,8 @@ static int poseidon_probe(struct usb_int
 
 	device_init_wakeup(&udev->dev, 1);
 #ifdef CONFIG_PM
-	pd->udev->autosuspend_delay = HZ * PM_SUSPEND_DELAY;
+	pm_runtime_set_autosuspend_delay(&pd->udev->dev,
+			1000 * PM_SUSPEND_DELAY);
 	usb_enable_autosuspend(pd->udev);
 
 	if (in_hibernation(pd)) {
Index: usb-2.6/drivers/net/wimax/i2400m/usb.c
===================================================================
--- usb-2.6.orig/drivers/net/wimax/i2400m/usb.c
+++ usb-2.6/drivers/net/wimax/i2400m/usb.c
@@ -514,7 +514,7 @@ int i2400mu_probe(struct usb_interface *
 #ifdef CONFIG_PM
 	iface->needs_remote_wakeup = 1;		/* autosuspend (15s delay) */
 	device_init_wakeup(dev, 1);
-	usb_dev->autosuspend_delay = 15 * HZ;
+	pm_runtime_set_autosuspend_delay(&usb_dev->dev, 15000);
 	usb_enable_autosuspend(usb_dev);
 #endif
 
Index: usb-2.6/drivers/staging/bcm/InterfaceInit.c
===================================================================
--- usb-2.6.orig/drivers/staging/bcm/InterfaceInit.c
+++ usb-2.6/drivers/staging/bcm/InterfaceInit.c
@@ -277,7 +277,7 @@ usbbcm_device_probe(struct usb_interface
 		if(psAdapter->bDoSuspend)
 		{
 #ifdef CONFIG_PM
-			udev->autosuspend_delay = 0;
+			pm_runtime_set_autosuspend_delay(&udev->dev, 0);
 			intf->needs_remote_wakeup = 1;
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 35)
  			udev->autosuspend_disabled = 0;

