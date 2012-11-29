Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2K2Vb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:31:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38129 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab2K2Vb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:31:56 -0500
Date: Thu, 29 Nov 2012 22:31:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121129213151.GI30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
 <20121128204158.GC14635@liondog.tnic>
 <50B6A8F3.5000407@zytor.com>
 <20121129091317.GA21084@liondog.tnic>
 <50B7CE4C.80201@linux.intel.com>
 <20121129211856.GH30789@liondog.tnic>
 <50B7D180.9090605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50B7D180.9090605@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:20:00PM -0800, H. Peter Anvin wrote:
> On 11/29/2012 01:18 PM, Borislav Petkov wrote:
> > On Thu, Nov 29, 2012 at 01:06:20PM -0800, H. Peter Anvin wrote:
> >> It doesn't matter in that context, as the surrounding MSR references
> >> have barriers, but what I'm refering to is the "memory" barrier.
> > 
> > Ok, but the only difference between the two versions is this line:
> > 
> >         movl    %esi, %ecx      # tmp144, ecx
> > 
> > coming from the cpuid_eax() function. So the memory barrier is the same
> > and in the right place in both cases.
> > 
> 
> In the case of that one call site, yes, because the MSR references
> include the barrier.  Other sites, current or future, may not have the
> same property.

Sorry, but I think we're misunderstanding each other in some way, so let
me restart. Here's the version I'm suggesting:

static inline void sync_core(void)
{
	int tmp;

#ifdef CONFIG_M486
	/*
	 * Do a CPUID if available, otherwise do a jump.  The jump
	 * can conveniently enough be the jump around CPUID.
	 */
	asm volatile("cmpl %2,%1\n\t"
		     "jl 1f\n\t"
		     "cpuid\n"
		     "1:"
		     : "=a" (tmp)
		     : "rm" (boot_cpu_data.cpuid_level), "ri" (0), "0" (1)
		     : "ebx", "ecx", "edx", "memory");
#else
	/*
	 * CPUID is a barrier to speculative execution. Prefetched instructions
	 * are automatically invalidated when modified.
	 */
	tmp = cpuid_eax(1);

	/*
	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
		     : "ebx", "ecx", "edx", "memory");
	*/
#endif
}

with the last asm volatile("cpuid"...) commented out. The only
non-trivial difference between the two is the zeroing out of %ecx when
looking at the resulting asm.

Now, cpuid_eax is actually native_cpuid() which has the memory barrier
character by having an "asm volatile" in there too and it too clobbers
memory.

Are you saying that there's a semantic difference between the naked
"asm volatile" and the compiler inlining a couple of inline functions
resulting in the same "asm volatile" memory barrier for it?

Hmm, strange.

-- 
Regards/Gruss,
    Boris.
