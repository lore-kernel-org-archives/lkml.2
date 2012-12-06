Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946306Ab2LFRKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:10:22 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65347 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946291Ab2LFRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:10:18 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 09/14] printk: retain unknown log-level until cont_add()/log_store()
Date: Thu,  6 Dec 2012 18:06:06 +0100
Message-Id: <1354813571-11253-10-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retain a value of -1 for messages with an unknown message level and pass
this to cont_add() and log_store(). This way, we can better distinguish
continuation records from non-continuation records and keep the correct
level in more cases than before. (Though, most of this level tracking
will be done in follow-up patches.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
v2:
- rephrased commit message to better reflect what the patch is doing
---
 kernel/printk.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 075fbd4..52ccf93 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -309,6 +309,10 @@ static void log_store(int facility, int level,
 	struct log *msg;
 	u32 size, pad_len;
 
+	/* store something meaningful, when no loglevel was given */
+	if (level == -1)
+		level = default_message_loglevel;
+
 	/* number of '\0' padding bytes to next message */
 	size = sizeof(struct log) + text_len + dict_len;
 	pad_len = (-size) & (LOG_ALIGN - 1);
@@ -375,7 +379,7 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 {
 	char *buf, *line;
 	int i;
-	int level = default_message_loglevel;
+	int level = -1;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_length(iv, count);
 	ssize_t ret = len;
@@ -1453,11 +1457,12 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 		cont_flush();
 		if (cont.len)
 			return false;
+		level = cont.level;
 	}
 
 	if (!cont.len) {
 		cont.facility = facility;
-		cont.level = level;
+		cont.level = level == -1 ? default_message_loglevel : level;
 		cont.owner = current;
 		cont.ts_nsec = local_clock();
 		cont.flags = 0;
@@ -1567,22 +1572,23 @@ asmlinkage int vprintk_emit(int facility, int level,
 
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
1.8.0.1.20.g7c65b2e.dirty

