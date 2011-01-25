Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1AYOLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:11:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1AYOLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:11:47 -0500
Date: Tue, 25 Jan 2011 15:09:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
Message-ID: <20110125140948.GA26762@elte.hu>
References: <20110125134748.GA10051@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125134748.GA10051@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> Hi,
> 
> I've faced some very early panics in latest kernel. Being a run of the mill
> x86 laptop, the machine is void of debugging aids like serial ports or
> network boot.
> 
> As a possible solution, below patches prototypes the idea of persistently
> storing the kernel log ring to a hard disk partition using the enhanced BIOS
> 0x13 services.
> 
> The used BIOS INT 0x13 functions are the same ones originally used by all
> contemporary bootloaders to load the Linux kernel. If the kernel code is
> already loaded to RAM and being executed, such parts of the BIOS should be
> stable enough.
> 
> The basic idea is to switch from 64-bit long mode all the way down to 16-bit
> real-mode. Once in real-mode, we reset the disk controller and write the log
> buffer to disk using a user-supplied absolute disk block address (LBA).
> 
> Doing so, we can capture very early panics (along with earlier log messages)
> reliably since the writing mechanism has minimal dependency on any Linux code.
> 
> Unfortunately, there are problems on some machines.
> 
> In my laptop, when calling the BIOS with the "Reset Disk Controllers" command
> or even issuing a direct "Extend Write" without a controller reset, the BIOS
> hangs for around __5 minutes__. Afterwards, it returns with a 'Timeout' error
> code.
> 
> The main problem, it seems, is that the BIOS "Reset controller" command is not
> enough to restore disk hardware to a state understandable by the BIOS code.
> 
> So:
> 
>  - Is it possible to re-initialize the disk hardware to its POST state (thus
>    make the BIOS services work reliably) while keeping system RAM unmodified?
>  - If not, can we do it manually by reprogramming the controllers?
> 
> The first patch (#1) implements the longMode -> realMode switch and invokes
> the BIOS. The second reserves needed low-memory areas for such code and
> registers a panic logger using the kmsg_dump interface.
> 
> Both patches are on '-next' and include XXX marks where further help is also
> appreciated. Please remember that these patches, while tested, are now for
> prototyping the technical feasibility of the idea.
> 
> Diffstat:
> 
>  arch/x86/kernel/saveoops-rmode.S |  483 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/saveoops.h  |   15 ++
>  arch/x86/kernel/saveoops.c       |  219 +++++++++++++++++
>  arch/x86/kernel/setup.c          |    9 +
>  arch/x86/kernel/Makefile         |    3 +
>  lib/Kconfig.debug                |   15 ++
>  6 files changed, 744 insertions(+), 0 deletions(-)

Ok, i have to admit that while i'm a rabid BIOS-hater i find this debug feature very 
very interesting, for the plain reason that if it's implemented in a robust and 
clever way then this has a chance to improve debuggability of pretty much any Linux 
laptop quite enormously!

While we generally thoroughly hate BIOSes from beginning to end, one thing can be 
said, a BIOS bootstraps very early during bootup, and it's relatively simple to 
trigger as well.

Also, since latest kernels do not stomp on BIOS data structures anymore (low RAM), 
there's some good chance it's still functional at the point of crash - be that an 
early crash or a later crash.

I think the biggest areas of practical concern would be:

 - Can this mechanism ever, under any circumstance corrupt any real data, destroy 
   the MBR or do other nasties. Can you think of any additional fail-safe measures 
   where you could _further robustify the BIOS calls_ to make sure it can never go 
   to the wrong sector(s)? I really do not want to think of trusting a BIOS to 
   _write to my disk_.

 - Is there some hidden disk area somewhere on PCs, or somewhere on a real partition
   on typical Linux distributions, which we could use without having to reinstall
   the box? This would increase utility and availability enormously. I'm thinking of 
   partition _ends_ which sometimes get rounded in an awkward way and which are 
   potentially skipped by most Linux filesystems. Even a very small, 512 bytes of 
   area would be extremely useful for debugging weird suspend hangs ...

 - Could we automate the recovery of the dump, and just put it into the regular 
   kernel log on the next (successful) bootup (on a feature-enabled kernel)? That 
   would make the log of the 'previous crash' very conveniently available in dmesg 
   and the syslog. Tools like kerneloops could make use of it immediately.

All in one, a very intriguing idea IMO, and the hardest bits (lowlevel x86 
transition) is all implemented already.

Thanks,

	Ingo
