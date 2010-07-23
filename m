Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab0GWNN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:13:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56822 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab0GWNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EqrZBIonvMean1itC55J7CrjuIv2fuylE99KQ8UFrdd6DAb9mrIY9bTDQxqUyiQ2UG
         AsGaPsISksm+UcOvwICCGDOF+zGpOamZcy5YaLWXPVpvyq84SUT5GcFuXlTKELhYxIZF
         0Zo18Dfhut8pYO4hC+brAULya7tfxSmDe6drU=
Date: Fri, 23 Jul 2010 15:10:34 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH v2] vga16fb: refuse to load in face of other driver
 controlling primary card
Message-ID: <20100723131034.GA6618@joi.lan>
References: <20100720191923.GA11056@joi.lan>
 <20100722172039.e935c67d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722172039.e935c67d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 05:20:39PM -0700, Andrew Morton wrote:
> On Tue, 20 Jul 2010 21:19:23 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > We don't want vga16fb to mess with hardware initialized by other driver.
> > Detect it and refuse to load.
> > It fixes nouveau interrupt storm on some machines.
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > ---
> >  drivers/video/vga16fb.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> > index 28ccab4..4505446 100644
> > --- a/drivers/video/vga16fb.c
> > +++ b/drivers/video/vga16fb.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/screen_info.h>
> >  
> > +#include <asm/fb.h>
> >  #include <asm/io.h>
> >  #include <video/vga.h>
> >  
> > @@ -1415,7 +1416,7 @@ static struct platform_device *vga16fb_device;
> >  
> >  static int __init vga16fb_init(void)
> >  {
> > -	int ret;
> > +	int ret, i;
> >  #ifndef MODULE
> >  	char *option = NULL;
> >  
> > @@ -1424,6 +1425,16 @@ static int __init vga16fb_init(void)
> >  
> >  	vga16fb_setup(option);
> >  #endif
> > +	for (i = 0 ; i < FB_MAX; i++) {
> > +		if (!registered_fb[i])
> > +			continue;
> > +		if (fb_is_primary_device(registered_fb[i])) {
> > +			printk(KERN_INFO "vga16fb: %s is driving the primary card, refusing to load\n",
> > +				registered_fb[i]->fix.id);
> > +			return -EBUSY;
> > +		}
> > +	}
> > +
> >  	ret = platform_driver_register(&vga16fb_driver);
> >  
> >  	if (!ret) {
> 
> This seems pretty hacky, and specific to vga16fb.
> 
> Is vga16fb.c the only fbdev driver (now and forever more) which can
> grab the hardware from under a different driver's feet?

It's the only unaccelerated framebuffer which can be loaded _after_
real framebuffer (at least on x86). efifb and vesafb can only be compiled
statically and they are kicked off when accelerated driver is loaded - there's
no way to reload them later.
 
> This is the basic and very common problem of two drivers diddling the
> same hardware, yes?  A common way of preventing such collisions is to
> perform a suitably-checked request_region() in both drivers.  Whichever
> driver gets there second will get a failure and will bale out cleanly. 
> Can that mechanism be made to work in this case?

I implemented this approach (patch below), but I still needed to modify
vga16fb - it really is a special framebuffer.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] vga16fb: refuse to load in face of other driver controlling primary card

We don't want vga16fb to mess with hardware initialized by other driver.
Detect it and refuse to load.
It fixes nouveau interrupt storm on some machines.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/video/fbmem.c   |   33 ++++++++++++++++++++++++++++++++-
 drivers/video/vga16fb.c |   12 ++++++++++++
 include/linux/fb.h      |    3 +++
 3 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 731fce6..cb19cae 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1504,6 +1504,7 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
 }
 
 #define VGA_FB_PHYS 0xA0000
+#define VGA_FB_PHYS_LEN 65536
 void remove_conflicting_framebuffers(struct apertures_struct *a,
 				     const char *name, bool primary)
 {
@@ -1532,6 +1533,17 @@ void remove_conflicting_framebuffers(struct apertures_struct *a,
 }
 EXPORT_SYMBOL(remove_conflicting_framebuffers);
 
+struct resource *request_vga_mem_region(const char *name)
+{
+	struct resource *res = request_mem_region(VGA_FB_PHYS,
+						VGA_FB_PHYS_LEN, name);
+	if (res == NULL)
+		printk(KERN_INFO "%s: other driver owns the primary card, refusing to load\n",
+				  name);
+	return res;
+}
+EXPORT_SYMBOL(request_vga_mem_region);
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1548,6 +1560,8 @@ register_framebuffer(struct fb_info *fb_info)
 	int i;
 	struct fb_event event;
 	struct fb_videomode mode;
+	bool primary;
+	struct resource *res = fb_info->resource;
 
 	if (num_registered_fb == FB_MAX)
 		return -ENXIO;
@@ -1555,8 +1569,19 @@ register_framebuffer(struct fb_info *fb_info)
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
+	primary = fb_is_primary_device(fb_info);
 	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
-					 fb_is_primary_device(fb_info));
+					primary);
+
+	/*
+	 * if the card is primary and the resource was not already allocated
+	 * by framebuffer driver then lock vga memory region
+	 */
+	if (primary && res == NULL) {
+		res = request_vga_mem_region(fb_info->fix.id);
+		if (res == NULL)
+			return -EBUSY;
+	}
 
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
@@ -1574,6 +1599,7 @@ register_framebuffer(struct fb_info *fb_info)
 		fb_info->dev = NULL;
 	} else
 		fb_init_device(fb_info);
+	fb_info->resource = res;
 
 	if (fb_info->pixmap.addr == NULL) {
 		fb_info->pixmap.addr = kmalloc(FBPIXMAPSIZE, GFP_KERNEL);
@@ -1658,6 +1684,11 @@ unregister_framebuffer(struct fb_info *fb_info)
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
+	if (fb_info->resource) {
+		release_mem_region(fb_info->resource->start,
+				   resource_size(fb_info->resource));
+		fb_info->resource = NULL;
+	}
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 28ccab4..952ae43 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1307,6 +1307,16 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 	struct vga16fb_par *par;
 	int i;
 	int ret = 0;
+	struct resource *res;
+
+	/*
+	 * We have to do it here instead of relying on register_framebuffer - it
+	 * won't request that region because vga16fb won't be detected as primary
+	 * driver, because it's not directly connected to pci layer.
+	 */
+	res = request_vga_mem_region("vga16fb");
+	if (!res)
+		return -EBUSY;
 
 	printk(KERN_DEBUG "vga16fb: initializing\n");
 	info = framebuffer_alloc(sizeof(struct vga16fb_par), &dev->dev);
@@ -1321,6 +1331,7 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 		goto err_ioremap;
 	}
 
+	info->resource = res;
 	/* XXX share VGA_FB_PHYS and I/O region with vgacon and others */
 	info->screen_base = (void __iomem *)VGA_MAP_MEM(VGA_FB_PHYS, 0);
 
@@ -1390,6 +1401,7 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
  err_ioremap:
 	framebuffer_release(info);
  err_fb_alloc:
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 8e5a9df..fc90804 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -868,6 +868,8 @@ struct fb_info {
 			resource_size_t size;
 		} ranges[0];
 	} *apertures;
+
+	struct resource *resource;
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
@@ -971,6 +973,7 @@ extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
 extern void remove_conflicting_framebuffers(struct apertures_struct *a,
 				const char *name, bool primary);
+extern struct resource *request_vga_mem_region(const char *name);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);
-- 
1.7.1.1

