Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0G0Wjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0G0Wj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48987811"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/4] Documentation: Add timers/delays.txt
Date: Tue, 27 Jul 2010 15:39:04 -0700
Message-Id: <1280270347-4409-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
References: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file seeks to explain the nuances in various delays;
many driver writers are not necessarily familiar with the
various kernel timers, their shortfalls, and quirks. When
faced with

ndelay, udelay, mdelay, usleep, usleep_range, msleep, and
msleep_interrubtible

the question "How do I just wait 1 ms for my hardware to
latch?" has the non-intuitive "best" answer:
	usleep_range(1000,2000)

This patch is followed by a series of checkpatch additions
that seek to help kernel hackers pick the best delay.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 Documentation/timers/delays.txt |   97 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/timers/delays.txt

diff --git a/Documentation/timers/delays.txt b/Documentation/timers/delays.txt
new file mode 100644
index 0000000..12fcb7e
--- /dev/null
+++ b/Documentation/timers/delays.txt
@@ -0,0 +1,97 @@
+delays - Information on the various kernel delay / sleep mechanisms
+-------------------------------------------------------------------
+
+This document seeks to answer the common question: "What is the
+RightWay (TM) to insert a delay?"
+
+This question is most often faced by driver writers who have to
+deal with hardware delays and who may not be the most initimately
+familiar with the inner workings of the Linux Kernel.
+
+
+Inserting Delays
+----------------
+
+The first, and most important, question you need to ask is "Is my
+code in an atomic context?"  This should be followed closely by "Does
+it really need to delay in atomic context?" If so...
+
+ATOMIC CONTEXT:
+	You must use the *delay family of functions. These
+	functions use the jiffie estimation of clock speed
+	and will busy wait for enough loop cycles to achieve
+	the desired delay:
+
+	ndelay(unsigned long nsecs)
+	udelay(unsigned long usecs)
+	mdelay(unsgined long msecs)
+
+	udelay is the generally preferred API; ndelay-level
+	precision may not actually exist on many non-PC devices.
+
+	mdelay is macro wrapper around udelay, to account for
+	possible overflow when passing large arguments to udelay.
+	In general, use of mdelay is discouraged.
+
+NON-ATOMIC CONTEXT:
+	You should use the *sleep[_range] family of functions.
+	There are a few more options here, while any of them may
+	work correctly, using the "right" sleep function will
+	help the scheduler, power management, and just make your
+	driver better :)
+
+	-- Backed by busy-wait loop:
+		udelay(unsigned long usecs)
+	-- Backed by hrtimers:
+		usleep(unsigned long usecs)
+		usleep_range(unsigned long min, unsigned long max)
+	-- Backed by jiffies / legacy_timers
+		msleep(unsigned long msecs)
+		msleep_interruptible(unsigned long msecs)
+
+	Unlike the *delay family, the underlying mechanism
+	driving each of these calls varies, thus there are
+	quirks you should be aware of.
+
+
+	SLEEPING FOR "A FEW" USECS ( < ~10us? ):
+		* Use udelay
+
+		- Why not usleep?
+			On slower systems, (embedded, OR perhaps a speed-
+			stepped PC!) the overhead of setting up the hrtimers
+			for usleep *may* not be worth it. Such an evaluation
+			will obviously depend on your specific situation, but
+			it is something to be aware of.
+
+	SLEEPING FOR ~USECS OR SMALL MSECS ( 10us - 20ms):
+		* Use usleep_range
+
+		- Why not msleep for (1ms - 20ms)?
+			Explained originally here:
+				http://lkml.org/lkml/2007/8/3/250
+			msleep(1~20) may not do what the caller intends, and
+			will often sleep longer (~20 ms actual sleep for any
+			value given in the 1~20ms range). In many cases this
+			is not the desired behavior.
+
+		- usleep vs usleep_range:
+			Since usleep is built on top of high-resolution timers,
+			you will trigger an interrupt almost *exactly* when your
+			sleep expires; normally, sleeps (by their nature) do not
+			need this kind of precision. The *much* friendlier
+			usleep_range allows the kernel to complete your sleep
+			any time in the given range, likely when some other
+			interrupt has already woken up the kernel for some other
+			reason.
+
+	SLEEPING FOR LARGER MSECS ( 10ms+ )
+		* Use msleep or possibly msleep_interruptible
+
+		- What's the difference?
+			msleep sets the current task to TASK_UNINTERRUPTIBLE
+			whereas msleep_interruptible sets the current task to
+			TASK_INTERRUBTIBLE before scheduling the sleep. In
+			short, the difference is whether the sleep can be ended
+			early by a signal. In general, just use msleep unless
+			you know you have a need for the interruptible varient.
-- 
1.7.2

