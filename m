Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab2DKXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab2DKXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:54 -0400
Message-Id: <20120411231025.528830088@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 43/78] PM / Hibernate: Disable usermode helpers right before freezing tasks
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 7b5179ac14dbad945647ac9e76bbbf14ed9e0dbe upstream.

There is no reason to call usermodehelper_disable() before creating
memory bitmaps in hibernate() and software_resume(), so call it right
before freeze_processes(), in accordance with the other suspend and
hibernation code.  Consequently, call usermodehelper_enable() right
after the thawing of tasks rather than after freeing the memory
bitmaps.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -609,19 +609,19 @@ int hibernate(void)
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
@@ -658,9 +658,8 @@ int hibernate(void)
  Thaw:
 	thaw_processes();
  Free_bitmaps:
-	free_basic_memory_bitmaps();
- Enable_umh:
 	usermodehelper_enable();
+	free_basic_memory_bitmaps();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	pm_restore_console();
@@ -775,15 +774,13 @@ static int software_resume(void)
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
@@ -803,8 +800,8 @@ static int software_resume(void)
 	swsusp_free();
 	thaw_processes();
  Done:
-	free_basic_memory_bitmaps();
 	usermodehelper_enable();
+	free_basic_memory_bitmaps();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
 	pm_restore_console();


