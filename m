Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0IVLRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:17:13 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:49458
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab0IVLRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:17:12 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 07:17:12 EDT
From: Brian Rogers <brian@xyzw.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Rogers <brian@xyzw.org>
Subject: [PATCH] ir-core: Fix null dereferences in the protocols sysfs interface
Date: Wed, 22 Sep 2010 04:06:43 -0700
Message-Id: <1285153603-1527-1-git-send-email-brian@xyzw.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some cards, ir_dev->props and ir_dev->raw are both NULL. These cards are
using built-in IR decoding instead of raw, and can't easily be made to switch
protocols.

So upon reading /sys/class/rc/rc?/protocols on such a card, return 'builtin' as
the supported and enabled protocol. Return -EINVAL on any attempts to change
the protocol. And most important of all, don't crash.

Signed-off-by: Brian Rogers <brian@xyzw.org>
Acked-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-sysfs.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 96dafc4..46d4246 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -67,13 +67,14 @@ static ssize_t show_protocols(struct device *d,
 	char *tmp = buf;
 	int i;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
 		allowed = ir_dev->props->allowed_protos;
-	} else {
+	} else if (ir_dev->raw) {
 		enabled = ir_dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	}
+	} else
+		return sprintf(tmp, "[builtin]\n");
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
@@ -121,10 +122,14 @@ static ssize_t store_protocols(struct device *d,
 	int rc, i, count = 0;
 	unsigned long flags;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
 		type = ir_dev->rc_tab.ir_type;
-	else
+	else if (ir_dev->raw)
 		type = ir_dev->raw->enabled_protocols;
+	else {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -185,7 +190,7 @@ static ssize_t store_protocols(struct device *d,
 		}
 	}
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
 		ir_dev->rc_tab.ir_type = type;
 		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-- 
1.7.1

