Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab1LFIo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:44:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014Ab1LFIo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:44:27 -0500
Date: Tue, 6 Dec 2011 09:42:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111206084230.GC30062@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> BSP or CPU0 has been the last obstacle to CPU hotplug on x86. 
> This patch set implements BSP online and offline and removes 
> this obstacle to CPU hotplug.
> 
> RAS needs the feature. If socket0 needs to be hotplugged for 
> any reason (any thread on socket0 is bad, shared cache issue, 
> uncore issue, etc), CPU0 is required to be offline or hot 
> replaced to keep the system run.
> 
> v4: Add __read_mostly for bsp_hotpluggable variable. Add my 
> email address in cpu-hotplug.txt document. A wording change in 
> comment.
> 
> v3: Register a pm notifier to check if CPU0 is online before 
> hibernate/suspend. Small wording changes in document and print 
> info.
> 
> v2: Add locking changes between cpu hotplug and 
> hibernate/suspend. Change PIC irq bound to CPU0 detection.
> 
> Fenghua Yu (7):
>   x86/topology.c: Support functions for BSP online/offline
>   x86/common.c: Init BSP data during BSP online
>   x86/mtrr/main.c: Ask the first online CPU to save mtrr
>   x86/smpboot.c: Don't offline BSP if any irq can not be migrated out
>     of it
>   Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0
>     online/offline feature
>   x86/i387.c: Thread xstate is initialized only on BSP once
>   x86/power/cpu.c: Don't hibernate/suspend if CPU0 is offline
> 
>  Documentation/cpu-hotplug.txt       |   19 +++++++++++++++
>  Documentation/kernel-parameters.txt |   13 ++++++++++
>  arch/x86/include/asm/processor.h    |    1 +
>  arch/x86/kernel/cpu/common.c        |   13 ++++++++--
>  arch/x86/kernel/cpu/mtrr/main.c     |    9 +++++-
>  arch/x86/kernel/i387.c              |    9 ++++++-
>  arch/x86/kernel/smpboot.c           |   43 ++++++++++++++++++++++++++++-----
>  arch/x86/kernel/topology.c          |   24 +++++++++++++-----
>  arch/x86/power/cpu.c                |   44 +++++++++++++++++++++++++++++++++++
>  9 files changed, 155 insertions(+), 20 deletions(-)

This is an interesting but totally scary feature to me! :-)

One aspect that makes it essentially undebuggable is that right 
now it needs a boot parameter to even activate. Few people will 
test it this way.

So at minimum i'd suggest adding a new Kconfig switch ak'a 
CONFIG_BOOTPARAM_HOTPLUG_BOOT_CPU (disabled by default) which 
alpha-testers, randconfig setups and distributions with suicidal 
tendencies could enable by default.

Also, could you please enumerate all limitations that could 
possibly happen? The documentation has this list right now:

+1. Resume from hibernate/suspend depends on BSP. Hibernate/suspend will fail if
+BSP is offline and you need to online BSP before hibernate/suspend can continue.

This needs to be fixed on some other fashion than warning people 
in documentation that it would break.

Firstly, at minimum a suspend/hibernate attempt should fail in 
some deterministic fashion.

Secondly, and more importantly, is there *any* hardware in 
existence that has a BIOS that can suspend/resume successfully 
with BSP offlined? If such hardware exists then we need to 
support it properly - initially perhaps by whitelisting such 
systems.

Then if demand for this picks up some more intelligent method of 
cooperating with the firmware could be added: the firmware could 
actually signal to us whether it supports suspend/resume from 
other than the boot CPU.

+2. PIC interrupts also depend on BSP. BSP can't be removed if a PIC interrupt
+is detected.
+
+It's said poweroff/reboot may depend on BSP on some machines although I haven't
+seen any poweroff/reboot failure so far after BSP is offline on a few tested
+machines.

We need a debug feature for this: CONFIG_DEBUG_BOOT_CPU_OFF=y or 
such (disabled by default): this feature would offline the boot 
CPU as soon as possible, and boot up userspace with the boot CPU 
offlined.

So these are the things we need to even begin considering such a 
patch-set for mainline.

Thanks,

	Ingo
