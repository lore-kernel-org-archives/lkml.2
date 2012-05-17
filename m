Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054Ab2EQPCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:02:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42572 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967101Ab2EQPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:01:44 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: greg@kroah.com, kay@vrfy.org, torvalds@linux-foundation.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        hpa@kernel.org, yinghai@kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC] printk: add relative printk timing support
Date: Thu, 17 May 2012 17:02:49 +0200
Message-Id: <1337266969-19181-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for relative timestamps in printk output.

First, this is how it looks now:

[  120.001386] foo
[  181.036862] bar
[  186.070696] zoot
[  196.288022] foo
[  257.415895] bar
[  257.416580] zoot

Next, with Linus' suggestion (Month and date, no seconds):

[May 17 14:13] foo
[May 17 14:14] bar
[+05.00026906] zoot
[+10.00054898] foo
[May 17 14:15] bar
[+00.00000668] zoot

And Peter's suggestion (MS accurate absolute time):

[14:16:57.970] foo
[14:17:59.063] bar
[+05.00032139] zoot
[+10.00336079] foo
[14:19:15.677] bar
[+00.00001905] zoot

Todo:
 - Can we get rid of the spinlock somehow? I tried using atomic64_t, but got
hit with races causing odd prints.
 - Do we want to make the 60 second "timeout" for printing abs time
configurable?
- Are there any other formats we would want to add?

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/printk.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..9d008e5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -779,11 +779,12 @@ static int check_syslog_permissions(int type, bool from_file)
 }
 
 #if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
+static int printk_time = 1;
 #else
-static bool printk_time;
+static int printk_time;
 #endif
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+module_param_named(time, printk_time, int, S_IRUGO | S_IWUSR);
+static DEFINE_SPINLOCK(printk_time_rel);
 
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
@@ -801,16 +802,53 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 		}
 	}
 
-	if (printk_time) {
+	if (printk_time == 1) {
 		if (buf) {
 			unsigned long long ts = msg->ts_nsec;
-			unsigned long rem_nsec = do_div(ts, 1000000000);
+			unsigned long rem_nsec = do_div(ts, NSEC_PER_SEC);
 
 			len += sprintf(buf + len, "[%5lu.%06lu] ",
-					 (unsigned long) ts, rem_nsec / 1000);
+					 (unsigned long) ts, rem_nsec / NSEC_PER_USEC);
 		} else {
 			len += 15;
 		}
+	} else if (printk_time == 2 || printk_time == 3) {
+		static unsigned long long last_print;
+		unsigned long long ts = msg->ts_nsec;
+		unsigned long rem_nsec;
+		bool rel = 0;
+		static const char *months[12] = {"Jan", "Feb", "Mar", "Apr",
+						"May", "Jun", "Jul", "Aug",
+						"Sep", "Oct", "Nov", "Dec",};
+
+		if (!buf)
+			return len + 15;
+
+		spin_lock(&printk_time_rel);
+		if ((ts - last_print) / NSEC_PER_SEC < 60) {
+			rel = 1;
+			ts -= last_print;
+		}
+		last_print = msg->ts_nsec;
+		spin_unlock(&printk_time_rel);
+
+		rem_nsec = do_div(ts, NSEC_PER_SEC);
+		if (rel) {
+			len += sprintf(buf + len, "[%+03d.%08lu] ",
+					(int)ts, rem_nsec / NSEC_PER_USEC);
+		} else {
+			struct tm tm;
+
+			time_to_tm(get_seconds(), 0, &tm);
+			if (printk_time == 2)
+				len += sprintf(buf + len, "[%s %02d %02d:%02d] ",
+						months[tm.tm_mon], tm.tm_mday,
+						tm.tm_hour, tm.tm_min);
+			if (printk_time == 3)
+				len += sprintf(buf + len, "[%02d:%02d:%02d.%03lu] ",
+						tm.tm_hour, tm.tm_min, tm.tm_sec,
+						rem_nsec / NSEC_PER_MSEC);
+		}
 	}
 
 	return len;
-- 
1.7.8.6

