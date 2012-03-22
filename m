Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378Ab2CVNNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:13:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50792 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2CVNNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:13:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Freezer/Docs: Update documentation about freezing of tasks
To: rjw@sisk.pl
Cc: lenb@kernel.org, pavel@ucw.cz, rdunlap@xenotime.net,
        marcos.souza.org@gmail.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Mar 2012 18:43:09 +0530
Message-ID: <20120322131134.20354.31966.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032203-1618-0000-0000-0000012083FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

The file Documentation/power/freezing-of-tasks.txt was still referencing
the TIF_FREEZE flag, that was removed by the commit
d88e4cb67197d007fb778d62fe17360e970d5bfa(freezer: remove now unused
TIF_FREEZE).

This patch removes all the references of TIF_FREEZE that were left
behind.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/freezing-of-tasks.txt |   37 +++++++++++++++--------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index ec715cd..6ec291e 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -9,7 +9,7 @@ architectures).
 
 II. How does it work?
 
-There are four per-task flags used for that, PF_NOFREEZE, PF_FROZEN, TIF_FREEZE
+There are three per-task flags used for that, PF_NOFREEZE, PF_FROZEN
 and PF_FREEZER_SKIP (the last one is auxiliary).  The tasks that have
 PF_NOFREEZE unset (all user space processes and some kernel threads) are
 regarded as 'freezable' and treated in a special way before the system enters a
@@ -17,30 +17,31 @@ suspend state as well as before a hibernation image is created (in what follows
 we only consider hibernation, but the description also applies to suspend).
 
 Namely, as the first step of the hibernation procedure the function
-freeze_processes() (defined in kernel/power/process.c) is called.  It executes
-try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
-either wakes them up, if they are kernel threads, or sends fake signals to them,
-if they are user space processes.  A task that has TIF_FREEZE set, should react
-to it by calling the function called __refrigerator() (defined in
-kernel/freezer.c), which sets the task's PF_FROZEN flag, changes its state
-to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
-Then, we say that the task is 'frozen' and therefore the set of functions
-handling this mechanism is referred to as 'the freezer' (these functions are
-defined in kernel/power/process.c, kernel/freezer.c & include/linux/freezer.h).
-User space processes are generally frozen before kernel threads.
+freeze_processes() (defined in kernel/power/process.c) is called.  A system-wide
+variable system_freezing_cnt (as opposed to a per-task flag) is used to indicate
+whether the system is to undergo a freezing operation. And freeze_processes()
+sets this variable.  After this, it executes try_to_freeze_tasks() that sends a
+fake signal to all user space processes, and wakes up all the kernel threads.
+All freezable tasks must react to that by calling try_to_freeze(), which
+results in a call to __refrigerator() (defined in kernel/freezer.c), which sets
+the task's PF_FROZEN flag, changes its state to TASK_UNINTERRUPTIBLE and makes
+it loop until PF_FROZEN is cleared for it. Then, we say that the task is
+'frozen' and therefore the set of functions handling this mechanism is referred
+to as 'the freezer' (these functions are defined in kernel/power/process.c,
+kernel/freezer.c & include/linux/freezer.h). User space processes are generally
+frozen before kernel threads.
 
 __refrigerator() must not be called directly.  Instead, use the
 try_to_freeze() function (defined in include/linux/freezer.h), that checks
-the task's TIF_FREEZE flag and makes the task enter __refrigerator() if the
-flag is set.
+if the task is to be frozen and makes the task enter __refrigerator().
 
 For user space processes try_to_freeze() is called automatically from the
 signal-handling code, but the freezable kernel threads need to call it
 explicitly in suitable places or use the wait_event_freezable() or
 wait_event_freezable_timeout() macros (defined in include/linux/freezer.h)
-that combine interruptible sleep with checking if TIF_FREEZE is set and calling
-try_to_freeze().  The main loop of a freezable kernel thread may look like the
-following one:
+that combine interruptible sleep with checking if the task is to be frozen and
+calling try_to_freeze().  The main loop of a freezable kernel thread may look
+like the following one:
 
 	set_freezable();
 	do {
@@ -53,7 +54,7 @@ following one:
 (from drivers/usb/core/hub.c::hub_thread()).
 
 If a freezable kernel thread fails to call try_to_freeze() after the freezer has
-set TIF_FREEZE for it, the freezing of tasks will fail and the entire
+initiated a freezing operation, the freezing of tasks will fail and the entire
 hibernation operation will be cancelled.  For this reason, freezable kernel
 threads must call try_to_freeze() somewhere or use one of the
 wait_event_freezable() and wait_event_freezable_timeout() macros.

