Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2BTCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:25:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2BTCZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:25:25 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/7] compat: Add helper functions to read/write struct timeval, timespec
Date: Sun, 19 Feb 2012 18:22:45 -0800
Message-Id: <1329704570-3792-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:25:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Add helper functions to read and write struct timeval and struct
timespec from userspace.  We already had helper functions for reading
and writing struct compat_timespec; add a set of functions to do the
same with struct timeval, and add a second suite of functions which
can be sensitive to COMPAT_USE_64BIT_TIME and access either 32- or
64-bit time structures.

This also exports these helper functions to modules.

Rename the existing inlines for converting between struct
compat_timeval and native struct timespec so we can have a saner
naming convention for the exported functions.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/compat.h |   16 +++++++++++
 kernel/compat.c        |   70 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 1be91c0..a82e452 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -87,10 +87,26 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
+/*
+ * These functions operate strictly on struct compat_time*
+ */
 extern int get_compat_timespec(struct timespec *,
 			       const struct compat_timespec __user *);
 extern int put_compat_timespec(const struct timespec *,
 			       struct compat_timespec __user *);
+extern int get_compat_timeval(struct timeval *,
+			      const struct compat_timeval __user *);
+extern int put_compat_timeval(const struct timeval *,
+			      struct compat_timeval __user *);
+/*
+ * These functions operate on 32- or 64-bit specs depending on
+ * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments and the
+ * naming as compat_get/put_ rather than get/put_compat_.
+ */
+extern int compat_get_timespec(struct timespec *, const void __user *);
+extern int compat_put_timespec(const struct timespec *, void __user *);
+extern int compat_get_timeval(struct timeval *, const void __user *);
+extern int compat_put_timeval(const struct timeval *, void __user *);
 
 struct compat_iovec {
 	compat_uptr_t	iov_base;
diff --git a/kernel/compat.c b/kernel/compat.c
index f346ced..1743d67 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -31,11 +31,10 @@
 #include <asm/uaccess.h>
 
 /*
- * Note that the native side is already converted to a timespec, because
- * that's what we want anyway.
+ * Get/set struct timeval with struct timespec on the native side
  */
-static int compat_get_timeval(struct timespec *o,
-		struct compat_timeval __user *i)
+static int compat_get_timeval_convert(struct timespec *o,
+				      struct compat_timeval __user *i)
 {
 	long usec;
 
@@ -46,8 +45,8 @@ static int compat_get_timeval(struct timespec *o,
 	return 0;
 }
 
-static int compat_put_timeval(struct compat_timeval __user *o,
-		struct timeval *i)
+static int compat_put_timeval_convert(struct compat_timeval __user *o,
+				      struct timeval *i)
 {
 	return (put_user(i->tv_sec, &o->tv_sec) ||
 		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
@@ -117,7 +116,7 @@ asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 	if (tv) {
 		struct timeval ktv;
 		do_gettimeofday(&ktv);
-		if (compat_put_timeval(tv, &ktv))
+		if (compat_put_timeval_convert(tv, &ktv))
 			return -EFAULT;
 	}
 	if (tz) {
@@ -135,7 +134,7 @@ asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 	struct timezone ktz;
 
 	if (tv) {
-		if (compat_get_timeval(&kts, tv))
+		if (compat_get_timeval_convert(&kts, tv))
 			return -EFAULT;
 	}
 	if (tz) {
@@ -146,12 +145,29 @@ asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
 }
 
+int get_compat_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
+{
+	return (!access_ok(VERIFY_READ, ctv, sizeof(*ctv)) ||
+			__get_user(tv->tv_sec, &ctv->tv_sec) ||
+			__get_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(get_compat_timeval);
+
+int put_compat_timeval(const struct timeval *tv, struct compat_timespec __user *ctv)
+{
+	return (!access_ok(VERIFY_WRITE, ctv, sizeof(*ctv)) ||
+			__put_user(tv->tv_sec, &ctv->tv_sec) ||
+			__put_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(put_compat_timeval);
+
 int get_compat_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
 			__get_user(ts->tv_sec, &cts->tv_sec) ||
 			__get_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL_GPL(get_compat_timespec);
 
 int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user *cts)
 {
@@ -161,6 +177,42 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
 }
 EXPORT_SYMBOL_GPL(put_compat_timespec);
 
+int compat_get_timeval(struct timeval *tv, const void __user *utv)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return get_user(tv, (const struct timeval __user *)utv);
+	else
+		return get_compat_timeval(tv, utv);
+}
+EXPORT_SYMBOL_GPL(compat_get_timeval);
+
+int compat_put_timeval(const struct timeval *tv, void __user *utv)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return put_user(tv, (struct timeval __user *)utv);
+	else
+		return put_compat_timeval(tv, utv);
+}
+EXPORT_SYMBOL_GPL(compat_put_timeval);
+
+int compat_get_timespec(struct timespec *ts, const void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return get_user(ts, (const struct timespec __user *)uts);
+	else
+		return get_compat_timespec(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_get_timespec);
+
+int compat_put_timespec(const struct timespec *ts, void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return put_user(tv, (struct timeval __user *)ctv);
+	else
+		return put_compat_timespec(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_put_timespec);
+
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
@@ -1162,3 +1214,5 @@ void __user *compat_alloc_user_space(unsigned long len)
 	return ptr;
 }
 EXPORT_SYMBOL_GPL(compat_alloc_user_space);
+
+/*
-- 
1.7.6.5

