Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2HFJ4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:56:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab2HFJ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:56:24 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v3 4/4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available
Date: Mon,  6 Aug 2012 18:55:24 +0900
Message-Id: <1344246924-32620-5-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb_mmap() implemented in fbmem.c uses smem_start as the physical
address of the frame buffer.  In the sh_mobile_lcdc driver, the
smem_start is a dma_addr_t that is not a physical address when IOMMU is
enabled.  dma_mmap_coherent() maps the address correctly.  It is
available on ARM platforms.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 drivers/video/sh_mobile_lcdcfb.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 8cb653b..c8cba7a 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -1614,6 +1614,17 @@ static int sh_mobile_lcdc_overlay_blank(int blank, struct fb_info *info)
 	return 1;
 }
 
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+static int
+sh_mobile_lcdc_overlay_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct sh_mobile_lcdc_overlay *ovl = info->par;
+
+	return dma_mmap_coherent(ovl->channel->lcdc->dev, vma, ovl->fb_mem,
+				 ovl->dma_handle, ovl->fb_size);
+}
+#endif
+
 static struct fb_ops sh_mobile_lcdc_overlay_ops = {
 	.owner          = THIS_MODULE,
 	.fb_read        = fb_sys_read,
@@ -1626,6 +1637,9 @@ static struct fb_ops sh_mobile_lcdc_overlay_ops = {
 	.fb_ioctl       = sh_mobile_lcdc_overlay_ioctl,
 	.fb_check_var	= sh_mobile_lcdc_overlay_check_var,
 	.fb_set_par	= sh_mobile_lcdc_overlay_set_par,
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+	.fb_mmap	= sh_mobile_lcdc_overlay_mmap,
+#endif
 };
 
 static void
@@ -2093,6 +2107,17 @@ static int sh_mobile_lcdc_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+static int
+sh_mobile_lcdc_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct sh_mobile_lcdc_chan *ch = info->par;
+
+	return dma_mmap_coherent(ch->lcdc->dev, vma, ch->fb_mem,
+				 ch->dma_handle, ch->fb_size);
+}
+#endif
+
 static struct fb_ops sh_mobile_lcdc_ops = {
 	.owner          = THIS_MODULE,
 	.fb_setcolreg	= sh_mobile_lcdc_setcolreg,
@@ -2108,6 +2133,9 @@ static struct fb_ops sh_mobile_lcdc_ops = {
 	.fb_release	= sh_mobile_lcdc_release,
 	.fb_check_var	= sh_mobile_lcdc_check_var,
 	.fb_set_par	= sh_mobile_lcdc_set_par,
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+	.fb_mmap	= sh_mobile_lcdc_mmap,
+#endif
 };
 
 static void
-- 
1.7.0.4

