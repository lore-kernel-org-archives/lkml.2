Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1CVUby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:31:54 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:55227 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1CVUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:31:52 -0400
Subject: [PATCH] Downgrade i8042 selftest error message to dbg()
From: Paul Bolle <pebolle@tiscali.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 21:31:48 +0100
Message-ID: <1300825908.20447.1.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a "really fragile" latop I noticed a single
    i8042.c: i8042 controller selftest failed. (0x1 != 0x55)

error in the log. But there's no reason to print this message at
KERN_ERR level each time that loop fails, especially since the message
telling about the overall selftest failure is printed at KERN_INFO level
(on X86).

Add an actual error message for non-X86 systems, where a selftest
failure is (apparently) more serious. Remove a space in an another error
message.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/input/serio/i8042.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index ac4c936..d37a48e 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -869,15 +869,15 @@ static int i8042_controller_selftest(void)
 	do {
 
 		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-			pr_err("i8042 controller self test timeout\n");
+			pr_err("i8042 controller selftest timeout\n");
 			return -ENODEV;
 		}
 
 		if (param == I8042_RET_CTL_TEST)
 			return 0;
 
-		pr_err("i8042 controller selftest failed. (%#x != %#x)\n",
-		       param, I8042_RET_CTL_TEST);
+		dbg("i8042 controller selftest: %#x != %#x\n",
+		    param, I8042_RET_CTL_TEST);
 		msleep(50);
 	} while (i++ < 5);
 
@@ -891,6 +891,7 @@ static int i8042_controller_selftest(void)
 	pr_info("giving up on controller selftest, continuing anyway...\n");
 	return 0;
 #else
+	pr_err("i8042 controller selftest failed\n");
 	return -EIO;
 #endif
 }
-- 
1.7.4

