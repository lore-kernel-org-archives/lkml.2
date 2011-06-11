Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1FKSwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 14:52:20 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:55849 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1FKSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 14:52:18 -0400
Subject: [PATCH] alpha: fix several security issues
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com
Cc: security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Jun 2011 14:52:05 -0400
Message-ID: <1307818325.1906.14.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/alpha/kernel/osf_sys.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 376f221..98fb16d 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -409,7 +409,7 @@ SYSCALL_DEFINE2(osf_getdomainname, char __user *, name, int, namelen)
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -594,7 +594,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, command, char __user *, buf, long, count)
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -649,7 +649,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned long, op, void __user *, buffer,
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1008,6 +1008,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1016,13 +1017,15 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
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


