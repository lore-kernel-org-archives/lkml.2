Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2HTD5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2HTD5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 02/32] s390/compat: fix mmap compat system calls
Date: Sun, 19 Aug 2012 20:56:58 -0700
Message-Id: <20120820035648.191362414@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/compat_linux.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -612,7 +612,6 @@ asmlinkage unsigned long old32_mmap(stru
 		return -EFAULT;
 	if (a.offset & ~PAGE_MASK)
 		return -EINVAL;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
 			      a.offset >> PAGE_SHIFT);
 }
@@ -623,7 +622,6 @@ asmlinkage long sys32_mmap2(struct mmap_
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 }
 


