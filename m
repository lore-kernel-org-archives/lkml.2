Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab2JaIFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:05:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52205 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab2JaIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:05:25 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Tony Lindgren <tony@atomide.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Josh <joshua.taylor0@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org
Subject: [PATCH 1/3] input: do not use tasklet_disable before tasklet_kill
Date: Wed, 31 Oct 2012 16:05:59 +0800
Message-Id: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tasklet_disable() is called before related tasklet handled,
tasklet_kill will never be finished. tasklet_kill is enough.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> 
Cc: Tony Lindgren <tony@atomide.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>
Cc: Josh <joshua.taylor0@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/omap-keypad.c |    3 +--
 drivers/input/serio/hil_mlc.c        |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 4a5fcc8..6c52447 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -362,12 +362,11 @@ static int __devexit omap_kp_remove(struct platform_device *pdev)
 	struct omap_kp *omap_kp = platform_get_drvdata(pdev);
 
 	/* disable keypad interrupt handling */
-	tasklet_disable(&kp_tasklet);
+	tasklet_kill(&kp_tasklet);
 	omap_writew(1, OMAP1_MPUIO_BASE + OMAP_MPUIO_KBD_MASKIT);
 	free_irq(omap_kp->irq, omap_kp);
 
 	del_timer_sync(&omap_kp->timer);
-	tasklet_kill(&kp_tasklet);
 
 	/* unregister everything */
 	input_unregister_device(omap_kp->input);
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index bfd3865..7fc1700 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -1011,7 +1011,6 @@ static void __exit hil_mlc_exit(void)
 {
 	del_timer_sync(&hil_mlcs_kicker);
 
-	tasklet_disable(&hil_mlcs_tasklet);
 	tasklet_kill(&hil_mlcs_tasklet);
 }
 
-- 
1.7.9.5

