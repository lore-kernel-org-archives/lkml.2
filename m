Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1KURkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:40:08 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33724 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1KURkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:40:06 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernation: Fix *massive* memory leak at early exits in
 hibernation
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Mon, 21 Nov 2011 23:09:48 +0530
Message-ID: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11112107-1396-0000-0000-000000465C3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some of the early exit points during hibernation (exiting either due
to failure or after a successful hibernation test, the memory pre-allocated
for hibernation is not freed up. And this is *very* serious, because, during
pre-allocation, it could have allocated upto a few *gigabytes* of memory!
And hence, if a hibernation fails or even if we run some hibernation tests
using the 'pm_test' framework, the system is rendered unstable due to memory
becoming signifantly lower. Fix this bug.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 196c0126..dfe07fd 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -346,8 +346,10 @@ int hibernation_snapshot(int platform_mode)
 		goto Close;
 
 	error = freeze_kernel_threads();
-	if (error)
+	if (error) {
+		swsusp_free();
 		goto Close;
+	}
 
 	if (hibernation_test(TEST_FREEZER) ||
 		hibernation_testmode(HIBERNATION_TESTPROC)) {
@@ -357,12 +359,15 @@ int hibernation_snapshot(int platform_mode)
 		 * successful freezer test.
 		 */
 		freezer_test_done = true;
+		swsusp_free();
 		goto Close;
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
-	if (error)
+	if (error) {
+		swsusp_free();
 		goto Complete_devices;
+	}
 
 	suspend_console();
 	pm_restrict_gfp_mask();

