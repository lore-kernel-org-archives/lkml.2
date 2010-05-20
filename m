Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0ETOxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:53:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49133 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0ETOxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:53:23 -0400
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Jan-Bernd Themann <THEMANN@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Brian King <brking@linux.vnet.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       dvhltc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, michael@ellerman.id.au,
       niv@linux.vnet.ibm.com
In-Reply-To: <OFCBBE5EB9.FD616EDA-ONC1257729.0030B539-C1257729.0031FB06@de.ibm.com>
References: <4BF30793.5070300@us.ibm.com>
	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
	 <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>
	 <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
	 <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain>
	 <1274319248.22892.40.camel@concordia>
	 <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com>
	 <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain>
	 <OFCBBE5EB9.FD616EDA-ONC1257729.0030B539-C1257729.0031FB06@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 20 May 2010 09:53:14 -0500
Message-ID: <1274367195.1675.27.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 11:05 +0200, Jan-Bernd Themann wrote:
> Hi Thomas
> 
> > Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
> >
> > On Thu, 20 May 2010, Jan-Bernd Themann wrote:
> > > > > Thought more about that. The case at hand (ehea) is nasty:
> > > > >
> > > > > The driver does _NOT_ disable the rx interrupt in the card in the
> rx
> > > > > interrupt handler - for whatever reason.
> > > >
> > > > Yeah I saw that, but I don't know why it's written that way. Perhaps
> > > > Jan-Bernd or Doug will chime in and enlighten us? :)
> > >
> > > From our perspective there is no need to disable interrupts for the
> > > RX side as the chip does not fire further interrupts until we tell
> > > the chip to do so for a particular queue. We have multiple receive
> >
> > The traces tell a different story though:
> >
> >     ehea_recv_irq_handler()
> >       napi_reschedule()
> >     eoi()
> >     ehea_poll()
> >       ...
> >       ehea_recv_irq_handler()    <---------------- ???
> >         napi_reschedule()
> >       ...
> >       napi_complete()
> >
> > Can't tell whether you can see the same behaviour in mainline, but I
> > don't see a reason why not.
> 
> Is this the same interrupt we are seeing here, or do we see a second other
> interrupt popping up on the same CPU? As I said, with multiple receive
> queues
> (if enabled) you can have multiple interrupts in parallel.

Same interrupt number (260).      Per the trace data, the first
ehea_recv_irq_handler (at 117.904525) was on cpu 0, the second (at
117.904689) was on cpu 1.



<...>-2180  [000]  117.904525: .ehea_recv_irq_handler: ENTER 0 c0000000e8bd08b0
<...>-2180  [000]  117.904527: .ehea_recv_irq_handler: napi_reschedule COMpleted  c0000000e8bd08b0
<...>-2180  [000]  117.904528: .ehea_recv_irq_handler: EXIT reschedule(1) 1 c0000000e8bd08b0
<...>-2180  [000]  117.904529: .xics_unmask_irq: xics: unmask virq 260 772
<...>-2180  [000]  117.904547: .xics_unmask_irq: xics: unmask virq pre-xive 260 772 0 status:0 ff
<...>-2180  [000]  117.904586: .xics_unmask_irq: xics: unmask virq post-xive 260 772 0 D:11416 status:0 5
<...>-2180  [000]  117.904602: .handle_fasteoi_irq: 260 8004000
<...>-2180  [000]  117.904603: .xics_mask_irq: xics: mask virq 260 772
<...>-2180  [000]  117.904634: .xics_mask_real_irq: xics: before: mask_real 772 status:0 5
<...>-2180  [000]  117.904668: .xics_mask_real_irq: xics: after: mask_real 772 status:0 ff
<...>-2180  [000]  117.904669: .handle_fasteoi_irq: pre-action:  260 8004100
<...>-2180  [000]  117.904671: .handle_fasteoi_irq: post-action: 260 8004100
<...>-2180  [000]  117.904672: .handle_fasteoi_irq: exit.  260 8004000
<...>-7     [000]  117.904681: .ehea_poll:  ENTER  1  c0000000e8bd08b0 poll_counter:0 force:0
<...>-7     [000]  117.904683: .ehea_proc_rwqes: ehea_check_cqe 0
<...>-2180  [001]  117.904689: .ehea_recv_irq_handler: ENTER 1 c0000000e8bd08b0
<...>-7     [000]  117.904690: .ehea_proc_rwqes: ehea_check_cqe 0
<...>-2180  [001]  117.904691: .ehea_recv_irq_handler: napi_reschedule inCOMplete  c0000000e8bd08b0
<...>-2180  [001]  117.904692: .ehea_recv_irq_handler: EXIT reschedule(0) 1 c0000000e8bd08b0
<...>-2180  [001]  117.904694: .xics_unmask_irq: xics: unmask virq 260 772
<...>-7     [000]  117.904702: .ehea_refill_rq2: ehea_refill_rq2
<...>-7     [000]  117.904703: .ehea_refill_rq_def: ehea_refill_rq_def
<...>-7     [000]  117.904704: .ehea_refill_rq3: ehea_refill_rq3
<...>-7     [000]  117.904705: .ehea_refill_rq_def: ehea_refill_rq_def
<...>-7     [000]  117.904706: .napi_complete: napi_complete: ENTER  state: 1  c0000000e8bd08b0
<...>-7     [000]  117.904707: .napi_complete: napi_complete: EXIT  state: 0  c0000000e8bd08b0
<...>-7     [000]  117.904710: .ehea_poll: EXIT  !cqe rx(2).   0  c0000000e8bd08b0
<...>-2180  [001]  117.904719: .xics_unmask_irq: xics: unmask virq pre-xive 260 772 0 status:0 ff
<...>-2180  [001]  117.904761: .xics_unmask_irq: xics: unmask virq post-xive 260 772 0 D:12705 status:0 5




> Pleaes check if multiple queues are enabled. The following module parameter
> is used for that:
> 
> MODULE_PARM_DESC(use_mcs, " 0:NAPI, 1:Multiple receive queues, Default = 0
> ");

No module parameters were used, should be plain old defaults.  

> 
> you should also see the number of used HEA interrupts in /proc/interrupts
> 

256:          1    0    0    0    0    0   0    0   XICS      Level     ehea_neq
259:          0    0    0    0    0    0   0    0   XICS      Level     eth0-aff
260:     361965    0    0    0    0    0   0    0   XICS      Level     eth0-queue0




> 
> >
> > > queues with an own interrupt each so that the interrupts can arrive
> > > on multiple CPUs in parallel.  Interrupts are enabled again when we
> > > leave the NAPI Poll function for the corresponding receive queue.
> >
> > I can't see a piece of code which does that, but that's probably just
> > lack of detailed hardware knowledge on my side.
> 
> If you mean the "re-enable" piece of code, it is not very obvious, you are
> right.
> Interrupts are only generated if a particular register for our completion
> queues
> is written. We do this in the following line:
> 
>           ehea_reset_cq_ep(pr->recv_cq);
>           ehea_reset_cq_ep(pr->send_cq);
>           ehea_reset_cq_n1(pr->recv_cq);
>           ehea_reset_cq_n1(pr->send_cq);
> 
> So this is in a way an indirect way to ask for interrupts when new
> completions were
> written to memory. We don't really disable/enable interrupts on the HEA
> chip itself.
> 
> I think there are some mechanisms build in the HEA chip that should prevent
> that
> interrupts don't get lost. But that is something that is / was completely
> hidden from
> us, so my skill is very limited there.
> 
> If more details are needed here we should involve the PHYP guys + eHEA HW
> guys if not
> already done. Did anyone already talk to them?
> 
> Regards,
> Jan-Bernd
> 


