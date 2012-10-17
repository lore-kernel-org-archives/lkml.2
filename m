Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2JQGIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:08:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47246 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755775Ab2JQGIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 12/23] printk: Rename clear_seq and clear_idx variables
Date: Tue, 16 Oct 2012 23:06:16 -0700
Message-Id: <3ea26951ce9ac2b00f5756ed593aef765bbfaabd.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make these variables more specific to the printk log subsystem
adding prefix printk_log_.  This allows them to become non-static.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 709472f..3785ac4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -231,8 +231,8 @@ static u32 console_idx;
 static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
-static u64 clear_seq;
-static u32 clear_idx;
+static u64 printk_log_clear_seq;
+static u32 printk_log_clear_idx;
 
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
@@ -566,8 +566,8 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
 		 * changes no global state, and does not clear anything.
 		 */
-		user->idx = clear_idx;
-		user->seq = clear_seq;
+		user->idx = printk_log_clear_idx;
+		user->seq = printk_log_clear_seq;
 		break;
 	case SEEK_END:
 		/* after the last record */
@@ -1012,18 +1012,18 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u32 idx;
 		enum printk_log_flags prev;
 
-		if (clear_seq < printk_log_first_seq) {
+		if (printk_log_clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = printk_log_first_seq;
-			clear_idx = printk_log_first_idx;
+			printk_log_clear_seq = printk_log_first_seq;
+			printk_log_clear_idx = printk_log_first_idx;
 		}
 
 		/*
 		 * Find first record that fits, including all following records,
 		 * into the user-provided buffer for this dump.
 		 */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = printk_log_clear_seq;
+		idx = printk_log_clear_idx;
 		prev = 0;
 		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
@@ -1035,8 +1035,8 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		}
 
 		/* move first record forward until length fits into the buffer */
-		seq = clear_seq;
-		idx = clear_idx;
+		seq = printk_log_clear_seq;
+		idx = printk_log_clear_idx;
 		prev = 0;
 		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
@@ -1083,8 +1083,8 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	}
 
 	if (clear) {
-		clear_seq = printk_log_next_seq;
-		clear_idx = printk_log_next_idx;
+		printk_log_clear_seq = printk_log_next_seq;
+		printk_log_clear_idx = printk_log_next_idx;
 	}
 	raw_spin_unlock_irq(&printk_logbuf_lock);
 
@@ -2566,8 +2566,8 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		dumper->active = true;
 
 		raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
-		dumper->cur_seq = clear_seq;
-		dumper->cur_idx = clear_idx;
+		dumper->cur_seq = printk_log_clear_seq;
+		dumper->cur_idx = printk_log_clear_idx;
 		dumper->next_seq = printk_log_next_seq;
 		dumper->next_idx = printk_log_next_idx;
 		raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
@@ -2774,8 +2774,8 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
  */
 void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
-	dumper->cur_seq = clear_seq;
-	dumper->cur_idx = clear_idx;
+	dumper->cur_seq = printk_log_clear_seq;
+	dumper->cur_idx = printk_log_clear_idx;
 	dumper->next_seq = printk_log_next_seq;
 	dumper->next_idx = printk_log_next_idx;
 }
-- 
1.7.10.4

