Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2IATmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:42:07 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:36922 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2IATmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:04 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPAG1kQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6NxSSHAObR4NFiUw
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="107233549"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 03/20] Input: Make sure we follow all EV_KEY events
Date: Sat,  1 Sep 2012 21:46:58 +0200
Message-Id: <1346528835-363-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
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
1.7.12

