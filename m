Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1CYNkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:40:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56250 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1CYNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:40:14 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Input: sparse-keymap - report KEY_UNKNOWN for unknown scan codes
Date: Fri, 25 Mar 2011 08:40:03 -0500
Message-Id: <1301060403-19229-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301060403-19229-1-git-send-email-seth.forshee@canonical.com>
References: <20110325073554.GD2590@core.coreip.homeip.net>
 <1301060403-19229-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows for debugging non-functional keys easily from
userspace.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/input/sparse-keymap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index 74bca5d..fdb6a39 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -209,6 +209,7 @@ int sparse_keymap_setup(struct input_dev *dev,
 	}
 
 	if (test_bit(EV_KEY, dev->evbit)) {
+		__set_bit(KEY_UNKNOWN, dev->keybit);
 		__set_bit(EV_MSC, dev->evbit);
 		__set_bit(MSC_SCAN, dev->mscbit);
 	}
@@ -311,12 +312,19 @@ bool sparse_keymap_report_event(struct input_dev *dev, unsigned int code,
 {
 	const struct key_entry *ke =
 		sparse_keymap_entry_from_scancode(dev, code);
+	struct key_entry unknown_ke;
 
 	if (ke) {
 		sparse_keymap_report_entry(dev, ke, value, autorelease);
 		return true;
 	}
 
+	/* Report an unknown key event as a debugging aid */
+	unknown_ke.type = KE_KEY;
+	unknown_ke.code = code;
+	unknown_ke.keycode = KEY_UNKNOWN;
+	sparse_keymap_report_entry(dev, &unknown_ke, value, true);
+
 	return false;
 }
 EXPORT_SYMBOL(sparse_keymap_report_event);
-- 
1.7.4.1

