Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462Ab2EOCf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:35:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53522 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965256Ab2EOCR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 143/179] alpha: fix several security issues
Date: Mon, 14 May 2012 22:13:59 -0400
Message-ID: <1337048075-6132-144-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 21c5977a836e399fc710ff2c5367845ed5c2527f upstream.

Fix several security issues in Alpha-specific syscalls.  Untested, but
mostly trivial.

1. Signedness issue in osf_getdomainname allows copying out-of-bounds
kernel memory to userland.

2. Signedness issue in osf_sysinfo allows copying large amounts of
kernel memory to userland.

3. Typo (?) in osf_getsysinfo bounds minimum instead of maximum copy
size, allowing copying large amounts of kernel memory to userland.

4. Usage of user pointer in osf_wait4 while under KERNEL_DS allows
privilege escalation via writing return value of sys_wait4 to kernel
memory.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/alpha/kernel/osf_sys.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index de9d397..57825bb 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -432,7 +432,7 @@ SYSCALL_DEFINE2(osf_getdomainname, char __user *, name, int, namelen)
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -619,7 +619,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, command, char __user *, buf, long, count)
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -674,7 +674,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned long, op, void __user *, buffer,
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1036,6 +1036,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1044,13 +1045,15 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 	old_fs = get_fs();
 		
 	set_fs (KERNEL_DS);
-	ret = sys_wait4(pid, ustatus, options, (struct rusage __user *) &r);
+	ret = sys_wait4(pid, (unsigned int __user *) &status, options,
+			(struct rusage __user *) &r);
 	set_fs (old_fs);
 
 	if (!access_ok(VERIFY_WRITE, ur, sizeof(*ur)))
 		return -EFAULT;
 
 	err = 0;
+	err |= put_user(status, ustatus);
 	err |= __put_user(r.ru_utime.tv_sec, &ur->ru_utime.tv_sec);
 	err |= __put_user(r.ru_utime.tv_usec, &ur->ru_utime.tv_usec);
 	err |= __put_user(r.ru_stime.tv_sec, &ur->ru_stime.tv_sec);
-- 
1.7.9.6

