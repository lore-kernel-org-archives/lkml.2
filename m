Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab2LUGYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:24:31 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:43526 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2LUGYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:24:24 -0500
Message-ID: <50D40088.3030304@synopsys.com>
Date: Fri, 21 Dec 2012 11:54:08 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: CONFIG_GENERIC_SIGALTSTACK with asm-generic/syscalls.h (was Re: [git
 pull] signal.git pile 2)
References: <20121221002100.GM4939@ZenIV.linux.org.uk>
In-Reply-To: <20121221002100.GM4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2012 05:51 AM, Al Viro wrote:
> sigaltstack infrastructure + conversion for x86, alpha and um,
> COMPAT_SYSCALL_DEFINE infrastructure.  Note that there are several
> conflicts between "unify SS_ONSTACK/SS_DISABLE definitions" and
> UAPI patches in mainline; resolution is trivial - just remove definitions
> of SS_ONSTACK and SS_DISABLED from arch/*/uapi/asm/signal.h; they are
> all identical and include/uapi/linux/signal.h contains the unified
> variant.  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
> 

Hi Arnd,

In Linus' tree with above merged, selecting CONFIG_GENERIC_SIGALTSTACK
is causing build issues for ARC port (and possibly others as well) which
use asm-generic/syscalls.h due to a different prototype for
sys_sigaltstack coming in from linux/syscalls.h

While I can band-aid ARC port by #define sys_sigaltstack before
including asm-generic, it might be better if we conditional-ize one of
the prototypes. Following works for me.

diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
index 58f466f..1db51b8 100644
--- a/include/asm-generic/syscalls.h
+++ b/include/asm-generic/syscalls.h
@@ -21,10 +21,12 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
                        unsigned long fd, off_t pgoff);
 #endif

+#ifndef CONFIG_GENERIC_SIGALTSTACK
 #ifndef sys_sigaltstack
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
                        struct pt_regs *);
 #endif
+#endif

 #ifndef sys_rt_sigreturn
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);


Thx,
-Vineet
