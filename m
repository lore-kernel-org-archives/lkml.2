Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2EJI4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:56:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab2EJI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:56:28 -0400
Date: Thu, 10 May 2012 01:55:41 -0700
From: tip-bot for Minho Ban <mhban@samsung.com>
Message-ID: <tip-b02ee9a33b65bcc4ad13c12a0b04afdaab3ddd8d@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        a.p.zijlstra@chello.nl, pjt@google.com, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, rostedt@goodmis.org, mhban@samsung.com,
        josh@joshtriplett.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, a.p.zijlstra@chello.nl,
        seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        mhban@samsung.com, tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <4FA73510.7070705@samsung.com>
References: <4FA73510.7070705@samsung.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Prevent wasting time evaluating parameters in trace_preempt_on/off
Git-Commit-ID: b02ee9a33b65bcc4ad13c12a0b04afdaab3ddd8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 01:55:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b02ee9a33b65bcc4ad13c12a0b04afdaab3ddd8d
Gitweb:     http://git.kernel.org/tip/b02ee9a33b65bcc4ad13c12a0b04afdaab3ddd8d
Author:     Minho Ban <mhban@samsung.com>
AuthorDate: Mon, 7 May 2012 11:36:00 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 8 May 2012 09:33:52 -0400

tracing: Prevent wasting time evaluating parameters in trace_preempt_on/off

This fixes spending time for evaluating parameters in trace_preempt_on/off when
the tracer config is off.

The patch mainly inspired by Steven Rostedt, thanks Steven.

Link: http://lkml.kernel.org/r/4FA73510.7070705@samsung.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Minho Ban <mhban@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b55903..d32cc5e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -491,8 +491,12 @@ static inline void __ftrace_enabled_restore(int enabled)
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
 #else
-  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
-  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
+/*
+ * Use defines instead of static inlines because some arches will make code out
+ * of the CALLER_ADDR, when we really want these to be a real nop.
+ */
+# define trace_preempt_on(a0, a1) do { } while (0)
+# define trace_preempt_off(a0, a1) do { } while (0)
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
