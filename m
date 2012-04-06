Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2DFVid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:38:33 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50955 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2DFVic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:38:32 -0400
From: Xi Wang <xi.wang@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] drm/savage: fix integer overflows in savage_bci_cmdbuf()
Date: Fri,  6 Apr 2012 17:38:24 -0400
Message-Id: <1333748304-11770-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cmdbuf->size and cmdbuf->nbox are from userspace, a large value
would overflow the allocation size, leading to out-of-bounds access.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/gpu/drm/savage/savage_state.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_state.c b/drivers/gpu/drm/savage/savage_state.c
index 031aaaf..b6d8608 100644
--- a/drivers/gpu/drm/savage/savage_state.c
+++ b/drivers/gpu/drm/savage/savage_state.c
@@ -988,7 +988,7 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 	 * for locking on FreeBSD.
 	 */
 	if (cmdbuf->size) {
-		kcmd_addr = kmalloc(cmdbuf->size * 8, GFP_KERNEL);
+		kcmd_addr = kmalloc_array(cmdbuf->size, 8, GFP_KERNEL);
 		if (kcmd_addr == NULL)
 			return -ENOMEM;
 
@@ -1015,8 +1015,8 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 		cmdbuf->vb_addr = kvb_addr;
 	}
 	if (cmdbuf->nbox) {
-		kbox_addr = kmalloc(cmdbuf->nbox * sizeof(struct drm_clip_rect),
-				    GFP_KERNEL);
+		kbox_addr = kmalloc_array(cmdbuf->nbox, sizeof(struct drm_clip_rect),
+					  GFP_KERNEL);
 		if (kbox_addr == NULL) {
 			ret = -ENOMEM;
 			goto done;
-- 
1.7.5.4

