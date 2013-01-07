Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3AGBwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:52:33 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:26056 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3AGBwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:52:30 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v2] media: cx18, ivtv: eliminate unnecessary array index checks
Date: Sun,  6 Jan 2013 20:52:03 -0500
Message-Id: <1357523523-39707-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idx values passed to cx18_i2c_register() and ivtv_i2c_register()
by cx18_init_subdevs() and ivtv_load_and_init_modules() respectively
are always in-range, based on how the hw_all bitmask is populated.
Previously, the checks were already ineffective because arrays were
being dereferenced using the index before the check.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
Thanks to Andy Walls for suggesting that instead of moving the checks
before array dereference, a better fix is to remove the checks altogether,
since they are superfluous.

 drivers/media/pci/cx18/cx18-i2c.c |    3 ---
 drivers/media/pci/ivtv/ivtv-i2c.c |    2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 4908eb7..ccb1d15 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -116,9 +116,6 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 	const char *type = hw_devicenames[idx];
 	u32 hw = 1 << idx;
 
-	if (idx >= ARRAY_SIZE(hw_addrs))
-		return -1;
-
 	if (hw == CX18_HW_TUNER) {
 		/* special tuner group handling */
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 46e262b..bc984af 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -267,8 +267,6 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 	const char *type = hw_devicenames[idx];
 	u32 hw = 1 << idx;
 
-	if (idx >= ARRAY_SIZE(hw_addrs))
-		return -1;
 	if (hw == IVTV_HW_TUNER) {
 		/* special tuner handling */
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
-- 
1.7.10.4

