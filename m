Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1BANwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:33 -0500
Received: from www.tglx.de ([62.245.132.106]:47359 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab1BANwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:30 -0500
Message-Id: <20110201134419.772343089@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 24/28] posix-clocks: Splitout compat timex accessors
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-clocks-splitout-compat-timex-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Split out the compat timex accessors into separate
functions. Preparatory patch for a new syscall.

[ tglx: Split that patch from Richards "posix clocks: Introduce a
  	syscall for clock tuning.". Keeps the changes strictly
  	separate ]

Originally-from: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
LKML-Reference: <2d5e2f3e6f388aa1848d40406646aab2e26a906f.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/compat.c |  113 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 48 deletions(-)

Index: linux-2.6-tip/kernel/compat.c
===================================================================
--- linux-2.6-tip.orig/kernel/compat.c
+++ linux-2.6-tip/kernel/compat.c
@@ -52,6 +52,64 @@ static int compat_put_timeval(struct com
 		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
 }
 
+static int compat_get_timex(struct timex *txc, struct compat_timex __user *utp)
+{
+	memset(txc, 0, sizeof(struct timex));
+
+	if (!access_ok(VERIFY_READ, utp, sizeof(struct compat_timex)) ||
+			__get_user(txc->modes, &utp->modes) ||
+			__get_user(txc->offset, &utp->offset) ||
+			__get_user(txc->freq, &utp->freq) ||
+			__get_user(txc->maxerror, &utp->maxerror) ||
+			__get_user(txc->esterror, &utp->esterror) ||
+			__get_user(txc->status, &utp->status) ||
+			__get_user(txc->constant, &utp->constant) ||
+			__get_user(txc->precision, &utp->precision) ||
+			__get_user(txc->tolerance, &utp->tolerance) ||
+			__get_user(txc->time.tv_sec, &utp->time.tv_sec) ||
+			__get_user(txc->time.tv_usec, &utp->time.tv_usec) ||
+			__get_user(txc->tick, &utp->tick) ||
+			__get_user(txc->ppsfreq, &utp->ppsfreq) ||
+			__get_user(txc->jitter, &utp->jitter) ||
+			__get_user(txc->shift, &utp->shift) ||
+			__get_user(txc->stabil, &utp->stabil) ||
+			__get_user(txc->jitcnt, &utp->jitcnt) ||
+			__get_user(txc->calcnt, &utp->calcnt) ||
+			__get_user(txc->errcnt, &utp->errcnt) ||
+			__get_user(txc->stbcnt, &utp->stbcnt))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int compat_put_timex(struct compat_timex __user *utp, struct timex *txc)
+{
+	if (!access_ok(VERIFY_WRITE, utp, sizeof(struct compat_timex)) ||
+			__put_user(txc->modes, &utp->modes) ||
+			__put_user(txc->offset, &utp->offset) ||
+			__put_user(txc->freq, &utp->freq) ||
+			__put_user(txc->maxerror, &utp->maxerror) ||
+			__put_user(txc->esterror, &utp->esterror) ||
+			__put_user(txc->status, &utp->status) ||
+			__put_user(txc->constant, &utp->constant) ||
+			__put_user(txc->precision, &utp->precision) ||
+			__put_user(txc->tolerance, &utp->tolerance) ||
+			__put_user(txc->time.tv_sec, &utp->time.tv_sec) ||
+			__put_user(txc->time.tv_usec, &utp->time.tv_usec) ||
+			__put_user(txc->tick, &utp->tick) ||
+			__put_user(txc->ppsfreq, &utp->ppsfreq) ||
+			__put_user(txc->jitter, &utp->jitter) ||
+			__put_user(txc->shift, &utp->shift) ||
+			__put_user(txc->stabil, &utp->stabil) ||
+			__put_user(txc->jitcnt, &utp->jitcnt) ||
+			__put_user(txc->calcnt, &utp->calcnt) ||
+			__put_user(txc->errcnt, &utp->errcnt) ||
+			__put_user(txc->stbcnt, &utp->stbcnt) ||
+			__put_user(txc->tai, &utp->tai))
+		return -EFAULT;
+	return 0;
+}
+
 asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 		struct timezone __user *tz)
 {
@@ -951,58 +1009,17 @@ asmlinkage long compat_sys_rt_sigsuspend
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp)
 {
 	struct timex txc;
-	int ret;
+	int err, ret;
 
-	memset(&txc, 0, sizeof(struct timex));
-
-	if (!access_ok(VERIFY_READ, utp, sizeof(struct compat_timex)) ||
-			__get_user(txc.modes, &utp->modes) ||
-			__get_user(txc.offset, &utp->offset) ||
-			__get_user(txc.freq, &utp->freq) ||
-			__get_user(txc.maxerror, &utp->maxerror) ||
-			__get_user(txc.esterror, &utp->esterror) ||
-			__get_user(txc.status, &utp->status) ||
-			__get_user(txc.constant, &utp->constant) ||
-			__get_user(txc.precision, &utp->precision) ||
-			__get_user(txc.tolerance, &utp->tolerance) ||
-			__get_user(txc.time.tv_sec, &utp->time.tv_sec) ||
-			__get_user(txc.time.tv_usec, &utp->time.tv_usec) ||
-			__get_user(txc.tick, &utp->tick) ||
-			__get_user(txc.ppsfreq, &utp->ppsfreq) ||
-			__get_user(txc.jitter, &utp->jitter) ||
-			__get_user(txc.shift, &utp->shift) ||
-			__get_user(txc.stabil, &utp->stabil) ||
-			__get_user(txc.jitcnt, &utp->jitcnt) ||
-			__get_user(txc.calcnt, &utp->calcnt) ||
-			__get_user(txc.errcnt, &utp->errcnt) ||
-			__get_user(txc.stbcnt, &utp->stbcnt))
-		return -EFAULT;
+	err = compat_get_timex(&txc, utp);
+	if (err)
+		return err;
 
 	ret = do_adjtimex(&txc);
 
-	if (!access_ok(VERIFY_WRITE, utp, sizeof(struct compat_timex)) ||
-			__put_user(txc.modes, &utp->modes) ||
-			__put_user(txc.offset, &utp->offset) ||
-			__put_user(txc.freq, &utp->freq) ||
-			__put_user(txc.maxerror, &utp->maxerror) ||
-			__put_user(txc.esterror, &utp->esterror) ||
-			__put_user(txc.status, &utp->status) ||
-			__put_user(txc.constant, &utp->constant) ||
-			__put_user(txc.precision, &utp->precision) ||
-			__put_user(txc.tolerance, &utp->tolerance) ||
-			__put_user(txc.time.tv_sec, &utp->time.tv_sec) ||
-			__put_user(txc.time.tv_usec, &utp->time.tv_usec) ||
-			__put_user(txc.tick, &utp->tick) ||
-			__put_user(txc.ppsfreq, &utp->ppsfreq) ||
-			__put_user(txc.jitter, &utp->jitter) ||
-			__put_user(txc.shift, &utp->shift) ||
-			__put_user(txc.stabil, &utp->stabil) ||
-			__put_user(txc.jitcnt, &utp->jitcnt) ||
-			__put_user(txc.calcnt, &utp->calcnt) ||
-			__put_user(txc.errcnt, &utp->errcnt) ||
-			__put_user(txc.stbcnt, &utp->stbcnt) ||
-			__put_user(txc.tai, &utp->tai))
-		ret = -EFAULT;
+	err = compat_put_timex(utp, &txc);
+	if (err)
+		return err;
 
 	return ret;
 }


