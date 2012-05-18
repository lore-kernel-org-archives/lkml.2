Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967989Ab2ERKtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:49:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2ERKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:49:09 -0400
Date: Fri, 18 May 2012 03:48:54 -0700
From: tip-bot for Konstantin Khlebnikov <khlebnikov@openvz.org>
Message-ID: <tip-1d76f4381601a259323ad4faadce18db08ddebcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rdunlap@xenotime.net,
        akpm@linux-foundation.org, khlebnikov@openvz.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rdunlap@xenotime.net,
        akpm@linux-foundation.org, khlebnikov@openvz.org, tglx@linutronix.de
In-Reply-To: <20120517232210.A292EA02FF@akpm.mtv.corp.google.com>
References: <20120517232210.A292EA02FF@akpm.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Set TAINT_UNSAFE_SMP after sleep-in-atomic bug
Git-Commit-ID: 1d76f4381601a259323ad4faadce18db08ddebcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:48:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d76f4381601a259323ad4faadce18db08ddebcd
Gitweb:     http://git.kernel.org/tip/1d76f4381601a259323ad4faadce18db08ddebcd
Author:     Konstantin Khlebnikov <khlebnikov@openvz.org>
AuthorDate: Thu, 17 May 2012 16:22:10 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:51:08 +0200

sched: Set TAINT_UNSAFE_SMP after sleep-in-atomic bug

Usually sleep-in-atomic bugs are followed by dozens other
warnings.  This patch should help to figure out original source
of problem.  This taint flag also turns off lockdep, because it
can go mad after that.

Original TAINT_UNSAFE_SMP is used only on various ancient buggy
K7 Athlons.  TAINT_UNSAFE_SMP is shown as 'S' in "Tainted" line,
so let it be acronym for SMP, Scheduler and Sleep-in-atomic.

Probably we should rename it into TAINT_SHIT, but TAINT_CRAP is
already there. =)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/20120517232210.A292EA02FF@akpm.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/oops-tracing.txt  |    2 +-
 Documentation/sysctl/kernel.txt |    1 +
 kernel/sched/core.c             |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index 13032c0..ad9b9d8 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -237,7 +237,7 @@ characters, each representing a particular tainted value.
   3: 'S' if the oops occurred on an SMP kernel running on hardware that
      hasn't been certified as safe to run multiprocessor.
      Currently this occurs only on various Athlons that are not
-     SMP capable.
+     SMP capable. Also cpu scheduler sets this after sleep-in-atomic bug.
 
   4: 'R' if a module was force unloaded by "rmmod -f", ' ' if all
      modules were unloaded normally.
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..b573910 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -590,6 +590,7 @@ can be ORed together:
    2 - A module was force loaded by insmod -f.
        Set by modutils >= 2.4.9 and module-init-tools.
    4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
+       Also cpu scheduler sets this after sleep-in-atomic bug.
    8 - A module was forcibly unloaded from the system by rmmod -f.
   16 - A hardware machine check error occurred on the system.
   32 - A bad page was discovered on the system.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24ca677..b86eb50 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3138,6 +3138,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_UNSAFE_SMP);
 }
 
 /*
