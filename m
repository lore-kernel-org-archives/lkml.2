Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2BQSeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:34:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40406 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2BQSd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6m4fM79hFujFXb1-w4UK7ki11yRjrbsFOYi1VeRM4CNw@mail.gmail.com>
References: <201201281445.49377.rjw@sisk.pl>
	<CA+5PVA6m4fM79hFujFXb1-w4UK7ki11yRjrbsFOYi1VeRM4CNw@mail.gmail.com>
Date: Fri, 17 Feb 2012 13:33:57 -0500
Message-ID: <CA+5PVA4YWsBx2P0aKER7avMEMRb+OiRuo4HErFO=n87QDKtpbQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
From: Josh Boyer <jwboyer@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 10:41 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Sat, Jan 28, 2012 at 8:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>
>> Freeze all filesystems during system suspend and (kernel-driven)
>> hibernation by calling freeze_supers() for all superblocks and thaw
>> them during the subsequent resume with the help of thaw_supers().
>>
>> This makes filesystems stay in a consistent state in case something
>> goes wrong between system suspend (or hibernation) and the subsequent
>> resume (e.g. journal replays won't be necessary in those cases).  In
>> particular, this should help to solve a long-standing issue that, in
>> some cases, during resume from hibernation the boot loader causes the
>> journal to be replied for the filesystem containing the kernel image
>> and/or initrd causing it to become inconsistent with the information
>> stored in the hibernation image.
>>
>> The user-space-driven hibernation (s2disk) is not covered by this
>> change, because the freezing of filesystems prevents s2disk from
>> accessing device special files it needs to do its job.
>>
>> This change is based on earlier work by Nigel Cunningham.
>>
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> Do you happen to have a version of this patch that has been rebased to the
> latest 3.3 git tree?  I looked in the various archives and haven't found one
> yet.  I'd like to get this into Fedora rawhide to see if some of the hibernate
> issues we've been seeing clear up.

I got impatient and decided to tackle this myself.  If others would like to
look at the forward port below, I'd appreciate it.

josh

commit b94887bbc0621e1e8402e7f0ec4bc3adf46c9a6e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Feb 17 12:42:08 2012 -0500

    Freeze all filesystems during system suspend and (kernel-driven)
    hibernation by calling freeze_supers() for all superblocks and thaw
    them during the subsequent resume with the help of thaw_supers().

    This makes filesystems stay in a consistent state in case something
    goes wrong between system suspend (or hibernation) and the subsequent
    resume (e.g. journal replays won't be necessary in those cases).  In
    particular, this should help to solve a long-standing issue that, in
    some cases, during resume from hibernation the boot loader causes the
    journal to be replied for the filesystem containing the kernel image
    and/or initrd causing it to become inconsistent with the information
    stored in the hibernation image.

    The user-space-driven hibernation (s2disk) is not covered by this
    change, because the freezing of filesystems prevents s2disk from
    accessing device special files it needs to do its job.

    This change is based on earlier work by Nigel Cunningham.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

    Rebased to 3.3-rc3 by Josh Boyer <jwboyer@redhat.com>

diff --git a/fs/super.c b/fs/super.c
index 6015c02..c8057fa 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -594,6 +594,79 @@ void iterate_supers_type(struct file_system_type *type,
 EXPORT_SYMBOL(iterate_supers_type);

 /**
+ *	thaw_supers - call thaw_super() for all superblocks
+ */
+void thaw_supers(void)
+{
+	struct super_block *sb, *p = NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (hlist_unhashed(&sb->s_instances))
+			continue;
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+
+		if (sb->s_flags & MS_FROZEN) {
+			thaw_super(sb);
+			sb->s_flags &= ~MS_FROZEN;
+		}
+
+		spin_lock(&sb_lock);
+		if (p)
+			__put_super(p);
+		p = sb;
+	}
+	if (p)
+		__put_super(p);
+	spin_unlock(&sb_lock);
+}
+
+/**
+ *	freeze_supers - call freeze_super() for all superblocks
+ */
+int freeze_supers(void)
+{
+	struct super_block *sb, *p = NULL;
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	/*
+	 * Freeze in reverse order so filesystems depending on others are
+	 * frozen in the right order (eg. loopback on ext3).
+	 */
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		if (hlist_unhashed(&sb->s_instances))
+			continue;
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+
+		if (sb->s_root && sb->s_frozen != SB_FREEZE_TRANS
+		    && !(sb->s_flags & MS_RDONLY)) {
+			error = freeze_super(sb);
+			if (!error)
+				sb->s_flags |= MS_FROZEN;
+		}
+
+		spin_lock(&sb_lock);
+		if (error)
+			break;
+		if (p)
+			__put_super(p);
+		p = sb;
+	}
+	if (p)
+		__put_super(p);
+	spin_unlock(&sb_lock);
+
+	if (error)
+		thaw_supers();
+
+	return error;
+}
+
+
+/**
  *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
  *	
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..a164f4a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -210,6 +210,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_FROZEN	(1<<25) /* Frozen filesystem */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
@@ -2501,6 +2502,8 @@ extern void drop_super(struct super_block *sb);
 extern void iterate_supers(void (*)(struct super_block *, void *), void *);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
+extern int freeze_supers(void);
+extern void thaw_supers(void);

 extern int dcache_dir_open(struct inode *, struct file *);
 extern int dcache_dir_close(struct inode *, struct file *);
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 6d6d288..492fc62 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -626,12 +626,17 @@ int hibernate(void)
 	if (error)
 		goto Finish;

-	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
+	error = freeze_supers();
 	if (error)
 		goto Thaw;
+
+	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
+	if (error)
+		goto Thaw_fs;
+
 	if (freezer_test_done) {
 		freezer_test_done = false;
-		goto Thaw;
+		goto Thaw_fs;
 	}

 	if (in_suspend) {
@@ -655,6 +660,8 @@ int hibernate(void)
 		pr_debug("PM: Image restored successfully.\n");
 	}

+ Thaw_fs:
+	thaw_supers();
  Thaw:
 	thaw_processes();
  Finish:
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 21724ee..40d6f64 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -1,3 +1,4 @@
+#include <linux/fs.h>
 #include <linux/suspend.h>
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
@@ -227,45 +228,3 @@ enum {
 #define TEST_MAX	(__TEST_AFTER_LAST - 1)

 extern int pm_test_level;
-
-#ifdef CONFIG_SUSPEND_FREEZER
-static inline int suspend_freeze_processes(void)
-{
-	int error;
-
-	error = freeze_processes();
-
-	/*
-	 * freeze_processes() automatically thaws every task if freezing
-	 * fails. So we need not do anything extra upon error.
-	 */
-	if (error)
-		goto Finish;
-
-	error = freeze_kernel_threads();
-
-	/*
-	 * freeze_kernel_threads() thaws only kernel threads upon freezing
-	 * failure. So we have to thaw the userspace tasks ourselves.
-	 */
-	if (error)
-		thaw_processes();
-
- Finish:
-	return error;
-}
-
-static inline void suspend_thaw_processes(void)
-{
-	thaw_processes();
-}
-#else
-static inline int suspend_freeze_processes(void)
-{
-	return 0;
-}
-
-static inline void suspend_thaw_processes(void)
-{
-}
-#endif
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4fd51be..5f51fc7 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -29,6 +29,62 @@

 #include "power.h"

+#ifdef CONFIG_SUSPEND_FREEZER
+
+static inline int suspend_freeze_processes(void)
+{
+	int error;
+
+	error = freeze_processes();
+
+	/*
+	 * freeze_processes() automatically thaws every task if freezing
+	 * fails. So we need not do anything extra upon error.
+	 */
+
+	if (error)
+		goto Finish;
+
+	error = freeze_supers();
+	if (error) {
+		thaw_processes();
+		goto Finish;
+	}
+
+	error = freeze_kernel_threads();
+
+	/*
+	 * freeze_kernel_threads() thaws only kernel threads upon freezing
+	 * failure. So we have to thaw the userspace tasks ourselves.
+	 */
+	if (error) {
+		thaw_supers();
+		thaw_processes();
+	}
+
+Finish:
+	return error;
+}
+
+static inline void suspend_thaw_processes(void)
+{
+	thaw_supers();
+	thaw_processes();
+}
+
+#else /* !CONFIG_SUSPEND_FREEZER */
+
+static inline int suspend_freeze_processes(void)
+{
+	return 0;
+}
+
+static inline void suspend_thaw_processes(void)
+{
+}
+
+#endif /* !CONFIG_SUSPEND_FREEZER */
+
 const char *const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
