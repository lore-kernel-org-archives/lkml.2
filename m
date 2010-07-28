Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0G1TeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:34:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12555 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab0G1TdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:33:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49104465"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/4] Documentation: Add timers/timers-howto.txt
Date: Wed, 28 Jul 2010 12:33:05 -0700
Message-Id: <1280345587-19725-3-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
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
	usleep(1000)

This patch is followed by a series of checkpatch additions
that seek to help kernel hackers pick the best delay.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 Documentation/timers/timers-howto.txt |  106 +++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/timers/timers-howto.txt

diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
new file mode 100644
index 0000000..ea10a3a
--- /dev/null
+++ b/Documentation/timers/timers-howto.txt
@@ -0,0 +1,106 @@
+delays - Information on the various kernel delay / sleep mechanisms
+-------------------------------------------------------------------
+
+This document seeks to answer the common question: "What is the
+RightWay (TM) to insert a delay?"
+
+This question is most often faced by driver writers who have to
+deal with hardware delays and who may not be the most intimately
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
+		* Use usleep[_range]
+
+		- Why not msleep for (1ms - 20ms)?
+			Explained originally here:
+				http://lkml.org/lkml/2007/8/3/250
+			msleep(1~20) may not do what the caller intends, and
+			will often sleep longer (~20 ms actual sleep for any
+			value given in the 1~20ms range). In many cases this
+			is not the desired behavior.
+
+		- What is the difference between usleep and usleep_range?
+			Fundamentally nothing; usleep(unsigned long usecs)
+			simply calls usleep_range(usecs, usecs * 2). This
+			built-in slack is similar in spirit to the slack
+			now built-in to legacy timers (0.4%) - and thus
+			built-in to msleep -, although it is significantly
+			larger.
+
+			The reasoning for slack is that usleep is built upon
+			hrtimers, and mindless callers of usleep will actually
+			introduce many undesired interrupts. By allowing a
+			range, wakeups can be coalesced. Given the scale, a
+			200% slack seems a reasonable default value.
+
+			If your application can afford it, use usleep_range
+			to extend the slack to an even larger window; or, if
+			you need a more precise sleep (?), you can use
+			usleep_range to restrict the slack to a tighter bound.
+
+	SLEEPING FOR LARGER MSECS ( 10ms+ )
+		* Use msleep or possibly msleep_interruptible
+
+		- What's the difference?
+			msleep sets the current task to TASK_UNINTERRUPTIBLE
+			whereas msleep_interruptible sets the current task to
+			TASK_INTERRUPTIBLE before scheduling the sleep. In
+			short, the difference is whether the sleep can be ended
+			early by a signal. In general, just use msleep unless
+			you know you have a need for the interruptible variant.
-- 
1.7.2

