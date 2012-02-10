Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024Ab2BJXS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:18:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574Ab2BJWlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:22 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.625307924@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [patch 29/86] PM / Hibernate: Fix s2disk regression related to freezing workqueues
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 181e9bdef37bfcaa41f3ab6c948a2a0d60a268b5 upstream.

Commit 2aede851ddf08666f68ffc17be446420e9d2a056

  PM / Hibernate: Freeze kernel threads after preallocating memory

introduced a mechanism by which kernel threads were frozen after
the preallocation of hibernate image memory to avoid problems with
frozen kernel threads not responding to memory freeing requests.
However, it overlooked the s2disk code path in which the
SNAPSHOT_CREATE_IMAGE ioctl was run directly after SNAPSHOT_FREE,
which caused freeze_workqueues_begin() to BUG(), because it saw
that worqueues had been already frozen.

Although in principle this issue might be addressed by removing
the relevant BUG_ON() from freeze_workqueues_begin(), that would
reintroduce the very problem that commit 2aede851ddf08666f68ffc17be4
attempted to avoid into that particular code path.  For this reason,
to fix the issue at hand, introduce thaw_kernel_threads() and make
the SNAPSHOT_FREE ioctl execute it.

Special thanks to Srivatsa S. Bhat for detailed analysis of the
problem.

Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/freezer.h |    2 ++
 kernel/power/process.c  |    9 +++++++++
 kernel/power/user.c     |    9 +++++++++
 3 files changed, 20 insertions(+)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -51,6 +51,7 @@ extern void refrigerator(void);
 extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
+extern void thaw_kernel_threads(void);
 
 static inline int try_to_freeze(void)
 {
@@ -185,6 +186,7 @@ static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
+static inline void thaw_kernel_threads(void) {}
 
 static inline int try_to_freeze(void) { return 0; }
 
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -203,3 +203,12 @@ void thaw_processes(void)
 	printk("done.\n");
 }
 
+void thaw_kernel_threads(void)
+{
+	printk("Restarting kernel threads ... ");
+	thaw_workqueues();
+	thaw_tasks(true);
+	schedule();
+	printk("done.\n");
+}
+
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -303,6 +303,15 @@ static long snapshot_ioctl(struct file *
 		swsusp_free();
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
 		data->ready = 0;
+		/*
+		 * It is necessary to thaw kernel threads here, because
+		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
+		 * SNAPSHOT_FREE.  In that case, if kernel threads were not
+		 * thawed, the preallocation of memory carried out by
+		 * hibernation_snapshot() might run into problems (i.e. it
+		 * might fail or even deadlock).
+		 */
+		thaw_kernel_threads();
 		break;
 
 	case SNAPSHOT_SET_IMAGE_SIZE:


