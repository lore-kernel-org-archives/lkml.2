Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab1CXIlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:41:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710Ab1CXIk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:40:59 -0400
Date: Thu, 24 Mar 2011 09:39:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110324083959.GE30812@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103240414450.4529@x980>
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


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Microsoft was able to delete APM from Windows in 2006
> with the release of Windows Vista. [...]

Does Windows XP still support it?

> [...]  5 years later it seems quite safe that the latest Linux kernel can 
> also.
> 
> The vintage APM laptops have become difficult to find,
> making changes in this area difficult to test.
> 
> apm_bios.h remains for CONFIG_APM_EMULATION
> used by non-x86 architectures.

Dunno. This bit:

> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -618,12 +618,3 @@ Why:	The original implementation of memsw feature enabled by
>  	can also cleanup the parameter handling a bit ().
>  Who:	Michal Hocko <mhocko@suse.cz>
>  
> -----------------------------
> -
> -What:	CONFIG_APM
> -When:	2.6.40
> -Why:	Microsoft deleted APM from Windows as of Vista in in 2006.
> -	It now seems more than safe that the latest Linux Kernel be APM-free.
> -	The vintage laptops supporting APM are now difficult to find,
> -	making it problatic to maintain this code.
> -Who:	Len Brown <len.brown@intel.com>

Is weird as there's no such CONFIG_APM entry upstream, and never was. Which 
tree is this entry included in?

While i'm not a fan of APM at all, this removal is a tad fast IMHO.

Beyond the lack of a upstream-visible feature-removal-schedule entry, we still 
have an Arcnet driver which hardware was obsoleted by Ethernet in the late 80s, 
and we still have i486 support and those are *much* older than APM.

If you look at the diffstat:

>  Documentation/feature-removal-schedule.txt |    9 -
>  MAINTAINERS                                |    8 -
>  arch/x86/Kconfig                           |  125 --
>  arch/x86/boot/Makefile                     |    1 -
>  arch/x86/boot/apm.c                        |   75 -
>  arch/x86/boot/main.c                       |    5 -
>  arch/x86/include/asm/bootparam.h           |    3 +-
>  arch/x86/kernel/Makefile                   |    2 -
>  arch/x86/kernel/apm_32.c                   | 2463 ----------------------------
>  arch/x86/kernel/process.c                  |    3 -
>  arch/x86/kernel/reboot.c                   |    3 -
>  arch/x86/kernel/setup.c                    |    4 -
>  12 files changed, 1 insertions(+), 2700 deletions(-)

You see that the kernel implementation is nicely modularized and its 
cross-section to the rest of arch/x86/ is minimal. To arch/x86/ it's little 
more than an obscure driver.

Thus from a maintenance POV APM has not been much of a drag on the x86 
maintainer side. Sure, we do not test it, but that's the case with most of the 
obsolete drivers in the kernel.

The principle is that as long as there's no ongoing drag, the cost of carrying 
obsolete drivers is minimal - and the unknown cost of screwing someone in a big 
way by removing hardware support is hard to measure reliably. So we are 
cautious and err on the side of supporting too much hardware.

Removal could be prepared by:

 - moving CONFIG_APM to under CONFIG_EXPERT though, and keep it there for a few 
   releases, and see whether anyone complains

 - we could emit a WARN() with a "APM support will be obsoleted, please report 
   this if you depend on this feature" text or so, and see what happens for a 
   couple of releases.

Thanks,

	Ingo
