Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2EFRyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:54:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2EFRyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:54:53 -0400
Date: Sun, 6 May 2012 18:54:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120506175451.GU6871@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
 <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 10:16:11AM -0700, Linus Torvalds wrote:
> On Sun, May 6, 2012 at 9:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Setting TIF_IA32 in load_aout_binary() used to be enough; these days
> > TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
> > there. ?Switch to use of set_personality_ia32()...
> 
> Applied. Just out of curiosity, how did you notice? Just looking at
> TIF_IA32 usage, or do you actually have some old app?

Putting together an idiot's guide to thread flags ;-)  Other very similar
bug, AFAICS, is in mips elf.h:
#define __SET_PERSONALITY32_N32()                                       \
        do {                                                            \
                set_thread_flag(TIF_32BIT_ADDR);                        \
                current->thread.abi = &mips_abi_n32;                    \
        } while (0)
probably should clear_thread_flag(TIF_32BIT_REGS); as well.  Ralf?

Another catch on mips, and that one is downright funny:
#ifdef CONFIG_MIPS32_O32
#define TIF_32BIT TIF_32BIT_REGS
#elif defined(CONFIG_MIPS32_N32)
#define TIF_32BIT _TIF_32BIT_ADDR
#endif /* CONFIG_MIPS32_O32 */

Spot the breakage.  Note that TIF_32BIT is used only in is_compat_task()
there, so that went unnoticed for a long time.  BTW, I really wonder if
the logics here is correct, nevermind the obvious typo...  For kernels
with O32, but not N32 support we could bloody well use TIF_32BIT_ADDR -
O32 sets both flags.  And for kernels that support both (O32 and N32 are
not mutually exclusive), we probably want both of o32 and n32 processes
match is_compat_task().

Note that we have different semantics for is_compat_task() on x86 and
everywhere (AFAICS) else: "is this a 32bit syscall" vs. "is this a biarch
syscall with 32bit pointers, etc.".  On architectures where 32bit syscall
can't be issued by 64bit task and vice versa there's no difference, but for
e.g. sparc there definitely is one.  is_compat_task() there goes by what
the task is, not what kind of syscall is it trying to make.  It mostly
doesn't matter (is_compat_task() has very few users), but I suspect that
for e.g. ext4 is_32bit_api() it does matter and is currently broken...

What kind of semantics do we want?  "Thread property" one, set when we
set personality on execve(), or "syscall property", like e.g. x86 TIF_IRET
and TS_COMPAT?
