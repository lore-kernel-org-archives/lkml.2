Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0KDTax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:30:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0KDTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WtYf22SnvBIwGFHf8xooE6vqUrTDFMFs5WkAkR4g6FJvmgm2+vk/b4+HjHwnjebHwu
         CQuQsDalWeF/O6JTcGmURHiMH/LdeMNifjLfFwoDLl2ncgXk/C4DIY1dQlipIgeXKu6z
         ZPB2hmpopgWWMzBaLgpDKR9r3G61dEtcGOj9o=
Date: Thu, 4 Nov 2010 20:30:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC 8/8] clock device: convert timer_settime
Message-ID: <b01f31d7dbb6c60b9b36d7408c0be99badfa7661.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the timer_settime system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/clockdevice.h |    3 +++
 kernel/posix-timers.c       |   12 +++++++++---
 kernel/time/clockdevice.c   |   20 ++++++++++++++++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index b56debb..d3589a0 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -110,5 +110,8 @@ int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit);
 int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit);
 void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
 				struct itimerspec *tsp);
+int clock_device_timer_settime(struct clock_device *clk,
+			       struct k_itimer *kit, int flags,
+			       struct itimerspec *tsp, struct itimerspec *old);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d00ff73..b09e37e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -817,6 +817,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 		const struct itimerspec __user *, new_setting,
 		struct itimerspec __user *, old_setting)
 {
+	struct clock_device *clk_dev;
 	struct k_itimer *timr;
 	struct itimerspec new_spec, old_spec;
 	int error = 0;
@@ -837,9 +838,14 @@ retry:
 	if (!timr)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
-			       (timr, flags, &new_spec, rtn));
-
+	clk_dev = clockid_to_clock_device(timr->it_clock);
+	if (clk_dev)
+		error = clock_device_timer_settime(clk_dev, timr,
+						   flags, &new_spec, rtn);
+	else {
+		error = CLOCK_DISPATCH(timr->it_clock, timer_set,
+				       (timr, flags, &new_spec, rtn));
+	}
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
 		rtn = NULL;	// We already got the old time...
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 0f6f913..3345c3a 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -314,3 +314,23 @@ void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
 out:
 	mutex_unlock(&clk->mux);
 }
+
+int clock_device_timer_settime(struct clock_device *clk,
+			       struct k_itimer *kit, int flags,
+			       struct itimerspec *tsp, struct itimerspec *old)
+{
+	int err;
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->timer_settime)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->timer_settime(clk->priv, kit, flags, tsp, old);
+
+	mutex_unlock(&clk->mux);
+
+	return err;
+}
-- 
1.7.0.4

