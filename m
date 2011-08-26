Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1HZIe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:34:26 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:52639 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1HZIeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:34:23 -0400
Date: Fri, 26 Aug 2011 10:34:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.1-rc3
Message-ID: <20110826103414.587bc157@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (2):
      [S390] nss,initrd: kernel image and initrd must be in different segments
      [S390] memory hotplug: only unassign assigned increments

Julia Lawall (2):
      [S390] drivers/s390/block/dasd_ioctl.c: add missing kfree
      [S390] arch/s390/kernel/ipl.c: correct error detection check

Michael Holzheu (1):
      [S390] Change default action from reipl to stop for on_restart

 arch/s390/kernel/early.c        |   14 ++++++++------
 arch/s390/kernel/ipl.c          |    7 ++++---
 drivers/s390/block/dasd_ioctl.c |   10 +++++++---
 drivers/s390/char/sclp_cmd.c    |    6 ++++--
 4 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 068f846..f297456 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -396,17 +396,19 @@ static __init void detect_machine_facilities(void)
 static __init void rescue_initrd(void)
 {
 #ifdef CONFIG_BLK_DEV_INITRD
+	unsigned long min_initrd_addr = (unsigned long) _end + (4UL << 20);
 	/*
-	 * Move the initrd right behind the bss section in case it starts
-	 * within the bss section. So we don't overwrite it when the bss
-	 * section gets cleared.
+	 * Just like in case of IPL from VM reader we make sure there is a
+	 * gap of 4MB between end of kernel and start of initrd.
+	 * That way we can also be sure that saving an NSS will succeed,
+	 * which however only requires different segments.
 	 */
 	if (!INITRD_START || !INITRD_SIZE)
 		return;
-	if (INITRD_START >= (unsigned long) __bss_stop)
+	if (INITRD_START >= min_initrd_addr)
 		return;
-	memmove(__bss_stop, (void *) INITRD_START, INITRD_SIZE);
-	INITRD_START = (unsigned long) __bss_stop;
+	memmove((void *) min_initrd_addr, (void *) INITRD_START, INITRD_SIZE);
+	INITRD_START = min_initrd_addr;
 #endif
 }
 
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 04361d5..48c7102 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1220,7 +1220,7 @@ static int __init reipl_fcp_init(void)
 	/* sysfs: create fcp kset for mixing attr group and bin attrs */
 	reipl_fcp_kset = kset_create_and_add(IPL_FCP_STR, NULL,
 					     &reipl_kset->kobj);
-	if (!reipl_kset) {
+	if (!reipl_fcp_kset) {
 		free_page((unsigned long) reipl_block_fcp);
 		return -ENOMEM;
 	}
@@ -1618,7 +1618,8 @@ static struct shutdown_action vmcmd_action = {SHUTDOWN_ACTION_VMCMD_STR,
 
 static void stop_run(struct shutdown_trigger *trigger)
 {
-	if (strcmp(trigger->name, ON_PANIC_STR) == 0)
+	if (strcmp(trigger->name, ON_PANIC_STR) == 0 ||
+	    strcmp(trigger->name, ON_RESTART_STR) == 0)
 		disabled_wait((unsigned long) __builtin_return_address(0));
 	while (sigp(smp_processor_id(), sigp_stop) == sigp_busy)
 		cpu_relax();
@@ -1717,7 +1718,7 @@ static void do_panic(void)
 /* on restart */
 
 static struct shutdown_trigger on_restart_trigger = {ON_RESTART_STR,
-	&reipl_action};
+	&stop_action};
 
 static ssize_t on_restart_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *page)
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index eb4e034..f1a2016 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -249,6 +249,7 @@ static int dasd_ioctl_reset_profile(struct dasd_block *block)
 static int dasd_ioctl_read_profile(struct dasd_block *block, void __user *argp)
 {
 	struct dasd_profile_info_t *data;
+	int rc = 0;
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -279,11 +280,14 @@ static int dasd_ioctl_read_profile(struct dasd_block *block, void __user *argp)
 		spin_unlock_bh(&block->profile.lock);
 	} else {
 		spin_unlock_bh(&block->profile.lock);
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 	if (copy_to_user(argp, data, sizeof(*data)))
-		return -EFAULT;
-	return 0;
+		rc = -EFAULT;
+out:
+	kfree(data);
+	return rc;
 }
 #else
 static int dasd_ioctl_reset_profile(struct dasd_block *block)
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index be55fb2..837e010 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -383,8 +383,10 @@ static int sclp_attach_storage(u8 id)
 	switch (sccb->header.response_code) {
 	case 0x0020:
 		set_bit(id, sclp_storage_ids);
-		for (i = 0; i < sccb->assigned; i++)
-			sclp_unassign_storage(sccb->entries[i] >> 16);
+		for (i = 0; i < sccb->assigned; i++) {
+			if (sccb->entries[i])
+				sclp_unassign_storage(sccb->entries[i] >> 16);
+		}
 		break;
 	default:
 		rc = -EIO;
