Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2A3XPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:15:32 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46342 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2A3XP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:15:29 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 4/4] PM/Hibernate: Refactor and simplify freezer_test_done
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:45:19 +0530
Message-ID: <20120130231513.11129.92320.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013023-5564-0000-0000-0000012A69EA
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
index 0ce1220..30b315a 100644
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
@@ -665,6 +661,10 @@ int hibernate(void)
 
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
index 62dbe93..056088e 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -259,10 +259,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
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
 

