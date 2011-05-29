Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1E2TTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:19:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1E2TTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:19:40 -0400
Date: Sun, 29 May 2011 21:19:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed
 addresses
Message-ID: <20110529191924.GD9835@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> I lied about taking awhile to do this.

Heh :-)

A very nice series btw!

> There are a bunch of syscall instructions in kernel space at fixed
> addresses that user code can execute.
> 
> One is a time() fallback.  Patch 3/5 removes it.
> 
> Several are data that isn't marked NX.  Patch 2/5 makes vvars NX and
> 5/5 makes the HPET NX.
> 
> The last one is the gettimeofday fallback.  We need that, but it
> doesn't have to be a real syscall.  Patch 3/5 adds int 0xCC (callable
> only from the vsyscall page) that implements the gettimeofday fallback
> and nothing else.
> 
> Patch 1/5 is just a dumb but harmless bug fix from the last vdso
> series.
> 
> I've only tested this in KVM with a hacked-up initramfs, but Ingo
> wanted it for 2.6.40, so here it is.
> 
> Andy Lutomirski (5):
>   x86-64: Fix alignment of jiffies variable
>   x86-64: Give vvars their own page
>   x86-64: Remove kernel.vsyscall64 sysctl
>   x86-64: Replace vsyscall gettimeofday fallback with int 0xcc
>   x86-64: Map the HPET NX
> 
>  arch/x86/include/asm/fixmap.h        |    1 +
>  arch/x86/include/asm/pgtable_types.h |    6 ++-
>  arch/x86/include/asm/traps.h         |    4 ++
>  arch/x86/include/asm/vgtod.h         |    1 -
>  arch/x86/include/asm/vsyscall.h      |    6 ++
>  arch/x86/include/asm/vvar.h          |   24 ++++-----
>  arch/x86/kernel/entry_64.S           |    2 +
>  arch/x86/kernel/hpet.c               |    2 +-
>  arch/x86/kernel/traps.c              |    4 ++
>  arch/x86/kernel/vmlinux.lds.S        |   27 ++++++----
>  arch/x86/kernel/vsyscall_64.c        |   86 ++++++++++++++++++---------------
>  arch/x86/vdso/vclock_gettime.c       |   55 ++++++++-------------
>  tools/power/x86/turbostat/turbostat  |  Bin 0 -> 29200 bytes
>  13 files changed, 117 insertions(+), 101 deletions(-)
>  create mode 100755 tools/power/x86/turbostat/turbostat

If no-one finds any review problems with these patches and if you fix 
the details i pointed out for 3/5 then we can do this for v2.6.40.

I really like this series, it makes full-PIE randomized user-space 
executables fully safe against known-address syscall instructions. As 
much as i like crazy speedups, they are probably more relevant to the 
everyday Linux user than the other patches ;-)

Btw., do you know CONFIG_X86_PTDUMP=y and /debug/kernel_page_tables? 
You could use that to double check that after your patches all 
executable (and fixed address) pages are removed [or are harmless].

Thanks,

	Ingo
