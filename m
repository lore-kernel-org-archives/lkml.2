Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816Ab2KAQdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:33:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50043 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2KAQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:33:18 -0400
From: Daniel J Blueman <daniel@quora.org>
To: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>, Marcin Slusarz <marcin.slusarz@gmail.com>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Fix nouveau hang after switcheroo
Date: Fri,  2 Nov 2012 00:32:59 +0800
Message-Id: <1351787579-17313-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After switcherooing to integrated and starting X, when X fails to start
and causes a console switch, we get hit with a hanger (below). Fix
by checking if we're already in D3.

BUG: soft lockup - CPU#0 stuck for 22s! [Xorg:1703]
 [<ffffffffa037c538>] nv04_timer_read+0x28/0x70 [nouveau]
 [<ffffffffa037bfec>] nouveau_timer_wait_eq+0x7c/0xe0 [nouveau]
 [<ffffffffa03f4f4e>] nvd0_sor_dpms+0xde/0x1a0 [nouveau]
 [<ffffffff813871d9>] ? fb_set_var+0xe9/0x3a0
 [<ffffffff811554a9>] ? __pte_alloc+0xa9/0x160
 [<ffffffffa03f4e70>] ? nvd0_sor_dp_link_set+0x2c0/0x2c0 [nouveau]
 [<ffffffffa00b2a5c>] drm_helper_connector_dpms+0xbc/0x100 [drm_kms_helper]
 [<ffffffffa00b1665>] drm_fb_helper_dpms.isra.13+0xa5/0xf0 [drm_kms_helper]
 [<ffffffffa00b16f9>] drm_fb_helper_blank+0x49/0x80 [drm_kms_helper]
 [<ffffffff81386e16>] fb_blank+0x56/0xc0
 [<ffffffff813887bb>] do_fb_ioctl+0x59b/0x5f0
 [<ffffffff81152883>] ? vma_interval_tree_insert+0x83/0x90
 [<ffffffff81388af5>] fb_ioctl+0x45/0x50
 [<ffffffff8119adda>] do_vfs_ioctl+0x8a/0x340
 [<ffffffff8119b121>] sys_ioctl+0x91/0xb0

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/gpu/drm/nouveau/nvd0_display.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvd0_display.c b/drivers/gpu/drm/nouveau/nvd0_display.c
index c402fca..c3285bf 100644
--- a/drivers/gpu/drm/nouveau/nvd0_display.c
+++ b/drivers/gpu/drm/nouveau/nvd0_display.c
@@ -1364,6 +1364,10 @@ nvd0_sor_dpms(struct drm_encoder *encoder, int mode)
 	int or = nv_encoder->or;
 	u32 dpms_ctrl;
 
+	/* prevent hanging after hardware is in D3 */
+	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return;
+
 	nv_encoder->last_dpms = mode;
 
 	list_for_each_entry(partner, &dev->mode_config.encoder_list, head) {
-- 
1.7.10.4

