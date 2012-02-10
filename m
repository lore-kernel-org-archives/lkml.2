Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab2BJTED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:04:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:35573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2BJTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:04:01 -0500
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Don Zickus <dzickus@redhat.com>
In-Reply-To: <1328900283.25989.45.camel@laptop>
References: <1328751082.5611.6.camel@lappy>
	 <CA+5PVA6HNqYv7kw3Oq_+05LwrXwtnNnZDkntcrncT2OmGXDd=w@mail.gmail.com>
	 <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
	 <4F34EC35.7010109@linux.vnet.ibm.com>  <1328900283.25989.45.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 20:03:53 +0100
Message-ID: <1328900633.25989.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 19:58 +0100, Peter Zijlstra wrote:
> OK, so a 'modern' kernel does it slightly different and I've no idea
> what exactly goes wrong in your vintage version. But I can see the
> current stuff going at it all wrong.
> 
> What seems to happen is that native_nmi_stop_other_cpus() NMI broadcasts
> for smp_stop_nmi_callback()->stop_this_cpu(). Which without any
> serialization what so ever marks all remote CPUs offline and calls halt
> with IRQs disabled -> dead.
> 
> While we're waiting for this all to complete, the scheduler tries to
> no_hz load-balance and kick a cpu it thinks is still around and we get
> the above splat because the NMI just marked it offline without telling
> anybody about it.
> 
> Now, arguably you don't want to go through the whole hotplug crap to
> shut down your machine, esp not on panic, but clearing the online state
> without telling anybody about it is bound to lead to these things.
> 
> No immediate solution comes to mind... 

Don, any reason you wait for the NMI broadcast to complete with IRQs
enabled? If you disable IRQs before the broadcast the interrupt can't
happen and should side-step this particular problem.

Its not like we have 'latency' issues on this path :-)

