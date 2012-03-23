Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2CWRLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:11:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35572 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab2CWRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:11:03 -0400
Date: Fri, 23 Mar 2012 21:10:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] proc: fix mount -t proc -o AAA
Message-ID: <20120323171058.GA3279@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203220903.15360.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arkadiusz,

On Thu, Mar 22, 2012 at 09:03 +0100, Arkadiusz Miśkiewicz wrote:
> Hi,
> 
> I'm trying to use hidepid feature in 3.3 kernel but I'm getting weird
> things like options not being applied _sometimes_ at mount.
> 
> [@ ~]# cat /proc/mounts
> sh: cat: /proc/mounts: No such file or directory
> [@ ~]# strace -e mount -f -F -s 200 mount none /proc -t proc -o hidepid=2,gid=17                            
> mount("none", "/proc", "proc", MS_MGC_VAL, "hidepid=2,gid=17") = 0
> [@ ~]# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
> run /run tmpfs rw,relatime 0 0
> none /proc proc rw,relatime 0 0
> 
> No hidepid, no gid - huh?
> 
> [@ ~]# mount /proc -o remount,hidepid=2,gid=17
> [@ ~]# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
> run /run tmpfs rw,relatime 0 0
> none /proc proc rw,relatime,gid=17,hidepid=2 0 0
> 
> remount and hidepid/gid is there
> 
> [@ ~]# umount /proc
> [@ ~]# strace -e mount -f -F -s 200 mount none /proc -t proc -o hidepid=2,gid=17                            
> mount("none", "/proc", "proc", MS_MGC_VAL, "hidepid=2,gid=17") = 0
> [@ ~]# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
> run /run tmpfs rw,relatime 0 0
> none /proc proc rw,relatime,gid=17,hidepid=2 0 0
> 
> and now I'm lost - every new umount & mount gets hidepid/gid right.
> 
> Any ideas why initial mount fails to get hidepid/gid options applied?
> The syscall seems correct.

Thanks for the report.  Please test the following patch.

--------------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Fri, 23 Mar 2012 20:56:42 +0400
Subject: [PATCH] proc: fix mount -t proc -o AAA

proc_parse_options() inside of proc_mount() runs only once at the boot
time without any given options.  So, following umount(2)+mount(2) ignore
mount options: proc_parse_options() is not called as ->s_root is already
initialized.  To fix that parse mount options unconditionally.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com>
---
 fs/proc/root.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 46a15d8..eed44bf 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
+	if (!proc_parse_options(options, ns)) {
+		deactivate_locked_super(sb);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!sb->s_root) {
 		sb->s_flags = flags;
-		if (!proc_parse_options(options, ns)) {
-			deactivate_locked_super(sb);
-			return ERR_PTR(-EINVAL);
-		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
-- 
1.7.0.4

