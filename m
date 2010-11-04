Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0KDT26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:28:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42120 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0KDT24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hawp4SP7ZRmWvGkj7ra21F6S2WO4XQolesbkxzSd/ypR45lrm38KReNQ4e+fagpsgk
         fwTkJEGllfaG+z9gqgIjGFT4yQit98Q4b6QReNtCtx4t87W6GAny54m/+IorMD3rGIeu
         /hTzGpxi8FWwpTq0/OyejqiyFy3NwUzt2FdKU=
Date: Thu, 4 Nov 2010 20:28:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC 3/8] clock device: convert clock_getres
Message-ID: <b876aeff06dc000704f093cf7694c7f07ebca412.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the clock_getres system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |    3 +--
 kernel/time/clockdevice.c    |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 70f40e6..7d6a4f0 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -137,5 +137,6 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 int posix_clock_gettime(const clockid_t clock, struct timespec __user *tp);
+int posix_clock_getres(const clockid_t clock, struct timespec __user *tp);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4aecbfa..baa6a2e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -969,8 +969,7 @@ int posix_clock_gettime(const clockid_t which_clock,
 
 }
 
-SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
-		struct timespec __user *, tp)
+int posix_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
 {
 	struct timespec rtn_tp;
 	int error;
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index e80117b..6629ae7 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -211,3 +211,30 @@ SYSCALL_DEFINE2(clock_gettime,
 	mutex_unlock(&clk->mux);
 	return err;
 }
+
+SYSCALL_DEFINE2(clock_getres,
+		const clockid_t, id, struct timespec __user *, user_ts)
+{
+	struct timespec ts;
+	struct clock_device *clk;
+	int err;
+
+	clk = clockid_to_clock_device(id);
+	if (!clk)
+		return posix_clock_getres(id, user_ts);
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->clock_getres)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->clock_getres(clk->priv, &ts);
+
+	if (!err && user_ts && copy_to_user(user_ts, &ts, sizeof(ts)))
+		err = -EFAULT;
+
+	mutex_unlock(&clk->mux);
+	return err;
+}
-- 
1.7.0.4

