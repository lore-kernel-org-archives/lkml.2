Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2HAE4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:56:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2HAEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:53 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 4/5] Redocument some functions in android/logger.c
Date: Wed,  1 Aug 2012 14:54:19 +1000
Message-Id: <1343796860-7025-5-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will document the rest later if they remain unchanged
Normally, I would do them all at once, but I don't have the chance to do them all at the moment

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/logger.c |   90 +++++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 1d5ed47..226d8b5 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -78,15 +78,20 @@ struct logger_reader {
 	size_t			r_off;
 };
 
-/* logger_offset - returns index 'n' into the log via (optimized) modulus */
+/**
+ * logger_offset() - returns index 'n' into the log via (optimized) modulus
+ * @log:	The log being referenced
+ * @n:		The index number being referenced
+ */
 static size_t logger_offset(struct logger_log *log, size_t n)
 {
 	return n & (log->size - 1);
 }
 
 
-/*
- * file_get_log - Given a file structure, return the associated log
+/**
+ * file_get_log() - Given a file, return the associated log
+ * @file:	The file being referenced
  *
  * This isn't aesthetic. We have several goals:
  *
@@ -108,9 +113,11 @@ static inline struct logger_log *file_get_log(struct file *file)
 		return file->private_data;
 }
 
-/*
- * get_entry_len - Grabs the length of the payload of the next entry starting
- * from 'off'.
+/**
+ * get_entry_len() - Grabs the length of the payload of the entry starting
+ * at @off
+ * @log:	The log being referenced
+ * @off:	The offset to start counting at
  *
  * An entry length is 2 bytes (16 bits) in host endian order.
  * In the log, the length does not include the size of the log entry structure.
@@ -134,9 +141,13 @@ static __u32 get_entry_len(struct logger_log *log, size_t off)
 	return sizeof(struct logger_entry) + val;
 }
 
-/*
- * do_read_log_to_user - reads exactly 'count' bytes from 'log' into the
- * user-space buffer 'buf'. Returns 'count' on success.
+/**
+ * do_read_log_to_user() - reads exactly @count bytes from @log into the
+ * user-space buffer @buf. Returns @count on success.
+ * @log:	The log being read from
+ * @reader:	The logger reader that reads from @log
+ * @buf:	The user-space buffer being written into
+ * @count:	The number of bytes being read
  *
  * Caller must hold log->mutex.
  */
@@ -169,8 +180,12 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
 	return count;
 }
 
-/*
- * logger_read - our log's read() method
+/**
+ * logger_read() - our log's read() method
+ * @file:	The file being read from
+ * @buf:	The user-space buffer being written into
+ * @count:	The minimum number of bytes to be read
+ * @pos:	Unused, posssibly the write position or offset in @buf
  *
  * Behavior:
  *
@@ -241,11 +256,14 @@ out:
 	return ret;
 }
 
-/*
- * get_next_entry - return the offset of the first valid entry at least 'len'
- * bytes after 'off'.
+/**
+ * get_next_entry() - return the offset of the first valid entry at least @len
+ * bytes after @off.
+ * @log:	The log being read from
+ * @off:	The offset / number of bytes to skip
+ * @len:	The minimum number of bytes to read
  *
- * Caller must hold log->mutex.
+ * Caller must hold @log->mutex.
  */
 static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)
 {
@@ -260,19 +278,21 @@ static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)
 	return off;
 }
 
-/*
- * is_between - is a < c < b, accounting for wrapping of a, b, and c
+/**
+ * is_between() - is @a < @c < @b, accounting for wrapping of @a, @b, and @c
  *    positions in the buffer
+ * @a:	The starting position
+ * @b:	The finishing position
+ * @c:	The position being searched for
  *
- * That is, if a<b, check for c between a and b
- * and if a>b, check for c outside (not between) a and b
+ * That is, if @a < @b, check for @c between @a and @b
+ * and if @a > @b, check for @c outside (not between) @a and @b
  *
  * |------- a xxxxxxxx b --------|
  *               c^
  *
  * |xxxxx b --------- a xxxxxxxxx|
- *    c^
- *  or                    c^
+ *    c^        or         c^
  */
 static inline int is_between(size_t a, size_t b, size_t c)
 {
@@ -289,13 +309,17 @@ static inline int is_between(size_t a, size_t b, size_t c)
 	return 0;
 }
 
-/*
- * fix_up_readers - walk the list of all readers and "fix up" any who were
- * lapped by the writer; also do the same for the default "start head".
+/**
+ * fix_up_readers() - walk the list of all readers and "fix up" any who were
+ * lapped by the writer.
+ * @log:	The log being referenced
+ * @len:	The number of bytes to "pull" the reader forward by
+ *
+ * Also does the same for the default "start head".
  * We do this by "pulling forward" the readers and start head to the first
  * entry after the new write head.
  *
- * The caller needs to hold log->mutex.
+ * The caller needs to hold @log->mutex.
  */
 static void fix_up_readers(struct logger_log *log, size_t len)
 {
@@ -311,8 +335,11 @@ static void fix_up_readers(struct logger_log *log, size_t len)
 			reader->r_off = get_next_entry(log, reader->r_off, len);
 }
 
-/*
- * do_write_log - writes 'len' bytes from 'buf' to 'log'
+/**
+ * do_write_log() - writes 'len' bytes from @buf to @log
+ * @log:	The log being written into
+ * @buf:	The buffer being read from
+ * @count:	The number of bytes to write
  *
  * The caller needs to hold log->mutex.
  */
@@ -330,9 +357,12 @@ static void do_write_log(struct logger_log *log, const void *buf, size_t count)
 
 }
 
-/*
- * do_write_log_user - writes 'len' bytes from the user-space buffer 'buf' to
- * the log 'log'
+/**
+ * do_write_log_user() - writes 'len' bytes from the user-space buffer @buf
+ * to @log
+ * @log:	The log being written into
+ * @buf:	The user-space buffer being read from
+ * @count:	The number of bytes to write
  *
  * The caller needs to hold log->mutex.
  *
-- 
1.7.9.5

