Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1LAOVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:21:08 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51482 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1LAOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:21:07 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernation: Remove deprecated hibernation test modes
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Thu, 01 Dec 2011 19:50:58 +0530
Message-ID: <20111201142007.23509.24776.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120114-5564-0000-0000-00000056BD41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hibernation test modes 'test' and 'testproc' are deprecated, because
the 'pm_test' framework offers much more fine-grained control for debugging
suspend and hibernation related problems.

So, remove the deprecated 'test' and 'testproc' hibernation test modes.

Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |   33 ++++-----------------------------
 1 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 80c2d90..68c278b 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -43,8 +43,6 @@ int in_suspend __nosavedata;
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
-	HIBERNATION_TEST,
-	HIBERNATION_TESTPROC,
 	HIBERNATION_SHUTDOWN,
 	HIBERNATION_REBOOT,
 	/* keep last */
@@ -96,15 +94,6 @@ static void hibernation_debug_sleep(void)
 	mdelay(5000);
 }
 
-static int hibernation_testmode(int mode)
-{
-	if (hibernation_mode == mode) {
-		hibernation_debug_sleep();
-		return 1;
-	}
-	return 0;
-}
-
 static int hibernation_test(int level)
 {
 	if (pm_test_level == level) {
@@ -114,7 +103,6 @@ static int hibernation_test(int level)
 	return 0;
 }
 #else /* !CONFIG_PM_DEBUG */
-static int hibernation_testmode(int mode) { return 0; }
 static int hibernation_test(int level) { return 0; }
 #endif /* !CONFIG_PM_DEBUG */
 
@@ -278,8 +266,7 @@ static int create_image(int platform_mode)
 		goto Platform_finish;
 
 	error = disable_nonboot_cpus();
-	if (error || hibernation_test(TEST_CPUS)
-	    || hibernation_testmode(HIBERNATION_TEST))
+	if (error || hibernation_test(TEST_CPUS))
 		goto Enable_cpus;
 
 	local_irq_disable();
@@ -349,8 +336,7 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Cleanup;
 
-	if (hibernation_test(TEST_FREEZER) ||
-		hibernation_testmode(HIBERNATION_TESTPROC)) {
+	if (hibernation_test(TEST_FREEZER)) {
 
 		/*
 		 * Indicate to the caller that we are returning due to a
@@ -586,9 +572,6 @@ int hibernation_platform_enter(void)
 static void power_down(void)
 {
 	switch (hibernation_mode) {
-	case HIBERNATION_TEST:
-	case HIBERNATION_TESTPROC:
-		break;
 	case HIBERNATION_REBOOT:
 		kernel_restart(NULL);
 		break;
@@ -840,8 +823,6 @@ static const char * const hibernation_modes[] = {
 	[HIBERNATION_PLATFORM]	= "platform",
 	[HIBERNATION_SHUTDOWN]	= "shutdown",
 	[HIBERNATION_REBOOT]	= "reboot",
-	[HIBERNATION_TEST]	= "test",
-	[HIBERNATION_TESTPROC]	= "testproc",
 };
 
 /*
@@ -850,17 +831,15 @@ static const char * const hibernation_modes[] = {
  * Hibernation can be handled in several ways.  There are a few different ways
  * to put the system into the sleep state: using the platform driver (e.g. ACPI
  * or other hibernation_ops), powering it off or rebooting it (for testing
- * mostly), or using one of the two available test modes.
+ * mostly).
  *
  * The sysfs file /sys/power/disk provides an interface for selecting the
  * hibernation mode to use.  Reading from this file causes the available modes
- * to be printed.  There are 5 modes that can be supported:
+ * to be printed.  There are 3 modes that can be supported:
  *
  *	'platform'
  *	'shutdown'
  *	'reboot'
- *	'test'
- *	'testproc'
  *
  * If a platform hibernation driver is in use, 'platform' will be supported
  * and will be used by default.  Otherwise, 'shutdown' will be used by default.
@@ -884,8 +863,6 @@ static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (i) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
-		case HIBERNATION_TEST:
-		case HIBERNATION_TESTPROC:
 			break;
 		case HIBERNATION_PLATFORM:
 			if (hibernation_ops)
@@ -926,8 +903,6 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (mode) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
-		case HIBERNATION_TEST:
-		case HIBERNATION_TESTPROC:
 			hibernation_mode = mode;
 			break;
 		case HIBERNATION_PLATFORM:

