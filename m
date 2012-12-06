Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946321Ab2LFRKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:10:38 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65381 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946292Ab2LFRKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:10:21 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 10/14] printk: track previously logged message in log_store()
Date: Thu,  6 Dec 2012 18:06:07 +0100
Message-Id: <1354813571-11253-11-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centrally track information about the previous message in log_store().

This knowledge allows us to decide immediately whether the current
message is a continuation of the previous message. And if that is so, to
keep the correct log level (continuation records do not have a log level).

Later, this will also allow us to remove the tracking of the previous
message flags throughout the syslog/kmsg formatting code.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
v2:
- Fixed a bug that could mismerge continuation records, because
  log_store() used "current" as the owner of the message passed in,
  which might be incorrect when used from cont_flush().
- refactored code
- refactored patches
---
 kernel/printk.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 52ccf93..151c77a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -226,6 +226,10 @@ static size_t syslog_partial;
 static u64 log_first_seq;
 static u32 log_first_idx;
 
+/* information about the last stored message */
+static struct log *log_last_msg;
+static struct task_struct *log_last_owner;
+
 /* index and sequence number of the next record to store in the buffer */
 static u64 log_next_seq;
 static u32 log_next_idx;
@@ -300,18 +304,36 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
+/* return correct level for continuation records */
+static int log_infer_level(struct task_struct *owner, int facility, int level,
+			  enum log_flags flags)
+{
+	if (flags & LOG_PREFIX || level != -1 || !log_last_msg ||
+	    log_last_msg->facility != facility || log_last_owner != owner ||
+	    log_last_msg->flags & LOG_NEWLINE)
+		return level;
+	return log_last_msg->level;
+}
+
 /* insert record into the buffer, discard old ones, update heads */
-static void log_store(int facility, int level,
+static void log_store(struct task_struct *owner, int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len)
 {
 	struct log *msg;
 	u32 size, pad_len;
-
-	/* store something meaningful, when no loglevel was given */
-	if (level == -1)
-		level = default_message_loglevel;
+	int inferred_level;
+
+	/* setup flags/level for storage */
+	inferred_level = log_infer_level(owner, facility, -1, flags);
+	if (inferred_level == -1) {
+		flags |= LOG_PREFIX;
+		if (level == -1)
+			level = default_message_loglevel;
+	} else {
+		level = inferred_level;
+	}
 
 	/* number of '\0' padding bytes to next message */
 	size = sizeof(struct log) + text_len + dict_len;
@@ -329,7 +351,7 @@ static void log_store(int facility, int level,
 		if (free > size + sizeof(struct log))
 			break;
 
-		/* drop old messages until we have enough contiuous space */
+		/* drop old messages until we have enough continuous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
@@ -363,6 +385,9 @@ static void log_store(int facility, int level,
 	/* insert message */
 	log_next_idx += msg->len;
 	log_next_seq++;
+
+	log_last_owner = owner;
+	log_last_msg = msg;
 }
 
 /* /dev/kmsg - userspace message inject/listen interface */
@@ -1432,8 +1457,8 @@ static void cont_flush(void)
 	if (cont.cons)
 		cont.flags |= LOG_NOCONS;
 
-	log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec, NULL, 0,
-		  cont.buf, cont.len);
+	log_store(cont.owner, cont.facility, cont.level, cont.flags,
+		  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 
 	/*
 	 * If no fragment of this line ever reached the console or everything
@@ -1550,7 +1575,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+		log_store(current, 0, 2, LOG_PREFIX | LOG_NEWLINE, 0,
 			  NULL, 0, recursion_msg, printed_len);
 	}
 
@@ -1607,7 +1632,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, lflags, text, text_len))
-			log_store(facility, level, lflags, 0,
+			log_store(current, facility, level, lflags, 0,
 				  dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
@@ -1626,7 +1651,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 
 		if (!stored)
-			log_store(facility, level, lflags, 0,
+			log_store(current, facility, level, lflags, 0,
 				  dict, dictlen, text, text_len);
 	}
 	printed_len += text_len;
-- 
1.8.0.1.20.g7c65b2e.dirty

