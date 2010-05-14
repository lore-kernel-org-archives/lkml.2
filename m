Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0ENQNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:13:00 -0400
Received: from landau.phys.spbu.ru ([195.19.235.38]:48631 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0ENQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:12:58 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 May 2010 12:12:58 EDT
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: David Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>
Subject: [PATCH 2/2] drm: Prefix info printk about registering panic notifier with 'drm'
Date: Fri, 14 May 2010 19:45:16 +0400
Message-Id: <6bd8fc34532c307ce2b89f7b32cd6ab52c3927b8.1273851443.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.1.87.gcc8c60.dirty
In-Reply-To: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
References: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
References: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I've studied my system dmesg and seen this:

  <lots of stuff before>
1 [    0.478416] ACPI: Battery Slot [C1B4] (battery present)
2 [    0.478648] ACPI: Battery Slot [C1B3] (battery absent)
3 [    0.906678] [drm] initialized overlay support
4 [    1.762304] Console: switching to colour frame buffer device 128x48
5 [    1.765211] fb0: inteldrmfb frame buffer device
6 [    1.765242] registered panic notifier
7 [    1.765272] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
8 [    1.765372] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
  <lots of stuff after>

and it was not evident who registered that panic notifier on line 6.

I'd bought it as some low-level stuff needed by kernel itself, but the
time was inappropriate -- too late for such things.

So I had to study sources to see it was drm who was registering
switch-to-fb on panic.

Let's avoid possible confusion and mark this message as going from drm
subsystem.

(I'm a bit unsure whether to use '[drm]:' or 'drm:' -- the rest of the
 kernel just uses 'topic:', and even in drm_fb_helper.c we use 'fb%d:'
 without [] brackets. Either way is ok with me.)

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 288ea2f..90f1331 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -912,7 +912,7 @@ int drm_fb_helper_single_fb_probe(struct drm_device *dev,
 	/* Switch back to kernel console on panic */
 	/* multi card linked list maybe */
 	if (list_empty(&kernel_fb_helper_list)) {
-		printk(KERN_INFO "registered panic notifier\n");
+		printk(KERN_INFO "drm: registered panic notifier\n");
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &paniced);
 		register_sysrq_key('v', &sysrq_drm_fb_helper_restore_op);
@@ -926,7 +926,7 @@ void drm_fb_helper_free(struct drm_fb_helper *helper)
 {
 	list_del(&helper->kernel_fb_list);
 	if (list_empty(&kernel_fb_helper_list)) {
-		printk(KERN_INFO "unregistered panic notifier\n");
+		printk(KERN_INFO "drm: unregistered panic notifier\n");
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &paniced);
 		unregister_sysrq_key('v', &sysrq_drm_fb_helper_restore_op);
-- 
1.7.1.87.gcc8c60.dirty
