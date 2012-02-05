Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2BEW0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:50 -0500
Received: from 1wt.eu ([62.212.114.60]:62012 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2BEW0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:43 -0500
Message-Id: <20120205220951.033873980@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 37/91] alpha: fix several security issues
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 7 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/arch/alpha/kernel/osf_sys.c
===================================================================
--- longterm-2.6.27.orig/arch/alpha/kernel/osf_sys.c	2012-02-05 22:34:33.893915202 +0100
+++ longterm-2.6.27/arch/alpha/kernel/osf_sys.c	2012-02-05 22:34:40.104915063 +0100
@@ -451,7 +451,7 @@
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -639,7 +639,7 @@
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -695,7 +695,7 @@
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1061,6 +1061,7 @@
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1069,13 +1070,15 @@
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


