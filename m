Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2HZMxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:53:38 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:44548 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2HZMxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:53:11 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApRZALMbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG7SRSSBQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="400013437"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 06/20] Input: Move autorepeat to the event-passing phase
Date: Sun, 26 Aug 2012 14:57:24 +0200
Message-Id: <1345985858-445-7-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing to split event filtering and event passing, move the
autorepeat function to the point where the event is actually passed.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 4d64500..a57c4a5 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -69,6 +69,22 @@ static int input_defuzz_abs_event(int value, int old_val, int fuzz)
 	return value;
 }
 
+static void input_start_autorepeat(struct input_dev *dev, int code)
+{
+	if (test_bit(EV_REP, dev->evbit) &&
+	    dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] &&
+	    dev->timer.data) {
+		dev->repeat_key = code;
+		mod_timer(&dev->timer,
+			  jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
+	}
+}
+
+static void input_stop_autorepeat(struct input_dev *dev)
+{
+	del_timer(&dev->timer);
+}
+
 /*
  * Pass event first through all filters and then, if event has not been
  * filtered out, through all open handles. This function is called with
@@ -105,6 +121,15 @@ static void input_pass_event(struct input_dev *dev,
 	}
 
 	rcu_read_unlock();
+
+	/* trigger auto repeat for key events */
+	if (type == EV_KEY && value != 2) {
+		if (value)
+			input_start_autorepeat(dev, code);
+		else
+			input_stop_autorepeat(dev);
+	}
+
 }
 
 /*
@@ -142,22 +167,6 @@ static void input_repeat_key(unsigned long data)
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 }
 
-static void input_start_autorepeat(struct input_dev *dev, int code)
-{
-	if (test_bit(EV_REP, dev->evbit) &&
-	    dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] &&
-	    dev->timer.data) {
-		dev->repeat_key = code;
-		mod_timer(&dev->timer,
-			  jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
-	}
-}
-
-static void input_stop_autorepeat(struct input_dev *dev)
-{
-	del_timer(&dev->timer);
-}
-
 #define INPUT_IGNORE_EVENT	0
 #define INPUT_PASS_TO_HANDLERS	1
 #define INPUT_PASS_TO_DEVICE	2
@@ -251,11 +260,6 @@ static void input_handle_event(struct input_dev *dev,
 
 				__change_bit(code, dev->key);
 				disposition = INPUT_PASS_TO_HANDLERS;
-
-				if (value)
-					input_start_autorepeat(dev, code);
-				else
-					input_stop_autorepeat(dev);
 			}
 		}
 		break;
-- 
1.7.12

