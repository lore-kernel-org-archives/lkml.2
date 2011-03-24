Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1CXJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:32:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1CXJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:32:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 18:25:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/5] forkbomb killer config and documentation
Message-Id: <20110324182558.f5f811ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Documentation for forkbomb killer.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/vm/forkbomb.txt |   62 ++++++++++++++++++++++++++++++++++++++++++
 mm/Kconfig                    |   16 ++++++++++
 2 files changed, 78 insertions(+)

Index: mm-work2/Documentation/vm/forkbomb.txt
===================================================================
--- /dev/null
+++ mm-work2/Documentation/vm/forkbomb.txt
@@ -0,0 +1,62 @@
+Forkbomb.txt
+
+1. Intruduction
+   Maybe many programmer have an experience to write a fork-bomb program.
+
+   One example of fork-bomb is a bomb which make system unstable by the
+   memory pressure caused by the number of tasks. This kind of fork-bomb
+   can be limited by ulimit(max user processes). If it happens, the user
+   who has the same owner ID of forkbomb will not be able to do anything
+   but other users(admin) may have a chance to kill them. (Of course,
+   if forkbomb is created by root, we have no chance to recover.)
+
+   Another example of fork-bomb is a bomb which eats much memory. This
+   kind of forkbomb causes huge swapout and make system slow and finally,
+   OOM. In swapless system, the system will see OOM soon. To prevent this
+   type of bomb, memory cgroup or overcommit_memory will be a help. But
+   troubles happen when we don't expected.....
+
+   To recover from fork-bomb, we need to kill all tasks which is in the
+   forkbomb tree, in general. But if the system is in OOM state, killing
+   them all tends to be difficult.
+
+2. Forkbomb Killer.
+   The kernel provides a forkbomb killer. (see mm/Kconfig FORKBOMB_KILLER)
+   If enabled, the forkbomb killer will provides 2 system files.
+
+   /sys/kernel/mm/oom/mm_tracking_enabled
+   /sys/kernel/mm/oom/mm_tracking_reset_interval_msecs
+
+
+   If /sys/kernel/mm/oom/mm_tracking_enabled == enabled, the kernel records
+   all fork/vfork/exec information by an extra structure than usual task
+   management. This information is used for tracking a task tree. Unlike
+   process tree, this doesn't discard parent<->children information even
+   when the parent exits before children and make children as orphan processes.
+   By this, even with following script, task tracking information can be
+   preserved and we have a chance to chase all proceesses in a fork bomb.
+
+   (example) # forkbomb(){ forkbomb|forkbomb & } ; forkbomb
+
+   But this information tracking adds a small overhead at fork/vfork/exec/exit.
+   Default is enabled.
+
+   /sys/kernel/mm/oom/mm_tracking_reset_interval_msecs
+
+   Because we cannot preserve all information since the system boot, we need
+   to forget information. Forkbomb killer checks the system status in each
+   period. What checked now is
+   1. the number of process.
+   2. the number of kswapd runs.
+   3. the number of alloc stalls. (memory reclaim)
+   If all of 1,2,3 aren't increased for mm_tracking_reset_interval_msecs,
+   all tracking information recorded before previous period will be
+   removed.
+   IOW, by making mm_tracking_reset_interval_msecs larger, you can check
+   forkbomb in a long period but will have more overheads. By making it
+   smaller, tracking records are removed earlier and tasks killed by
+   forkbomb killer will decrease (and you can avoid unnecessary kills.)
+   Default is 30secs.
+
+
+
Index: mm-work2/mm/Kconfig
===================================================================
--- mm-work2.orig/mm/Kconfig
+++ mm-work2/mm/Kconfig
@@ -274,6 +274,22 @@ config HWPOISON_INJECT
 	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
 	select PROC_PAGE_MONITOR
 
+config FORKBOMB_KILLER
+	bool "Killing a tree of tasks when a forkbomb is found"
+	depends on EXPERIMENTAL
+	default n
+	select MM_OWNER
+	help
+	  Provide a fork-bomb-killer, which is triggered at OOM.
+	  In usual case, OOM-Killer kills a memory eater processes.
+	  But it kills tasks in conservative way and cannot be a help
+          if forkbomb is running. The admin may need to reboot system
+	  if the influence of the bomb cannot be limited by rlimits or
+	  some security settings. FORKBOMB Killer kills a tree of process
+	  which have started recently and eats much memory. Please see,
+	  Documentation/vm/forkbomb.txt for details. If unsure, say N.
+
+
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
 	depends on !MMU

