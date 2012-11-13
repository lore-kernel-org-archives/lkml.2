Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2KMXSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:18:32 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63869 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2KMXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:18:31 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 10/12] printk: retain unknown log-level until log_store()
Date: Wed, 14 Nov 2012 00:13:07 +0100
Message-Id: <1352848389-23114-11-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retain a value of -1 for messages with an unknown message level and pass
this to log_store(). This way, we can later distinguish continuation
records from non-continuation records in log_store().

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 42ecdb0..6daa7cc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -310,6 +310,10 @@ static void log_store(int facility, int level,
 	struct log *msg;
 	u32 size, pad_len;
 
+	/* store something meaningful, when no loglevel was given */
+	if (level == -1)
+		level = default_message_loglevel;
+
 	/* number of '\0' padding bytes to next message */
 	size = sizeof(struct log) + text_len + dict_len;
 	pad_len = (-size) & (LOG_ALIGN - 1);
@@ -376,7 +380,7 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 {
 	char *buf, *line;
 	int i;
-	int level = default_message_loglevel;
+	int level = -1;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_length(iv, count);
 	ssize_t ret = len;
@@ -1450,11 +1454,12 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 		cont_flush(0);
 		if (cont.msg.text_len)
 			return false;
+		level = cont.msg.level;
 	}
 
 	if (!cont.msg.text_len) {
 		cont.msg.facility = facility;
-		cont.msg.level = level;
+		cont.msg.level = level == -1 ? default_message_loglevel : level;
 		cont.owner = current;
 		cont.msg.ts_nsec = local_clock();
 		cont.msg.flags = flags;
@@ -1574,22 +1579,23 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 		if (kern_level) {
 			const char *end_of_header = printk_skip_level(text);
-			switch (kern_level) {
-			case '0' ... '7':
-				if (level == -1)
+			if (level == -1) {
+				switch (kern_level) {
+				case '0' ... '7':
 					level = kern_level - '0';
-			case 'd':	/* KERN_DEFAULT */
-				lflags |= LOG_PREFIX;
-			case 'c':	/* KERN_CONT */
-				break;
+					break;
+				case 'd':	/* KERN_DEFAULT */
+					level = default_message_loglevel;
+					break;
+				}
 			}
 			text_len -= end_of_header - text;
 			text = (char *)end_of_header;
 		}
 	}
 
-	if (level == -1)
-		level = default_message_loglevel;
+	if (level != -1)
+		lflags |= LOG_PREFIX;
 
 	if (dict)
 		lflags |= LOG_PREFIX|LOG_NEWLINE;
-- 
1.8.0.316.g291341c.dirty

