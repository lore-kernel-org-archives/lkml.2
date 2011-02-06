Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1BFLQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:16:10 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33400 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1BFLQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:16:04 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/3] uvesafb,vesafb: create WC or WB PAT entries
Date: Sun, 6 Feb 2011 12:11:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic-pae; KDE/4.5.5; i686; ; )
Cc: Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201011271437.38126.thomas.schlichter@web.de> <20101130061051.GD17114@linux-sh.org> <201102061202.09503.thomas.schlichter@web.de>
In-Reply-To: <201102061202.09503.thomas.schlichter@web.de>
MIME-Version: 1.0
Message-Id: <201102061211.55554.thomas.schlichter@web.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7HoTN4FpkgZoJzp"
X-Provags-ID: V01U2FsdGVkX18y7t8MNYrgIkqmn4VA1/vaRLRl5rCjhAID63Xd
	p1hxwHFl7Ylx94hi4DTOMJNsE7hQj98SIZq2F5KbzqV5lo+ty2
	SefBNwMzGckmAsGWhb5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7HoTN4FpkgZoJzp
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit



--Boundary-00=_7HoTN4FpkgZoJzp
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0001-uvesafb-vesafb-create-WC-or-WB-PAT-entries.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-uvesafb-vesafb-create-WC-or-WB-PAT-entries.patch"

>From 7172689eb500a7ab7090e8539f88d382fc686336 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 27 Nov 2010 14:17:55 +0100
Subject: [PATCH 1/3] uvesafb,vesafb: create WC or WB PAT-entries

with an PAT-enabled kernel, when using uvesafb or vesafb, these drivers will
create uncached-minus PAT entries for the framebuffer memory because they use
ioremap() (not the *_cache or *_wc variants). When the framebuffer memory
intersects with the video RAM used by Xorg, the complete video RAM will be
mapped uncached-minus what results in a serve performance penalty.

Here are the correct MTRR entries created by uvesafb:
schlicht@netbook:~$ cat /proc/mtrr
reg00: base=0x000000000 ( 0MB), size= 2048MB, count=1: write-back
reg01: base=0x06ff00000 ( 1791MB), size= 1MB, count=1: uncachable
reg02: base=0x070000000 ( 1792MB), size= 256MB, count=1: uncachable
reg03: base=0x0d0000000 ( 3328MB), size= 16MB, count=1: write-combining

And here are the problematic PAT entries:
schlicht@netbook:~$ sudo cat /sys/kernel/debug/x86/pat_memtype_list
PAT memtype list:
write-back @ 0x0-0x1000
uncached-minus @ 0x6fedd000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee3000-0x6fee4000
uncached-minus @ 0x6fee3000-0x6fee4000
uncached-minus @ 0x6fee3000-0x6fee4000
uncached-minus @ 0xd0000000-0xe0000000 <-- created by xserver-xorg
uncached-minus @ 0xd0000000-0xd1194000 <-- created by uvesafb
uncached-minus @ 0xf4000000-0xf4009000
uncached-minus @ 0xf4200000-0xf4400000
uncached-minus @ 0xf5000000-0xf5010000
uncached-minus @ 0xf5100000-0xf5104000
uncached-minus @ 0xf5400000-0xf5404000
uncached-minus @ 0xf5404000-0xf5405000
uncached-minus @ 0xf5404000-0xf5405000
uncached-minus @ 0xfed00000-0xfed01000

Therefore I created the attached patch for uvesafb which uses ioremap_wc() to
create the correct PAT entries, as shown below:
schlicht@netbook:~$ sudo cat /sys/kernel/debug/x86/pat_memtype_list
PAT memtype list:
write-back @ 0x0-0x1000
uncached-minus @ 0x6fedd000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee2000-0x6fee3000
uncached-minus @ 0x6fee3000-0x6fee4000
uncached-minus @ 0x6fee3000-0x6fee4000
uncached-minus @ 0x6fee3000-0x6fee4000
write-combining @ 0xd0000000-0xe0000000
write-combining @ 0xd0000000-0xd1194000
uncached-minus @ 0xf4000000-0xf4009000
uncached-minus @ 0xf4200000-0xf4400000
uncached-minus @ 0xf5000000-0xf5010000
uncached-minus @ 0xf5100000-0xf5104000
uncached-minus @ 0xf5400000-0xf5404000
uncached-minus @ 0xf5404000-0xf5405000
uncached-minus @ 0xf5404000-0xf5405000
uncached-minus @ 0xfed00000-0xfed01000

This results in a performance gain, objectively measurable with e.g.
x11perf -comppixwin10 -comppixwin100 -comppixwin500:
1: x11perf_xaa.log
2: x11perf_xaa_patched.log

       1                2 Operation
-------- ---------------- -----------------
124000.0 202000.0 ( 1.63) Composite 10x10 from pixmap to window
  3340.0  24400.0 ( 7.31) Composite 100x100 from pixmap to window
   131.0   1150.0 ( 8.78) Composite 500x500 from pixmap to window

You can see the serve performance gain when composing larger pixmaps to window.

The patches replace the ioremap() function with the variant matching the mtrr-
parameter. To create "write-back" PAT entries, the ioremap_cache() function
must be called after creating the MTRR entries, and the ioremap_cache() region
must completely fit into the MTRR region, this is why the MTRR region size is
now rounded up to the next power-of-two.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 drivers/video/uvesafb.c |   49 +++++++++++++++++++++++++++++++++-------------
 drivers/video/vesafb.c  |   44 +++++++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 52ec095..2d6f799 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1552,8 +1552,7 @@ static void __devinit uvesafb_init_mtrr(struct fb_info *info)
 			int rc;
 
 			/* Find the largest power-of-two */
-			while (temp_size & (temp_size - 1))
-				temp_size &= (temp_size - 1);
+			temp_size = roundup_pow_of_two(temp_size);
 
 			/* Try and find a power of two to add */
 			do {
@@ -1566,6 +1565,28 @@ static void __devinit uvesafb_init_mtrr(struct fb_info *info)
 #endif /* CONFIG_MTRR */
 }
 
+static void __devinit uvesafb_ioremap(struct fb_info *info)
+{
+#ifdef CONFIG_X86
+	switch (mtrr) {
+	case 1: /* uncachable */
+		info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
+		break;
+	case 2: /* write-back */
+		info->screen_base = ioremap_cache(info->fix.smem_start, info->fix.smem_len);
+		break;
+	case 3: /* write-combining */
+		info->screen_base = ioremap_wc(info->fix.smem_start, info->fix.smem_len);
+		break;
+	case 4: /* write-through */
+	default:
+		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
+		break;
+	}
+#else
+	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
+#endif /* CONFIG_X86 */
+}
 
 static ssize_t uvesafb_show_vbe_ver(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -1736,15 +1757,22 @@ static int __devinit uvesafb_probe(struct platform_device *dev)
 
 	uvesafb_init_info(info, mode);
 
+	if (!request_region(0x3c0, 32, "uvesafb")) {
+		printk(KERN_ERR "uvesafb: request region 0x3c0-0x3e0 failed\n");
+		err = -EIO;
+		goto out_mode;
+	}
+
 	if (!request_mem_region(info->fix.smem_start, info->fix.smem_len,
 				"uvesafb")) {
 		printk(KERN_ERR "uvesafb: cannot reserve video memory at "
 				"0x%lx\n", info->fix.smem_start);
 		err = -EIO;
-		goto out_mode;
+		goto out_reg;
 	}
 
-	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
+	uvesafb_init_mtrr(info);
+	uvesafb_ioremap(info);
 
 	if (!info->screen_base) {
 		printk(KERN_ERR
@@ -1755,20 +1783,13 @@ static int __devinit uvesafb_probe(struct platform_device *dev)
 		goto out_mem;
 	}
 
-	if (!request_region(0x3c0, 32, "uvesafb")) {
-		printk(KERN_ERR "uvesafb: request region 0x3c0-0x3e0 failed\n");
-		err = -EIO;
-		goto out_unmap;
-	}
-
-	uvesafb_init_mtrr(info);
 	platform_set_drvdata(dev, info);
 
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR
 			"uvesafb: failed to register framebuffer device\n");
 		err = -EINVAL;
-		goto out_reg;
+		goto out_unmap;
 	}
 
 	printk(KERN_INFO "uvesafb: framebuffer at 0x%lx, mapped to 0x%p, "
@@ -1785,12 +1806,12 @@ static int __devinit uvesafb_probe(struct platform_device *dev)
 
 	return 0;
 
-out_reg:
-	release_region(0x3c0, 32);
 out_unmap:
 	iounmap(info->screen_base);
 out_mem:
 	release_mem_region(info->fix.smem_start, info->fix.smem_len);
+out_reg:
+	release_region(0x3c0, 32);
 out_mode:
 	if (!list_empty(&info->modelist))
 		fb_destroy_modelist(&info->modelist);
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 6a069d0..a99bbe8 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -303,19 +303,6 @@ static int __init vesafb_probe(struct platform_device *dev)
 	info->apertures->ranges[0].base = screen_info.lfb_base;
 	info->apertures->ranges[0].size = size_total;
 
-	info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
-	if (!info->screen_base) {
-		printk(KERN_ERR
-		       "vesafb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
-			vesafb_fix.smem_len, vesafb_fix.smem_start);
-		err = -EIO;
-		goto err;
-	}
-
-	printk(KERN_INFO "vesafb: framebuffer at 0x%lx, mapped to 0x%p, "
-	       "using %dk, total %dk\n",
-	       vesafb_fix.smem_start, info->screen_base,
-	       size_remap/1024, size_total/1024);
 	printk(KERN_INFO "vesafb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
 	       vesafb_defined.xres, vesafb_defined.yres, vesafb_defined.bits_per_pixel, vesafb_fix.line_length, screen_info.pages);
 
@@ -438,8 +425,7 @@ static int __init vesafb_probe(struct platform_device *dev)
 			int rc;
 
 			/* Find the largest power-of-two */
-			while (temp_size & (temp_size - 1))
-				temp_size &= (temp_size - 1);
+			temp_size = roundup_pow_of_two(temp_size);
 
 			/* Try and find a power of two to add */
 			do {
@@ -451,6 +437,34 @@ static int __init vesafb_probe(struct platform_device *dev)
 	}
 #endif
 	
+	switch (mtrr) {
+	case 1: /* uncachable */
+		info->screen_base = ioremap_nocache(vesafb_fix.smem_start, vesafb_fix.smem_len);
+		break;
+	case 2: /* write-back */
+		info->screen_base = ioremap_cache(vesafb_fix.smem_start, vesafb_fix.smem_len);
+		break;
+	case 3: /* write-combining */
+		info->screen_base = ioremap_wc(vesafb_fix.smem_start, vesafb_fix.smem_len);
+		break;
+	case 4: /* write-through */
+	default:
+		info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
+		break;
+	}
+	if (!info->screen_base) {
+		printk(KERN_ERR
+		       "vesafb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
+			vesafb_fix.smem_len, vesafb_fix.smem_start);
+		err = -EIO;
+		goto err;
+	}
+
+	printk(KERN_INFO "vesafb: framebuffer at 0x%lx, mapped to 0x%p, "
+	       "using %dk, total %dk\n",
+	       vesafb_fix.smem_start, info->screen_base,
+	       size_remap/1024, size_total/1024);
+
 	info->fbops = &vesafb_ops;
 	info->var = vesafb_defined;
 	info->fix = vesafb_fix;
-- 
1.7.1


--Boundary-00=_7HoTN4FpkgZoJzp--
