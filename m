Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2IXQWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2IXQWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:22:12 -0400
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
From: Mark Salter <msalter@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 24 Sep 2012 12:21:46 -0400
In-Reply-To: <20120922114723.d7f07fb6.akpm@linux-foundation.org>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
	 <20120922114549.GA11610@moon>
	 <20120922132046.GA4260@flint.arm.linux.org.uk>
	 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1348503709.20929.40.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-22 at 11:47 -0700, Andrew Morton wrote:
> > 2. There allegedly exists a patch to remove x86isms from sys_kcmp -
> >    allegedly also in akpm's tree.  However, I've looked through the code in
> >    mainline, and nothing stands out.  Ralf Beachle also said yesterday that
> >    he has looked through from the MIPS PoV and also can't see any x86isms,
> >    so we're both thinking that it should merely have the x86 dependency
> >    removed.
> 
> http://ozlabs.org/~akpm/mmotm/broken-out/syscalls-make-kcmp-syscall-available-for-all-architectures.patch

The following is needed to get rid of the syscall warning on architectures
using the generic syscall list:

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 991ef01..3748ec9 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -691,9 +691,11 @@ __SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
 #define __NR_process_vm_writev 271
 __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
           compat_sys_process_vm_writev)
+#define __NR_kcmp 272
+__SYSCALL(__NR_kcmp, sys_kcmp)
 
 #undef __NR_syscalls
-#define __NR_syscalls 272
+#define __NR_syscalls 273

> 
> I have that queued for 3.7.  There is of course a little risk here.  We
> do have a test in tools/testing/selftests/kcmp/ - I suggest that arch
> people run it!  In fact all the tools/testing/selftests should execute
> successfully on all architectures - if not, please let's fix things
> up.

I ran into a build error on C6X (no-MMU) when I enabled CHECKPOINT_RESTORE:

  linux-next/kernel/sys.c: In function 'prctl_set_mm':
  linux-next/kernel/sys.c:1869:34: error: 'mmap_min_addr' undeclared (first use in this function)

I got past that with:

diff --git a/include/linux/security.h b/include/linux/security.h
index 01ef030..14e394d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -118,6 +118,7 @@ void reset_security_ops(void);
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
 #else
+#define mmap_min_addr          0UL
 #define dac_mmap_min_addr      0UL
 #endif

Looking at kcmp_test.c, it uses fork, so won't work without MMU. Is
the kcmp syscall even meaningful for no-MMU? I suppose some of the
tests in kcmp_test.c could be accomplished using clone directly
rather than fork.

--Mark


