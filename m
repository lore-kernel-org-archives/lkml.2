Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2BBBkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:40:40 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60854 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2BBBki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:40:38 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Hibernate: Refactor and simplify freezer_test_done
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 02 Feb 2012 07:10:19 +0530
Message-ID: <20120202014014.11863.86758.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020201-2000-0000-0000-000006456FCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code related to 'freezer_test_done' is needlessly convoluted.
Refactor the code and simplify the implementation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |   10 +++++-----
 kernel/power/user.c      |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index c6dee73..72baaf0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -629,12 +629,8 @@ int hibernate(void)
 		goto Finish;
 
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
-	if (error)
-		goto Thaw;
-	if (freezer_test_done) {
-		freezer_test_done = false;
+	if (error || freezer_test_done)
 		goto Thaw;
-	}
 
 	if (in_suspend) {
 		unsigned int flags = 0;
@@ -659,6 +655,10 @@ int hibernate(void)
 
  Thaw:
 	thaw_processes();
+
+	/* Don't bother checking whether freezer_test_done is true */
+	freezer_test_done = false;
+
  Finish:
 	free_basic_memory_bitmaps();
 	usermodehelper_enable();
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 7bee91f..ea8b1c4 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -251,10 +251,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = hibernation_snapshot(data->platform_support);
 		if (!error) {
 			error = put_user(in_suspend, (int __user *)arg);
-			if (!error && !freezer_test_done)
-				data->ready = 1;
 			if (freezer_test_done)
 				freezer_test_done = false;
+			else if (!error)
+				data->ready = 1;
 		}
 		break;
 

