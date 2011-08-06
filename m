Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab1HFAPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:15:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab1HFAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:16 2011
Message-Id: <20110806000416.141146244@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [45/50] alpha: fix several security issues
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/osf_sys.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -431,7 +431,7 @@ SYSCALL_DEFINE2(osf_getdomainname, char
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -618,7 +618,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, comman
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -673,7 +673,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1035,6 +1035,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, i
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1043,13 +1044,15 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, i
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


