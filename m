Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab2IMPvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:51:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58744 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758336Ab2IMPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:51:31 -0400
Date: Thu, 13 Sep 2012 16:50:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 21/31] arm64: 32-bit (compat) applications support
Message-ID: <20120913155012.GC25131@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <201209071947.45313.arnd@arndb.de>
 <20120913090732.GA25131@arm.com>
 <201209131103.27387.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209131103.27387.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:03:27PM +0100, Arnd Bergmann wrote:
> On Thursday 13 September 2012, Catalin Marinas wrote:
> > +#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
> > +asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
> > +                                  compat_off_t __user *offset, s32 count)
> > +{
> > +       mm_segment_t old_fs = get_fs();
> > +       int ret;
> > +       off_t of;
> > +
> > +       if (offset && get_user(of, offset))
> > +               return -EFAULT;
> > +
> > +       set_fs(KERNEL_DS);
> > +       ret = sys_sendfile(out_fd, in_fd,
> > +                          offset ? (off_t __user *)&of : NULL, count);
> > +       set_fs(old_fs);
> > +
> > +       if (offset && put_user(of, offset))
> > +               return -EFAULT;
> > +       return ret;
> > +}
> > +#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */
> 
> Looking at this code in detail now, I think it's better to move the functions to
> fs/read_write.c and get rid of the get_fs/set_fs hack, like
> 
> asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
>                                    compat_off_t __user *offset, s32 count)
...

It makes sense (copied below, just for compat_sys_sendfile until my
comments below are clarified). One minor improvement, I think we should
use compat_size_t for the count, it is a u32 in all cases.

> This implementation is smaller and more efficient than the common one.
> 
> Same for compat_sys_sendfile64, although I don't think there is ever
> a case where loff_t is defined differently from compat_loff_t, so
> you can probably just use the native sys_sendfile64 for the compat
> case.

That's what we do on AArch64, though powerpc and sparc define their own.
The "count" argument would be different between compat and non-compat
versions and I'm not sure what assumptions are made on the syscall entry
path on these architectures (on AArch64 we ensure that the top 32-bit
part of an X register is always 0 for 32-bit syscalls).

Another difference is that the "count" argument for
compat_sys_sendfile64 is s32 on powerpc and u32 on sparc. I can't tell
whether it would make a difference in practice but if we use
compat_size_t for the generic version the powerpc wouldn't get the sign
extension.

Powerpc has some comment about a need to treat in_fd/out_fd arguments as
signed ints but I don't fully understand it (well, maybe powerpc needs
the sign to be fully extended to 64-bit even for int).

----------8<-----------------------

>From 7c6747fc9f69d20f445e4af69c644acb04a74f45 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 13 Sep 2012 09:51:10 +0100
Subject: [PATCH 1/3] Add generic compat_sys_sendfile implementation

This function is used by other architectures requiring compat support,
so just make it generic.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 fs/read_write.c        |   22 ++++++++++++++++++++++
 include/linux/compat.h |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1adfb69..91b91c4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1007,3 +1007,25 @@ SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, si
 
 	return do_sendfile(out_fd, in_fd, NULL, count, 0);
 }
+
+#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
+asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
+				   compat_off_t __user *offset, compat_size_t count)
+{
+	loff_t pos;
+	off_t off;
+	ssize_t ret;
+
+	if (offset) {
+		if (unlikely(get_user(off, offset)))
+			return -EFAULT;
+		pos = off;
+		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
+		if (unlikely(put_user(pos, offset)))
+			return -EFAULT;
+		return ret;
+	}
+
+	return do_sendfile(out_fd, in_fd, NULL, count, 0);
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c4be3f5..f386e82 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -594,6 +594,9 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
 		unsigned long liovcnt, const struct compat_iovec __user *rvec,
 		unsigned long riovcnt, unsigned long flags);
 
+asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
+				   compat_off_t __user *offset, s32 count);
+
 #else
 
 #define is_compat_task() (0)
