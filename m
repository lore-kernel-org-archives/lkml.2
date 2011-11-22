Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab1KVVZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:25:52 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58531 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1KVVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:25:50 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernation: Refactor and simplify
 hibernation_snapshot() code
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 23 Nov 2011 02:55:40 +0530
Message-ID: <20111122212500.11648.2252.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11112221-5816-0000-0000-000000281FF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goto statements in hibernation_snapshot() are a bit complex.
Refactor the code to remove some of them, thereby simplifying the
implementation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
This is on top of the patch posted at https://lkml.org/lkml/2011/11/21/498

 kernel/power/hibernate.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a6b0503..ebf62c3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -333,7 +333,7 @@ static int create_image(int platform_mode)
  */
 int hibernation_snapshot(int platform_mode)
 {
-	pm_message_t msg = PMSG_RECOVER;
+	pm_message_t msg;
 	int error;
 
 	error = platform_begin(platform_mode);
@@ -362,26 +362,26 @@ int hibernation_snapshot(int platform_mode)
 
 	error = dpm_prepare(PMSG_FREEZE);
 	if (error) {
-		dpm_complete(msg);
+		dpm_complete(PMSG_RECOVER);
 		goto Cleanup;
 	}
 
 	suspend_console();
 	pm_restrict_gfp_mask();
+
 	error = dpm_suspend(PMSG_FREEZE);
-	if (error)
-		goto Recover_platform;
 
-	if (hibernation_test(TEST_DEVICES))
-		goto Recover_platform;
+	if (error || hibernation_test(TEST_DEVICES))
+		platform_recover(platform_mode);
+	else
+		error = create_image(platform_mode);
 
-	error = create_image(platform_mode);
 	/*
-	 * Control returns here (1) after the image has been created or the
+	 * In the case that we call create_image() above, the control
+	 * returns here (1) after the image has been created or the
 	 * image creation has failed and (2) after a successful restore.
 	 */
 
- Resume_devices:
 	/* We may need to release the preallocated image pages here. */
 	if (error || !in_suspend)
 		swsusp_free();
@@ -399,10 +399,6 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
- Recover_platform:
-	platform_recover(platform_mode);
-	goto Resume_devices;
-
  Cleanup:
 	swsusp_free();
 	goto Close;

