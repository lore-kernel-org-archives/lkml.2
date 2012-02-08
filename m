Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2BHCWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:22:01 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:5107 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756649Ab2BHCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:21:59 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31DC31.6040303@am.sony.com>
Date: Tue, 7 Feb 2012 18:21:37 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH 1/5] logger: Change logger_offset() from macro to function
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to function and add log as a parameter, rather than relying
on log in the context of the macro.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index ffc2d04..92456d7 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -60,7 +60,11 @@ struct logger_reader {
 };

 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
-#define logger_offset(n)	((n) & (log->size - 1))
+size_t logger_offset(struct logger_log *log, size_t n)
+{
+	return n & (log->size-1);
+}
+

 /*
  * file_get_log - Given a file structure, return the associated log
@@ -137,7 +141,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
 		if (copy_to_user(buf + len, log->buffer, count - len))
 			return -EFAULT;

-	reader->r_off = logger_offset(reader->r_off + count);
+	reader->r_off = logger_offset(log, reader->r_off + count);

 	return count;
 }
@@ -225,7 +229,7 @@ static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)

 	do {
 		size_t nr = get_entry_len(log, off);
-		off = logger_offset(off + nr);
+		off = logger_offset(log, off + nr);
 		count += nr;
 	} while (count < len);

@@ -260,7 +264,7 @@ static inline int clock_interval(size_t a, size_t b, size_t c)
 static void fix_up_readers(struct logger_log *log, size_t len)
 {
 	size_t old = log->w_off;
-	size_t new = logger_offset(old + len);
+	size_t new = logger_offset(log, old + len);
 	struct logger_reader *reader;

 	if (clock_interval(old, new, log->head))
@@ -286,7 +290,7 @@ static void do_write_log(struct logger_log *log, const void *buf, size_t count)
 	if (count != len)
 		memcpy(log->buffer, buf + len, count - len);

-	log->w_off = logger_offset(log->w_off + count);
+	log->w_off = logger_offset(log, log->w_off + count);

 }

@@ -311,7 +315,7 @@ static ssize_t do_write_log_from_user(struct logger_log *log,
 		if (copy_from_user(log->buffer, buf + len, count - len))
 			return -EFAULT;

-	log->w_off = logger_offset(log->w_off + count);
+	log->w_off = logger_offset(log, log->w_off + count);

 	return count;
 }
-- 
1.7.2.3

