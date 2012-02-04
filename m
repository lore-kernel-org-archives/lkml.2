Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2BDOLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:11:38 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59076 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2BDOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:11:37 -0500
Message-ID: <4F2D3C90.3000708@linux.vnet.ibm.com>
Date: Sat, 04 Feb 2012 19:41:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing
 of kernel threads fails
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <20120201223647.GB19837@google.com> <4F29C3E3.1040108@linux.vnet.ibm.com>
In-Reply-To: <4F29C3E3.1040108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020414-9574-0000-0000-0000013CD1F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:

> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
> 
> If freezing of kernel threads fails, we are expected to automatically thaw
> tasks in the error recovery path. However, at times, we encounter situations
> in which we would like the automatic error recovery path to thaw only the
> kernel threads, because we want to be able to do some more cleanup before
> we thaw userspace. Something like:
> 
> error = freeze_kernel_threads();
> if (error) {
> 	/* Do some cleanup */
> 
> 	/* Only then thaw userspace tasks*/
> 	thaw_processes();
> }
> 
> An example of such a situation is where we freeze/thaw filesystems during
> suspend/hibernation. There, if freezing of kernel threads fails, we would
> like to thaw the frozen filesystems before thawing the userspace tasks.
> 
> So, modify freeze_kernel_threads() to thaw only kernel threads in case of
> freezing failure. And change suspend_freeze_processes() accordingly.
> (At the same time, let us also get rid of the rather cryptic usage of the
> conditional operator (:?) in that function.)
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---


Hi Rafael,

I have reworked the changelog of this patch to indicate that this fixes a
regression. Here is the updated patch:

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails

If freezing of kernel threads fails, we are expected to automatically thaw
tasks in the error recovery path. However, at times, we encounter situations
in which we would like the automatic error recovery path to thaw only the
kernel threads, because we want to be able to do some more cleanup before
we thaw userspace. Something like:

error = freeze_kernel_threads();
if (error) {
	/* Do some cleanup */

	/* Only then thaw userspace tasks*/
	thaw_processes();
}

An example of such a situation is where we freeze/thaw filesystems during
suspend/hibernation. There, if freezing of kernel threads fails, we would
like to thaw the frozen filesystems before thawing the userspace tasks.

So, modify freeze_kernel_threads() to thaw only kernel threads in case of
freezing failure.

This also fixes a regression in hibernation_snapshot() by which, if the
freezing of kernel threads happened to fail, we would thaw every task
(including userspace tasks) before freeing the memory pre-allocated for the
purpose of hibernation (which could be quite significant).

So, thawing only kernel threads upon failure to freeze kernel threads will
give us a chance to free up the pre-allocated memory before thawing userspace
tasks, thereby reducing the probability of unreasonable memory allocation
failures.

And while we are updating suspend_freeze_processes() to adapt to this change,
let us also get rid of the rather cryptic usage of the conditional operator
(:?) in that function.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>
---

 kernel/power/power.h   |   24 ++++++++++++++++++++++--
 kernel/power/process.c |    7 +++++--
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 0c4defe..21724ee 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -231,8 +231,28 @@ extern int pm_test_level;
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
-	int error = freeze_processes();
-	return error ? : freeze_kernel_threads();
+	int error;
+
+	error = freeze_processes();
+
+	/*
+	 * freeze_processes() automatically thaws every task if freezing
+	 * fails. So we need not do anything extra upon error.
+	 */
+	if (error)
+		goto Finish;
+
+	error = freeze_kernel_threads();
+
+	/*
+	 * freeze_kernel_threads() thaws only kernel threads upon freezing
+	 * failure. So we have to thaw the userspace tasks ourselves.
+	 */
+	if (error)
+		thaw_processes();
+
+ Finish:
+	return error;
 }
 
 static inline void suspend_thaw_processes(void)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index eeca003..7e42645 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -143,7 +143,10 @@ int freeze_processes(void)
 /**
  * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0.  On failure, -errno and only the kernel threads are
+ * thawed, so as to give a chance to the caller to do additional cleanups
+ * (if any) before thawing the userspace tasks. So, it is the responsibility
+ * of the caller to thaw the userspace tasks, when the time is right.
  */
 int freeze_kernel_threads(void)
 {
@@ -159,7 +162,7 @@ int freeze_kernel_threads(void)
 	BUG_ON(in_atomic());
 
 	if (error)
-		thaw_processes();
+		thaw_kernel_threads();
 	return error;
 }
 


