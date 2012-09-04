Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2IDKZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:25:18 -0400
Received: from mail.nudt.edu.cn ([61.187.54.11]:6659 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752309Ab2IDKYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:24:42 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 06:24:42 EDT
X-Eyou-Smtpauth: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC] VFS: File System Mount Wide O_DIRECT Support
Date: Tue, 4 Sep 2012 18:17:47 +0800
Message-ID: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac2KhoIuhqomfX8SQ+2gZF5aDKhfDw==
Content-Language: zh-cn
x-cr-hashedpuzzle: Guml GxmN H6ls KO5D LRyZ OODh UEH0 VJ3k Ws4h ZTMJ Zxlq eptj mlY6 nCKg qAjI qSvt;4;YQB4AGIAbwBlAEAAawBlAHIAbgBlAGwALgBkAGsAOwBsAGkAbgB1AHgALQBmAHMAZABlAHYAZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAdgBpAHIAbwBAAHoAZQBuAGkAdgAuAGwAaQBuAHUAeAAuAG8AcgBnAC4AdQBrAA==;Sosha1_v1;7;{336C4F24-9409-4EB8-8C48-F10F3E9A61CA};bABpAHcAYQBuAGcAQABuAHUAZAB0AC4AZQBkAHUALgBjAG4A;Tue, 04 Sep 2012 10:17:37 GMT;WwBSAEYAQwBdACAAVgBGAFMAOgAgAEYAaQBsAGUAIABTAHkAcwB0AGUAbQAgAE0AbwB1AG4AdAAgAFcAaQBkAGUAIABPAF8ARABJAFIARQBDAFQAIABTAHUAcABwAG8AcgB0AA==
x-cr-puzzleid: {336C4F24-9409-4EB8-8C48-F10F3E9A61CA}
X-Eyou-Sender: <liwang@nudt.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For file system created on file-backed loop device, there will be two-levels of 
page cache present, which typically doubles the memory consumption. 
In many cases, it is beneficial to turn on the O_DIRECT option while performing 
the upper file system file IO, to bypass the upper page cache, which not only reduces half
of the memory consumption, but also improves the performance due to shorter copy path.

For example, the following iozone REREAD test with O_DIRECT turned on over the one without
enjoys 10x speedup due to redundant cache elimination, consequently, avoiding page cache thrashing
on a 2GB memory machine running 3.2.9 kernel.

losetup /dev/loop0 dummy // dummy is a ext4 file with a size of 1.1GB
mkfs -t ext2 /dev/loop0
mount /dev/loop0 /dsk
cd /dsk
iozone -t 1 -s 1G -r 4M -i 0 -+n -w // produce a 1GB test file
iozone -t 1 -s 1G -r 4M -i 1 -w // REREAD test without O_DIRECT
echo 1 > /proc/sys/vm/drop_caches // cleanup the page cache
iozone -t 1 -s 1G -r 4M -i 1 -w -I // REREAD test with O_DIRECT

This feature is also expected to be useful for virtualization situation, the file systems inside 
the guest operation system will use much less of guest memory, which, potencially results in less of 
host memory use. Especially, it may be more useful if multiple guests are running based 
on a same disk image file.  

The idea is simple, leave the desicion for the file system user to enable file system mount 
wide O_DIRECT support with a new mount option, for example,

losetup /dev/loop0 dummy
mount /dev/loop0 -o MS_DIRECT /dsk

Below is the preliminary patch,

---
 fs/open.c          |    5 +++++
 fs/super.c         |    2 ++
 include/linux/fs.h |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index e1f2cdb..dacac30 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -958,6 +958,11 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 			} else {
 				fsnotify_open(f);
 				fd_install(fd, f);
+				if (f->f_vfsmnt->mnt_sb && f->f_vfsmnt->mnt_sb->s_flags & MS_DIRECT) {
+					if (S_ISREG(f->f_dentry->d_inode->i_mode)) {
+	if (!f->f_mapping->a_ops || ((!f->f_mapping->a_ops->direct_IO) && (!f->f_mapping->a_ops->get_xip_mem)))
+		f->f_flags |= O_DIRECT;
+				}
 			}
 		}
 		putname(tmp);
diff --git a/fs/super.c b/fs/super.c
index 0902cfa..ab5c4a5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1147,6 +1147,8 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	WARN_ON(!sb->s_bdi);
 	WARN_ON(sb->s_bdi == &default_backing_dev_info);
 	sb->s_flags |= MS_BORN;
+	if (flags & MS_DIRECT)
+		sb->s_flags |= MS_DIRECT;
 
 	error = security_sb_kern_mount(sb, flags, secdata);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..127cc85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -225,6 +225,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_DIRECT	(1<<27)
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
1.7.6.5

