Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0C0CEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:04:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:54728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0C0CEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:04:11 -0400
Date: Sat, 27 Mar 2010 02:03:57 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4BA97FA1.7030606@cn.fujitsu.com>
References: <4BA97FA1.7030606@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix lockdep warning in global_clock()
Message-ID: <tip-581fe9449d181f6bd5afc5dcae37526eeee02b1d@git.kernel.org>
Git-Commit-ID: 581fe9449d181f6bd5afc5dcae37526eeee02b1d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Mar 2010 02:03:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  581fe9449d181f6bd5afc5dcae37526eeee02b1d
Gitweb:     http://git.kernel.org/tip/581fe9449d181f6bd5afc5dcae37526eeee02b1d
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Mar 2010 10:57:37 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 26 Mar 2010 15:41:59 -0400

tracing: Fix lockdep warning in global_clock()

# echo 1 > events/enable
 # echo global > trace_clock

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
...
---[ end trace 3f86734a89416623 ]---
possible reason: unannotated irqs-on.
...

There's no reason to use the raw_local_irq_save() in trace_clock_global.
The local_irq_save() version is fine, and does not cause the bug in lockdep.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BA97FA1.7030606@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6fbfb8f..9d589d8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
 	int this_cpu;
 	u64 now;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
 	now = cpu_clock(this_cpu);
@@ -110,7 +110,7 @@ u64 notrace trace_clock_global(void)
 	arch_spin_unlock(&trace_clock_struct.lock);
 
  out:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return now;
 }
