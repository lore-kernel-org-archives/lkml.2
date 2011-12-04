Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1LDUEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:04:06 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44897 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1LDUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:04:03 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/3] PM / Docs: Recommend the use of [un]lock_system_sleep()
 over mutex_[un]lock(&pm_mutex)
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com, tj@kernel.org,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 05 Dec 2011 01:33:42 +0530
Message-ID: <20111204200332.25620.53610.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120410-1396-0000-0000-00000058B4B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to explain the perils of directly using
mutex_[un]lock(&pm_mutex) and recommend the usage of the safe
APIs [un]lock_system_sleep() instead.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/freezing-of-tasks.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 3ab9fbd..6ccb68f 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -176,3 +176,28 @@ tasks, since it generally exists anyway.
 A driver must have all firmwares it may need in RAM before suspend() is called.
 If keeping them is not practical, for example due to their size, they must be
 requested early enough using the suspend notifier API described in notifiers.txt.
+
+VI. Are there any precautions to be taken to prevent freezing failures?
+
+Yes, there are.
+
+First of all, grabbing the 'pm_mutex' lock to mutually exclude a piece of code
+from system-wide sleep such as suspend/hibernation is not encouraged.
+If possible, that piece of code must instead hook onto the suspend/hibernation
+notifiers to achieve mutual exclusion. Look at the CPU-Hotplug code
+(kernel/cpu.c) for an example.
+
+However, if that is not feasible, and grabbing 'pm_mutex' is deemed necessary,
+it is strongly discouraged to directly call mutex_[un]lock(&pm_mutex) since
+that could lead to freezing failures, because if the suspend/hibernate code
+successfully acquired the 'pm_mutex' lock, and hence that other entity failed
+to acquire the lock, then that task would get blocked in TASK_UNINTERRUPTIBLE
+state. As a consequence, the freezer would not be able to freeze that task,
+leading to freezing failure.
+
+However, the [un]lock_system_sleep() APIs are safe to use in this scenario,
+since they ask the freezer to skip freezing this task, since it is anyway
+"frozen enough" as it is blocked on 'pm_mutex', which will be released
+only after the entire suspend/hibernation sequence is complete.
+So, to summarize, use [un]lock_system_sleep() instead of directly using
+mutex_[un]lock(&pm_mutex). That would prevent freezing failures.

