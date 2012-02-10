Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab2BJUDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:03:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2BJUDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:03:13 -0500
Date: Fri, 10 Feb 2012 15:02:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
Message-ID: <20120210200250.GG5650@redhat.com>
References: <1328751082.5611.6.camel@lappy>
 <CA+5PVA6HNqYv7kw3Oq_+05LwrXwtnNnZDkntcrncT2OmGXDd=w@mail.gmail.com>
 <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
 <4F34EC35.7010109@linux.vnet.ibm.com>
 <1328900283.25989.45.camel@laptop>
 <1328900633.25989.47.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328900633.25989.47.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 08:03:53PM +0100, Peter Zijlstra wrote:
> On Fri, 2012-02-10 at 19:58 +0100, Peter Zijlstra wrote:
> > OK, so a 'modern' kernel does it slightly different and I've no idea
> > what exactly goes wrong in your vintage version. But I can see the
> > current stuff going at it all wrong.
> > 
> > What seems to happen is that native_nmi_stop_other_cpus() NMI broadcasts
> > for smp_stop_nmi_callback()->stop_this_cpu(). Which without any
> > serialization what so ever marks all remote CPUs offline and calls halt
> > with IRQs disabled -> dead.
> > 
> > While we're waiting for this all to complete, the scheduler tries to
> > no_hz load-balance and kick a cpu it thinks is still around and we get
> > the above splat because the NMI just marked it offline without telling
> > anybody about it.
> > 
> > Now, arguably you don't want to go through the whole hotplug crap to
> > shut down your machine, esp not on panic, but clearing the online state
> > without telling anybody about it is bound to lead to these things.
> > 
> > No immediate solution comes to mind... 
> 
> Don, any reason you wait for the NMI broadcast to complete with IRQs
> enabled? If you disable IRQs before the broadcast the interrupt can't
> happen and should side-step this particular problem.

Well I believe the old way had the same problem using the REBOOT_IRQ as
opposed to NMI.  I also don't know how to shutdown interrupts system wide
without just broadcasting an IRQ to locally disable interrupts.

> 
> Its not like we have 'latency' issues on this path :-)

Heh.  Oddly I was writing the changelog for a patch that kinda changes
this path to sorta revert back to the old way of using a REBOOT_IRQ with
an NMI follow-on when the IRQ fails.

Originally, I wanted to make sure the cpus were shutdown immediately so we
can serialize the panic path hence the original change.

I also ran into the same problem you did and hacked up another patch that
checked a global atomic variable that let the system know we were shutting
down and not to do the WARN_ON (the global is already created for the NMI
case now).

I'll try to post that soon once I finish my long winded changelog.

Though it kinda addresses your issue, I'm not sure it does it in a way
that will satisfy you.  But I look forward to the discussion. :-)

Cheers,
Don
