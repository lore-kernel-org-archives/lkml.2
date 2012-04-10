Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2DJQuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:50:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48968 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2DJQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:50:49 -0400
Date: Tue, 10 Apr 2012 18:50:44 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410165044.GA3229@joi.lan>
References: <4F717CE3.4040206@suse.cz>
 <4F717D80.9040207@suse.cz>
 <4F758400.3080907@suse.cz>
 <1333104359_155028@CP5-2952>
 <4F75A303.3030409@suse.cz>
 <1333110296_156038@CP5-2952>
 <4F7F60BF.9070500@suse.cz>
 <4F83F4B6.3090503@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F83F4B6.3090503@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:52:06AM +0200, Jiri Slaby wrote:
> On 04/06/2012 11:31 PM, Jiri Slaby wrote:
> > On 03/30/2012 02:24 PM, Chris Wilson wrote:
> >> On Fri, 30 Mar 2012 14:11:47 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> >>> On 03/30/2012 12:45 PM, Chris Wilson wrote:
> >>>> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> >>>>> I don't know what to dump more, because iir is obviously zero too. What
> >>>>> other sources of interrupts are on the (G33) chip?
> >>>>
> >>>> IIR is the master interrupt, with chained secondary interrupt statuses.
> >>>> If IIR is 0, the interrupt wasn't raised by the GPU.
> >>>
> >>> This does not make sense, the handler does something different. Even if
> >>> IIR is 0, it still takes a look at pipe stats.
> >>
> >> That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
> >> a race where the pipestat triggered an interrupt after we processed the
> >> secondary registers and before reseting the primary.
> >>
> >> But the basic premise that we should only enter the interrupt handler
> >> with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).
> > 
> > Ok, this behavior is definitely new. I get several "nobody cared" about
> > this interrupt a week. This never used to happen. And something weird
> > emerges in /proc/interrupts when this happens:
> >  42:    1003292    1212890   PCI-MSI-edge      �s����:0000:00:02.0
> > instead of
> >  42:    1006715    1218472   PCI-MSI-edge      i915@pci:0000:00:02.0
> 
> See the difference of drm_device->devname:
> 
> Before:
> 20 34 32 3a 20 20 20 20  31 34 30 35 34 36 32 20  | 42:    1405462 |
> 20 20 20 31 37 32 38 33  30 32 20 20 20 50 43 49  |   1728302   PCI|
> 2d 4d 53 49 2d 65 64 67  65 20 20 20 20 20 20 69  |-MSI-edge      i|
> 39 31 35 40 70 63 69 3a  30 30 30 30 3a 30 30 3a  |915@pci:0000:00:|
> 30 32 2e 30 0a                                    |02.0.|
> 
> After:
> 20 34 32 3a 20 20 20 20  31 30 30 33 32 39 32 20  | 42:    1003292 |
> 20 20 20 31 32 31 32 38  39 30 20 20 20 50 43 49  |   1212890   PCI|
> 2d 4d 53 49 2d 65 64 67  65 20 20 20 20 20 20 ef  |-MSI-edge      .|
> bf bd 73 ef bf bd ef bf  bd ef bf bd ef bf bd 3a  |..s............:|
> 30 30 30 30 3a 30 30 3a  30 32 2e 30 0a           |0000:00:02.0.|
> 
> Any idea what "ef bf bd" pattern could be? And who *shifts* the
> "0000:00:02.0" string?
> 

Maybe this patch will help catch it:

---
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index cf85155..2f9717c 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -69,7 +69,7 @@ static void
 drm_unset_busid(struct drm_device *dev,
 		struct drm_master *master)
 {
-	kfree(dev->devname);
+	free_pages((unsigned long)dev->devname, 0);
 	dev->devname = NULL;
 
 	kfree(master->unique);
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 13f3d93..d788b78 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -177,9 +177,7 @@ int drm_pci_set_busid(struct drm_device *dev, struct drm_master *master)
 	} else
 		master->unique_len = len;
 
-	dev->devname =
-		kmalloc(strlen(pdriver->name) +
-			master->unique_len + 2, GFP_KERNEL);
+	dev->devname = (void *)__get_free_pages(GFP_KERNEL, 0);
 
 	if (dev->devname == NULL) {
 		ret = -ENOMEM;
@@ -188,6 +186,7 @@ int drm_pci_set_busid(struct drm_device *dev, struct drm_master *master)
 
 	sprintf(dev->devname, "%s@%s", pdriver->name,
 		master->unique);
+	set_memory_ro((unsigned long)dev->devname, 1);
 
 	return 0;
 err:
@@ -217,8 +216,7 @@ int drm_pci_set_unique(struct drm_device *dev,
 	master->unique[master->unique_len] = '\0';
 
 	bus_name = dev->driver->bus->get_name(dev);
-	dev->devname = kmalloc(strlen(bus_name) +
-			       strlen(master->unique) + 2, GFP_KERNEL);
+	dev->devname = (void *)__get_free_pages(GFP_KERNEL, 0);
 	if (!dev->devname) {
 		ret = -ENOMEM;
 		goto err;
@@ -226,6 +224,7 @@ int drm_pci_set_unique(struct drm_device *dev,
 
 	sprintf(dev->devname, "%s@%s", bus_name,
 		master->unique);
+	set_memory_ro((unsigned long)dev->devname, 1);
 
 	/* Return error if the busid submitted doesn't match the device's actual
 	 * busid.
diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index 82431dc..aa0acec 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -148,9 +148,7 @@ static int drm_platform_set_busid(struct drm_device *dev, struct drm_master *mas
 		goto err;
 	}
 
-	dev->devname =
-		kmalloc(strlen(dev->platformdev->name) +
-			master->unique_len + 2, GFP_KERNEL);
+	dev->devname = (void *)__get_free_pages(GFP_KERNEL, 0);
 
 	if (dev->devname == NULL) {
 		ret = -ENOMEM;
@@ -159,6 +157,8 @@ static int drm_platform_set_busid(struct drm_device *dev, struct drm_master *mas
 
 	sprintf(dev->devname, "%s@%s", dev->platformdev->name,
 		master->unique);
+	set_memory_ro((unsigned long)dev->devname, 1);
+
 	return 0;
 err:
 	return ret;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index aa454f8..4f53c0f 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -187,7 +187,7 @@ static void drm_master_destroy(struct kref *kref)
 		master->unique_len = 0;
 	}
 
-	kfree(dev->devname);
+	free_pages((unsigned long)dev->devname, 0);
 	dev->devname = NULL;
 
 	list_for_each_entry_safe(pt, next, &master->magicfree, head) {
@@ -494,7 +494,7 @@ void drm_put_dev(struct drm_device *dev)
 
 	list_del(&dev->driver_item);
 	if (dev->devname) {
-		kfree(dev->devname);
+		free_pages((unsigned long)dev->devname, 0);
 		dev->devname = NULL;
 	}
 	kfree(dev);
