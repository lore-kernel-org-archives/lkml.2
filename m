Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2KMXQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:16:09 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63609 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2KMXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:16:08 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 03/12] printk: reclaim cont buffer immediately for fully printed messages
Date: Wed, 14 Nov 2012 00:13:00 +0100
Message-Id: <1352848389-23114-4-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to keep the contents of the cont buffer, when there is a
partly printed message in it. In both other cases, not yet printed as
well as fully printed messages, we can reclaim the buffer immediately.

Currently, we do not reclaim the cont buffer when it contains a fully
printed message. This commit restructures the logic to achieve that.
(Note, that LOG_NOCONS must still be set for partly _and_ fully printed
messages, making it a bit more complicated than just changing the
if-condition.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 0927068..ba9494b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1400,24 +1400,26 @@ static void cont_flush(enum log_flags flags)
 		return;
 
 	cont.flags |= flags;
-	if (cont.cons) {
-		/*
-		 * If a fragment of this line was directly flushed to the
-		 * console; wait for the console to pick up the rest of the
-		 * line. LOG_NOCONS suppresses a duplicated output.
-		 */
-		log_store(cont.facility, cont.level, cont.flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-		cont.flushed = true;
-	} else {
-		/*
-		 * If no fragment of this line ever reached the console,
-		 * just submit it to the store and free the buffer.
-		 */
-		log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec,
-			  NULL, 0, cont.buf, cont.len);
+
+	/*
+	 * If a fragment of this line was directly flushed to the console, the
+	 * whole line is/was directly printed. Use LOG_NOCONS to suppress a
+	 * duplicated output later -- see console_unlock().
+	 */
+	if (cont.cons)
+		cont.flags |= LOG_NOCONS;
+
+	log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec, NULL, 0,
+		  cont.buf, cont.len);
+
+	/*
+	 * If no fragment of this line ever reached the console or everything
+	 * has been printed, free the buffer. Otherwise keep it available.
+	 */
+	if (!cont.cons || cont.cons == cont.len)
 		cont.len = 0;
-	}
+	else
+		cont.flushed = true;
 }
 
 static bool cont_add(int facility, int level, enum log_flags flags,
-- 
1.8.0.316.g291341c.dirty

