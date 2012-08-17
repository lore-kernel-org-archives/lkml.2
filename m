Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758Ab2HQDbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:31:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46809 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030668Ab2HQD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:03 -0400
Message-Id: <20120817030249.272923423@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 34/37] s390/compat: fix mmap compat system calls
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit e85871218513c54f7dfdb6009043cb638f2fecbe upstream.

The native 31 bit and the compat behaviour for the mmap system calls differ:

In native 31 bit mode the passed in address for the mmap system call will be
unmodified passed to sys_mmap_pgoff().
In compat mode however the passed in address will be modified with
compat_ptr() which masks out the most significant bit.

The result is that in native 31 bit mode each mmap request (with MAP_FIXED)
will fail where the most significat bit is set, while in compat mode it
may succeed.

This odd behaviour was introduced with d3815898 "[S390] mmap: add missing
compat_ptr conversion to both mmap compat syscalls".

To restore a consistent behaviour accross native and compat mode this
patch functionally reverts the above mentioned commit.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/compat_linux.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index d122508..f606d93 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -620,7 +620,6 @@ asmlinkage unsigned long old32_mmap(struct mmap_arg_struct_emu31 __user *arg)
 		return -EFAULT;
 	if (a.offset & ~PAGE_MASK)
 		return -EINVAL;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
 			      a.offset >> PAGE_SHIFT);
 }
@@ -631,7 +630,6 @@ asmlinkage long sys32_mmap2(struct mmap_arg_struct_emu31 __user *arg)
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 }
 


