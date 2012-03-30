Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935321Ab2C3Wn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:43:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55577 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935169Ab2C3VHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:16 -0400
Message-Id: <20120330195733.653280263@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 080/108] PM / Hibernate: Enable usermodehelpers in hibernate() error path
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit 05b4877f6a4f1ba4952d1222213d262bf8c132b7 upstream.

If create_basic_memory_bitmaps() fails, usermodehelpers are not re-enabled
before returning. Fix this. And while at it, reword the goto labels so that
they look more meaningful.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -623,7 +623,7 @@ int hibernate(void)
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
 	if (error)
-		goto Exit;
+		goto Enable_umh;
 
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
@@ -631,7 +631,7 @@ int hibernate(void)
 
 	error = prepare_processes();
 	if (error)
-		goto Finish;
+		goto Free_bitmaps;
 
 	if (hibernation_test(TEST_FREEZER))
 		goto Thaw;
@@ -663,8 +663,9 @@ int hibernate(void)
 
  Thaw:
 	thaw_processes();
- Finish:
+ Free_bitmaps:
 	free_basic_memory_bitmaps();
+ Enable_umh:
 	usermodehelper_enable();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);


