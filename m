Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2BPMX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:23:28 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45976 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2BPMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:23:27 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Hibernate: Enable usermodehelpers in hibernate() error path
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 16 Feb 2012 17:53:17 +0530
Message-ID: <20120216122243.14749.34988.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021612-4790-0000-0000-0000015B08FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If create_basic_memory_bitmaps() fails, usermodehelpers are not re-enabled
before returning. Fix this. And while at it, reword the goto labels so that
they look more meaningful.

Cc: stable@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 72baaf0..0a186cf 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -618,7 +618,7 @@ int hibernate(void)
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
 	if (error)
-		goto Exit;
+		goto Enable_umh;
 
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
@@ -626,7 +626,7 @@ int hibernate(void)
 
 	error = freeze_processes();
 	if (error)
-		goto Finish;
+		goto Free_bitmaps;
 
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
 	if (error || freezer_test_done)
@@ -659,8 +659,9 @@ int hibernate(void)
 	/* Don't bother checking whether freezer_test_done is true */
 	freezer_test_done = false;
 
- Finish:
+ Free_bitmaps:
 	free_basic_memory_bitmaps();
+ Enable_umh:
 	usermodehelper_enable();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);

