Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2HLVkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:39 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52503 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2HLVjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:35 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OAA8iKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaDQYlF
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="173154325"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 04/19] Input: Make sure we follow all EV_KEY events
Date: Sun, 12 Aug 2012 23:42:22 +0200
Message-Id: <1344807757-2217-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some EV_KEY types, sending a larger-than-one value causes the
input state to oscillate. This patch makes sure this cannot happen,
clearing up the autorepeat bypass logic in the process.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 8ebf116..4d64500 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -239,24 +239,30 @@ static void input_handle_event(struct input_dev *dev,
 		break;
 
 	case EV_KEY:
-		if (is_event_supported(code, dev->keybit, KEY_MAX) &&
-		    !!test_bit(code, dev->key) != value) {
+		if (is_event_supported(code, dev->keybit, KEY_MAX)) {
+
+			/* auto-repeat bypasses state updates */
+			if (value == 2) {
+				disposition = INPUT_PASS_TO_HANDLERS;
+				break;
+			}
+
+			if (!!test_bit(code, dev->key) != !!value) {
 
-			if (value != 2) {
 				__change_bit(code, dev->key);
+				disposition = INPUT_PASS_TO_HANDLERS;
+
 				if (value)
 					input_start_autorepeat(dev, code);
 				else
 					input_stop_autorepeat(dev);
 			}
-
-			disposition = INPUT_PASS_TO_HANDLERS;
 		}
 		break;
 
 	case EV_SW:
 		if (is_event_supported(code, dev->swbit, SW_MAX) &&
-		    !!test_bit(code, dev->sw) != value) {
+		    !!test_bit(code, dev->sw) != !!value) {
 
 			__change_bit(code, dev->sw);
 			disposition = INPUT_PASS_TO_HANDLERS;
@@ -283,7 +289,7 @@ static void input_handle_event(struct input_dev *dev,
 
 	case EV_LED:
 		if (is_event_supported(code, dev->ledbit, LED_MAX) &&
-		    !!test_bit(code, dev->led) != value) {
+		    !!test_bit(code, dev->led) != !!value) {
 
 			__change_bit(code, dev->led);
 			disposition = INPUT_PASS_TO_ALL;
-- 
1.7.11.4

