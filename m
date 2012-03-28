Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2C1VXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:23:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40772 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641Ab2C1VWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:22:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] PM / Hibernate: Disable usermode helpers right before freezing tasks
Date: Wed, 28 Mar 2012 23:23:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282323.03490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is no reason to call usermodehelper_disable() before creating
memory bitmaps in hibernate() and software_resume(), so call it right
before freeze_processes(), in accordance with the other suspend and
hibernation code.  Consequently, call usermodehelper_enable() right
after the thawing of tasks rather than after freeing the memory
bitmaps.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -611,19 +611,19 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
-	error = usermodehelper_disable();
-	if (error)
-		goto Exit;
-
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
 	if (error)
-		goto Enable_umh;
+		goto Exit;
 
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
 
+	error = usermodehelper_disable();
+	if (error)
+		goto Exit;
+
 	error = freeze_processes();
 	if (error)
 		goto Free_bitmaps;
@@ -660,9 +660,8 @@ int hibernate(void)
 	freezer_test_done = false;
 
  Free_bitmaps:
-	free_basic_memory_bitmaps();
- Enable_umh:
 	usermodehelper_enable();
+	free_basic_memory_bitmaps();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	pm_restore_console();
@@ -777,15 +776,13 @@ static int software_resume(void)
 	if (error)
 		goto close_finish;
 
-	error = usermodehelper_disable();
+	error = create_basic_memory_bitmaps();
 	if (error)
 		goto close_finish;
 
-	error = create_basic_memory_bitmaps();
-	if (error) {
-		usermodehelper_enable();
+	error = usermodehelper_disable();
+	if (error)
 		goto close_finish;
-	}
 
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = freeze_processes();
@@ -805,8 +802,8 @@ static int software_resume(void)
 	swsusp_free();
 	thaw_processes();
  Done:
-	free_basic_memory_bitmaps();
 	usermodehelper_enable();
+	free_basic_memory_bitmaps();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
 	pm_restore_console();

