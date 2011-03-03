Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1CCHcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:32:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58686 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCHcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:32:20 -0500
From: Ken Sumrall <ksumrall@android.com>
To: linux-kernel@vger.kernel.org
Cc: Ken Sumrall <ksumrall@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] Syscalls: reboot: Add options to the reboot syscall to remount filesystems ro
Date: Wed,  2 Mar 2011 23:31:22 -0800
Message-Id: <1299137483-10975-1-git-send-email-ksumrall@android.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 4 new commands to the reboot system call, that do the same thing as the
RESTART, HALT, POWER_OFF, and RESTART2 commands, but also remount writable
filesystems as read-only just before doing what the command normally does.
Now that Android is using EXT4, and since we don't have a standard init
setup to unmount filesystems before rebooting, this allows the system to
reboot with clean filesystems, and also improves boot time as the journal
does not need to be replayed when mounting the filesystem.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
---
 fs/super.c             |    9 +++++++++
 include/linux/fs.h     |    1 +
 include/linux/reboot.h |    4 ++++
 kernel/sys.c           |   12 ++++++++++++
 4 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 8819e3a..3f39a16 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -638,6 +638,15 @@ void emergency_remount(void)
 	}
 }
 
+void emergency_remount_synchronous(void)
+{
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work)
+		do_emergency_remount(work);
+}
+
 /*
  * Unnamed block devices are dummy devices used by virtual
  * filesystems which don't use real block-devices.  -- jrs
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..e48ef0d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2110,6 +2110,7 @@ extern int generic_write_sync(struct file *file, loff_t pos, loff_t count);
 extern void sync_supers(void);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
+extern void emergency_remount_synchronous(void);
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 3005d5a..24b185d 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -26,11 +26,15 @@
  */
 
 #define	LINUX_REBOOT_CMD_RESTART	0x01234567
+#define	LINUX_REBOOT_CMD_RMNT_RESTART	0x12345670
 #define	LINUX_REBOOT_CMD_HALT		0xCDEF0123
+#define	LINUX_REBOOT_CMD_RMNT_HALT	0xDEF0123C
 #define	LINUX_REBOOT_CMD_CAD_ON		0x89ABCDEF
 #define	LINUX_REBOOT_CMD_CAD_OFF	0x00000000
 #define	LINUX_REBOOT_CMD_POWER_OFF	0x4321FEDC
+#define	LINUX_REBOOT_CMD_RMNT_POWER_OFF	0x321FEDC4
 #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
+#define	LINUX_REBOOT_CMD_RMNT_RESTART2	0x1B2C3D4A
 #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
 #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f5a0cd..3f474e6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -392,6 +392,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	mutex_lock(&reboot_mutex);
 	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART:
+	case LINUX_REBOOT_CMD_RMNT_RESTART:
+		if (cmd == LINUX_REBOOT_CMD_RMNT_RESTART)
+			emergency_remount_synchronous();
 		kernel_restart(NULL);
 		break;
 
@@ -404,22 +407,31 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		break;
 
 	case LINUX_REBOOT_CMD_HALT:
+	case LINUX_REBOOT_CMD_RMNT_HALT:
+		if (cmd == LINUX_REBOOT_CMD_RMNT_HALT)
+			emergency_remount_synchronous();
 		kernel_halt();
 		do_exit(0);
 		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
+	case LINUX_REBOOT_CMD_RMNT_POWER_OFF:
+		if (cmd == LINUX_REBOOT_CMD_RMNT_POWER_OFF)
+			emergency_remount_synchronous();
 		kernel_power_off();
 		do_exit(0);
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
+	case LINUX_REBOOT_CMD_RMNT_RESTART2:
 		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
 			ret = -EFAULT;
 			break;
 		}
 		buffer[sizeof(buffer) - 1] = '\0';
 
+		if (cmd == LINUX_REBOOT_CMD_RMNT_RESTART2)
+			emergency_remount_synchronous();
 		kernel_restart(buffer);
 		break;
 
-- 
1.7.3.1

