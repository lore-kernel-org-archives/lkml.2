Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1JKUUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:20:10 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42257 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1JKUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:20:07 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] Documentation/power: Update docs about suspend and CPU hotplug
To: rdunlap@xenotime.net
Cc: rjw@sisk.pl, len.brown@intel.com, pavel@ucw.cz, a.p.zijlstra@chello.nl,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 01:49:59 +0530
Message-ID: <20111011201958.10065.78949.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation about the interaction between the suspend (S3) call
path and the CPU hotplug infrastructure.
This patch focusses only on the activities of the freezer, cpu hotplug and
the notifications involved. It outlines how regular CPU hotplug differs from
the way it is invoked during suspend and also tries to explain the locking
involved.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/00-INDEX                   |    2 
 Documentation/power/suspend-and-cpuhotplug.txt |  113 ++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/suspend-and-cpuhotplug.txt

diff --git a/Documentation/power/00-INDEX b/Documentation/power/00-INDEX
index 45e9d4a..a4d682f 100644
--- a/Documentation/power/00-INDEX
+++ b/Documentation/power/00-INDEX
@@ -26,6 +26,8 @@ s2ram.txt
 	- How to get suspend to ram working (and debug it when it isn't)
 states.txt
 	- System power management states
+suspend-and-cpuhotplug.txt
+	- Explains the interaction between Suspend-to-RAM (S3) and CPU hotplug
 swsusp-and-swap-files.txt
 	- Using swap files with software suspend (to disk)
 swsusp-dmcrypt.txt
diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
new file mode 100644
index 0000000..d0ba411
--- /dev/null
+++ b/Documentation/power/suspend-and-cpuhotplug.txt
@@ -0,0 +1,113 @@
+Interaction of Suspend code (S3) with the CPU hotplug infrastructure
+   (C) 2011 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>, GPL
+
+
+I. How does the Suspend-to-RAM code interact with CPU hotplug infrastructure?
+
+Well, a picture speaks more than a thousand words... So ASCII art follows :-)
+
+[This depicts the current design in the kernel, and focusses only on the
+interactions between suspend call paths involving the freezer and cpu hotplug
+and also tries to explain the locking involved. It also outlines the
+notifications involved.]
+
+On a high level, the suspend-resume cycle goes like this:
+
+|Freeze| -> |Disable nonboot| -> |Do suspend| -> |Enable nonboot| -> |Thaw |
+|tasks |    |     cpus      |    |          |    |     cpus     |    |tasks|
+
+
+More details follow:
+
+Regular CPU hotplug                                   Suspend call path
+-------------------                              ---------------------------
+
+Write 0 (or 1) to                                     Write 'mem' to
+/sys/devices/system/cpu/cpu*/online                   /sys/power/state
+     sysfs file                                          syfs file
+         |                                                   |
+         |                                                   v
+         |                                         Acquire pm_mutex lock
+         |                                                   |
+         |                                                   v
+         |                                Send PM_SUSPEND_PREPARE notifications
+         |                                                   |
+         |                                                   v
+         |                                              Freeze tasks
+         |                                                   |
+         |                                                   |
+         v                                                   v
+     cpu_down()                                 disable_nonboot_cpus() /*start*/
+         |                                                   |
+         v                                                   v
+Acquire cpu_add_remove_lock                     Acquire cpu_add_remove_lock
+         |                                                   |
+         v                                                   v
+If cpu_hotplug_disabled is 1                 Iterate over CURRENTLY online CPUs
+   return gracefully                                         |
+         |                                                   |
+         |                                                   |           ----
+         v                                                   v               |
+           \                                               /                 |
+             --------                             --------                   |
+                      \                         /                            |
+                        --------       --------                              |L
+                                 \____/                                      |
+                                   |                                         |
+                                   v                                         |O
+                              _cpu_down()                                    |
+                     [This takes cpuhotplug.lock                             |
+                      before taking down the CPU                             |
+                      and releases it when done]                             |O
+                   While it is at it, notifications                          |
+                   are sent when notable events occur,                       |
+                   by running all registered callbacks.                      |
+                                   |                                         |O
+                                  / \                                        |
+                                 /   \                                       |
+                                <     >                                      |
+        _______________________/       \_____________________                |P
+       |                                                     |               |
+       v                                                     v               |
+Release cpu_add_remove_lock                      Note down these cpus in     |
+[That's it!, for                                     frozen_cpus mask    ----
+ regular CPU hotplug]                                        |
+                                                             v
+                                                  Disable regular cpu hotplug
+                                              by setting cpu_hotplug_disabled=1
+                                                             |
+                                                             v
+                                                Release cpu_add_remove_lock
+                                                             |
+                                                             v
+                                          /* disable_nonboot_cpus() complete */
+                                                             |
+                                                             v
+                                                        Do suspend
+
+
+Resuming back is likewise, with the counterparts being (in the order of
+execution during resume):
+* enable_nonboot_cpus() which involves:
+   |  Acquire cpu_add_remove_lock
+   |  Reset cpu_hotplug_disabled to 0, thereby enabling regular cpu hotplug
+   |  Call _cpu_up() [for all those cpus in the frozen_cpus mask, in a loop]
+   |  Release cpu_add_remove_lock
+   v
+
+* thaw tasks
+* send PM_POST_SUSPEND notifications
+* Release pm_mutex lock.
+
+It is to be noted here that the pm_mutex lock is acquired at the very
+beginning, when we are just starting out to suspend, and then released only
+after the entire cycle is complete (i.e., suspend + resume).
+
+
+Important files and functions/entry points:
+------------------------------------------
+
+kernel/power/process.c : freeze_processes(), thaw_processes()
+kernel/power/suspend.c : suspend_prepare(), suspend_enter(), suspend_finish()
+kernel/cpu.c: cpu_[up|down](), _cpu_[up|down](), [disable|enable]_nonboot_cpus()
+

