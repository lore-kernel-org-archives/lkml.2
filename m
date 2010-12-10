Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0LJUmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:42:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:61460 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0LJUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:42:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: dmitry.torokhov@gmail.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kgdboc,input: Fix regression with keyboard release key and early debugging
Date: Fri, 10 Dec 2010 14:40:43 -0600
Message-Id: <1292013643-699-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 10 Dec 2010 20:42:05.0383 (UTC) FILETIME=[B4B53D70:01CB98AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=== NOTES excluded from the real commit ===

Dmitry, I added this commit into kgdb-next and I will send a pull
request to Linus Monday, unless someone comes up with an objection or
a different implementation.

Thanks,
Jason.

=== END NOTES ===

The commit 111c182340cd22e238ab1cc6564df336c6ebd7cb introduced a
regression in early debugging such that you get a kernel oops on
continue (with the go command) if you boot a kernel with:

    earlyprintk=vga ekgdboc=kbd kgdbwait

The restore input state routine which intended to send release key
events for any key that was depressed on entry to the debugger.  A
simple fix is to not invoke the schedule_work() if the kernel
system_state is anything other than SYSTEM_RUNNING.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/serial/kgdboc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3374618..25a8bc5 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -90,7 +90,8 @@ static DECLARE_WORK(kgdboc_restore_input_work, kgdboc_restore_input_helper);
 
 static void kgdboc_restore_input(void)
 {
-	schedule_work(&kgdboc_restore_input_work);
+	if (likely(system_state == SYSTEM_RUNNING))
+		schedule_work(&kgdboc_restore_input_work);
 }
 
 static int kgdboc_register_kbd(char **cptr)
-- 
1.7.0.4

