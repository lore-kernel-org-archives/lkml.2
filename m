Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2EJHyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:54:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46537 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2EJHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:54:08 -0400
Subject: [PATCH] sched: set TAINT_UNSAFE_SMP after sleep-in-atomic bug
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 10 May 2012 11:54:03 +0400
Message-ID: <20120510075403.21849.5109.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually sleep-in-atomic bugs are followed by dozens other warnings.
This patch should help to figure out original source of problem.
This taint flag also turns off lockdep, because it can go mad after that.

Original TAINT_UNSAFE_SMP is used only on various ancient buggy K7 Athlons.
TAINT_UNSAFE_SMP is shown as 'S' in "Tainted" line, so let it be acronym for
SMP, Scheduler and Sleep-in-atomic. Probably we should rename it into
TAINT_SHIT, but TAINT_CRAP is already there. =)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 Documentation/oops-tracing.txt  |    2 +-
 Documentation/sysctl/kernel.txt |    1 +
 kernel/sched/core.c             |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

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
index 0533a68..5e39914 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3113,6 +3113,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_UNSAFE_SMP);
 }
 
 /*

