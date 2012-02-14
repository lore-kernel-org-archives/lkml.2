Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab2BNT6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:58:11 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51979 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2BNT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:58:07 -0500
Message-ID: <4F3ABCC1.5020000@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 01:27:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arjan van de Ven <arjanvandeven@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, gregkh@linuxfoundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
References: <20120130205444.22f5e26a@infradead.org> <20120131125232.GD4408@elte.hu>	<20120131054155.371e8307@infradead.org> <20120131143130.GF13676@elte.hu>	<20120131072216.1ce78e50@infradead.org> <20120131161207.GA18357@elte.hu>	<20120131082439.575978c0@infradead.org> <4F3A1891.8060001@linux.vnet.ibm.com>	<4F3A2DFB.5000209@linux.vnet.ibm.com> <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com>
In-Reply-To: <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021419-8256-0000-0000-00000141FCCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Small note, it appears as if the last 2 of your replies to this thread
 didn't reach LKML.]

On 02/14/2012 08:01 PM, Arjan van de Ven wrote:

> one coments; will comment more when I get to work
> 
> On Tue, Feb 14, 2012 at 1:48 AM, Srivatsa S. Bhat 
> 
> 7. And whichever code between smp_init() and async_synchronize_full() didn't
> 
>     care about CPU hotplug till today but depended on all cpus being
>     online must
>     suddenly start worrying about CPU Hotplug. They must register a cpu
>     notifier
>     and handle callbacks etc etc.. Or if they are not worth that
>     complexity, they
>     should atleast be redesigned or moved around - like the print
>     statements that
>     tell how many cpus came up, for example.
> 
> 
> frankly, such code HAS to worry about cpus going online and offline even
> today; the firmware, at least on X86, can start taking cores
> offline/online once ACPI is initialized....
> (as controlled by a data center manager from outside the box, usually
> done based on thermal or power conditions on a datacenter level).
> Now, no doubt that we have bugs in this space, since this only happened
> very rarely before.
> 
> Question is what to do from a longer term strategy:
> Either we declare the number of online CPUs invariant during a certain
> phase of the boot (and make ACPI and co honor this as well somehow)
> or
> We decide to go about fixing these (maybe with the help of lockdep?)
> 
> In addition to this, the reality is that the whole "bring cpus up"
> sequence needs to be changed; the current one is very messy and requires
> the hotplug lock for the whole bring up of each individual cpu... which
> is a very unfortunate design; a much better design would be to only take
> the lock for the actual registration of the newly brought up CPU to the
> kernel, while running the physical bringup without the global lock.
> If/when that change gets made, we can do the physical bring up in
> parallel (with each other, but also with the rest of the kernel boot),
> and do the registration en-mass at some convenient time in the boot,
> potentially late.
> 


Sounds like a good idea, but how will we take care of CPU_UP_PREPARE and
CPU_STARTING callbacks then? Because, CPU_UP_PREPARE callbacks are run
before bringing up the cpu and CPU_STARTING is called from the cpu that is
coming up. Also, CPU_UP_PREPARE callbacks can be failed, which can lead
to that particular cpu boot getting aborted. With the "late commissioning
of CPUs" idea you proposed above, retaining such semantics could become
very challenging.

Regards,
Srivatsa S. Bhat

