Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1KUWW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:22:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1KUWWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:22:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early exits in hibernation
Date: Mon, 21 Nov 2011 23:25:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111212325.39330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 21, 2011, Srivatsa S. Bhat wrote:
> At some of the early exit points during hibernation (exiting either due
> to failure or after a successful hibernation test, the memory pre-allocated
> for hibernation is not freed up. And this is *very* serious, because, during
> pre-allocation, it could have allocated upto a few *gigabytes* of memory!
> And hence, if a hibernation fails or even if we run some hibernation tests
> using the 'pm_test' framework, the system is rendered unstable due to memory
> becoming signifantly lower. Fix this bug.

While the observation is valid, I'd prefer to do something like the patch
below.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Do not leak memory in error/test code paths

The hibernation core code forgets to release memory preallocated
for hibernation if there's an error in its early stages or if test
modes causing hibernation_snapshot() to return early are used.  This
causes the system to be hardly usable, because the amount of
preallocated memory is usually huge.  Fix this problem.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/hibernate.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -347,7 +347,7 @@ int hibernation_snapshot(int platform_mo
 
 	error = freeze_kernel_threads();
 	if (error)
-		goto Close;
+		goto Cleanup;
 
 	if (hibernation_test(TEST_FREEZER) ||
 		hibernation_testmode(HIBERNATION_TESTPROC)) {
@@ -357,12 +357,14 @@ int hibernation_snapshot(int platform_mo
 		 * successful freezer test.
 		 */
 		freezer_test_done = true;
-		goto Close;
+		goto Cleanup;
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
-	if (error)
-		goto Complete_devices;
+	if (error) {
+		dpm_complete(msg);
+		goto Cleanup;
+	}
 
 	suspend_console();
 	pm_restrict_gfp_mask();
@@ -391,8 +393,6 @@ int hibernation_snapshot(int platform_mo
 		pm_restore_gfp_mask();
 
 	resume_console();
-
- Complete_devices:
 	dpm_complete(msg);
 
  Close:
@@ -402,6 +402,10 @@ int hibernation_snapshot(int platform_mo
  Recover_platform:
 	platform_recover(platform_mode);
 	goto Resume_devices;
+
+ Cleanup:
+	swsusp_free();
+	goto Close;
 }
 
 /**
