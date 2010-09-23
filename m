Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0IWW5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:57:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36339 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab0IWW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:57:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM / Hibernate: Make some boot messages look less scary
Date: Fri, 24 Sep 2010 00:56:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009240056.41308.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Make some boot messages look less scary

The hibernate resume code checks if there is an image to resume from
on every boot and, if the kernel is built with CONFIG_PM_DEBUG set
and the image is not present, it prints some scary messages
suggesting there was a boot error of some sort.  Apparently, some
users are confused by them, so make them look less scary and adjust
the other hibernate resume debug messages to match them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/hibernate.c |   12 ++++++------
 kernel/power/swap.c      |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -929,13 +929,13 @@ put:
 		if (error)
 			blkdev_put(hib_resume_bdev, FMODE_READ);
 		else
-			pr_debug("PM: Signature found, resuming\n");
+			pr_debug("PM: Image signature found, resuming\n");
 	} else {
 		error = PTR_ERR(hib_resume_bdev);
 	}
 
 	if (error)
-		pr_debug("PM: Error %d checking image file\n", error);
+		pr_debug("PM: Image not found (code %d)\n", error);
 
 	return error;
 }
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -708,7 +708,7 @@ static int software_resume(void)
 		goto Unlock;
 	}
 
-	pr_debug("PM: Checking image partition %s\n", resume_file);
+	pr_debug("PM: Checking hibernation image partition %s\n", resume_file);
 
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
@@ -733,10 +733,10 @@ static int software_resume(void)
 	}
 
  Check_image:
-	pr_debug("PM: Resume from partition %d:%d\n",
+	pr_debug("PM: Hibernation image partition %d:%d present\n",
 		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
-	pr_debug("PM: Checking hibernation image.\n");
+	pr_debug("PM: Looking for hibernation image.\n");
 	error = swsusp_check();
 	if (error)
 		goto Unlock;
@@ -768,14 +768,14 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	pr_debug("PM: Reading hibernation image.\n");
+	pr_debug("PM: Loading hibernation image.\n");
 
 	error = swsusp_read(&flags);
 	swsusp_close(FMODE_READ);
 	if (!error)
 		hibernation_restore(flags & SF_PLATFORM_MODE);
 
-	printk(KERN_ERR "PM: Restore failed, recovering.\n");
+	printk(KERN_ERR "PM: Failed to load hibernation image, recovering.\n");
 	swsusp_free();
 	thaw_processes();
  Done:
@@ -788,7 +788,7 @@ static int software_resume(void)
 	/* For success case, the suspend path will release the lock */
  Unlock:
 	mutex_unlock(&pm_mutex);
-	pr_debug("PM: Resume from disk failed.\n");
+	pr_debug("PM: Hibernation image not present or could not be loaded.\n");
 	return error;
 close_finish:
 	swsusp_close(FMODE_READ);
