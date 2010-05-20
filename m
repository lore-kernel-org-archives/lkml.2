Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0ETVoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:44:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49104 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0ETVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:44:52 -0400
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Jan-Bernd Themann <THEMANN@de.ibm.com>,
       michael@ellerman.id.au, Brian King <brking@linux.vnet.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       niv@linux.vnet.ibm.com
In-Reply-To: <alpine.LFD.2.00.1005201644400.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com>
	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
	 <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>
	 <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
	 <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain>
	 <1274319248.22892.40.camel@concordia>
	 <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com>
	 <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain>
	 <4BF5499F.8050203@us.ibm.com>
	 <alpine.LFD.2.00.1005201644400.3368@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 20 May 2010 16:44:33 -0500
Message-ID: <1274391873.1675.33.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 16:45 +0200, Thomas Gleixner wrote:
> On Thu, 20 May 2010, Darren Hart wrote:
> 
> > On 05/20/2010 01:14 AM, Thomas Gleixner wrote:
> > > On Thu, 20 May 2010, Jan-Bernd Themann wrote:
> > > > > > Thought more about that. The case at hand (ehea) is nasty:
> > > > > > 
> > > > > > The driver does _NOT_ disable the rx interrupt in the card in the rx
> > > > > > interrupt handler - for whatever reason.
> > > > > 
> > > > > Yeah I saw that, but I don't know why it's written that way. Perhaps
> > > > > Jan-Bernd or Doug will chime in and enlighten us? :)
> > > > 
> > > >  From our perspective there is no need to disable interrupts for the
> > > > RX side as the chip does not fire further interrupts until we tell
> > > > the chip to do so for a particular queue. We have multiple receive
> > > 
> > > The traces tell a different story though:
> > > 
> > >      ehea_recv_irq_handler()
> > >        napi_reschedule()
> > >      eoi()
> > >      ehea_poll()
> > >        ...
> > >        ehea_recv_irq_handler()<---------------- ???
> > >          napi_reschedule()
> > >        ...
> > >        napi_complete()
> > > 
> > > Can't tell whether you can see the same behaviour in mainline, but I
> > > don't see a reason why not.
> > 
> > I was going to suggest that because these are threaded handlers, perhaps they
> > are rescheduled on a different CPU and then receive the interrupt for the
> > other CPU/queue that Jan was mentioning.
> > 
> > But, the handlers are affined if I remember correctly, and we aren't running
> > with multiple receive queues. So, we're back to the same question, why are we
> > seeing another irq. It comes in before napi_complete() and therefor before the
> > ehea_reset*() block of calls which do the equivalent of re-enabling
> > interrupts.
> 
> Can you slap a few trace points into that driver with a stock mainline
> kernel and verify that ?

2.6.33.4 (non-rt kernel) with similar trace_printk hooks in place...
Most data lumps look like so:

          <idle>-0     [000]  1097.685337: .handle_fasteoi_irq: ENTER 260 4000
          <idle>-0     [000]  1097.685339: .handle_fasteoi_irq: pre-action 260 4100
          <idle>-0     [000]  1097.685339: .ehea_recv_irq_handler:  ENTER  c0000000e8980700
          <idle>-0     [000]  1097.685340: .ehea_recv_irq_handler: napi_schedule ... c0000000e8980700
          <idle>-0     [000]  1097.685341: .ehea_recv_irq_handler: napi_schedule Calling __napi_schedule ... c0000000e8980700
          <idle>-0     [000]  1097.685342: .ehea_recv_irq_handler:  EXIT c0000000e8980700
          <idle>-0     [000]  1097.685343: .handle_fasteoi_irq: post-action 260 4100
          <idle>-0     [000]  1097.685344: .handle_fasteoi_irq: EXIT. 260 4000
          <idle>-0     [000]  1097.685346: .ehea_poll:  ENTER c0000000e8980700
          <idle>-0     [000]  1097.685352: .napi_complete: napi_complete: ENTER c0000000e8980700
          <idle>-0     [000]  1097.685352: .napi_complete: napi_complete: EXIT c0000000e8980700
          <idle>-0     [000]  1097.685355: .ehea_poll:  EXIT !cqe rx(1) c0000000e8980700

But I did see one like this, which shows a ehea_recv_irq_handler ENTER
within a ehea_poll ENTER.   (which I think is what you were expecting,
or wanted to verify..)       


          <idle>-0     [000]  1097.616261: .handle_fasteoi_irq: ENTER 260 4000
          <idle>-0     [000]  1097.616262: .handle_fasteoi_irq: pre-action 260 4100
*          <idle>-0     [000]  1097.616263: .ehea_recv_irq_handler:  ENTER  c0000000e8980700
          <idle>-0     [000]  1097.616264: .ehea_recv_irq_handler: napi_schedule ... c0000000e8980700
          <idle>-0     [000]  1097.616265: .ehea_recv_irq_handler: napi_schedule Calling __napi_schedule ... c0000000e8980700
          <idle>-0     [000]  1097.616265: .ehea_recv_irq_handler:  EXIT c0000000e8980700
          <idle>-0     [000]  1097.616266: .handle_fasteoi_irq: post-action 260 4100
          <idle>-0     [000]  1097.616268: .handle_fasteoi_irq: EXIT. 260 4000
*          <idle>-0     [000]  1097.616270: .ehea_poll:  ENTER c0000000e8980700
          <idle>-0     [000]  1097.616282: .handle_fasteoi_irq: ENTER 260 4000
          <idle>-0     [000]  1097.616283: .handle_fasteoi_irq: pre-action 260 4100
*          <idle>-0     [000]  1097.616284: .ehea_recv_irq_handler:  ENTER  c0000000e8980700
          <idle>-0     [000]  1097.616285: .ehea_recv_irq_handler: napi_schedule ... c0000000e8980700
          <idle>-0     [000]  1097.616286: .ehea_recv_irq_handler: napi_schedule NOT Calling __napi_schedule... c0000000e8980700
          <idle>-0     [000]  1097.616286: .ehea_recv_irq_handler:  EXIT c0000000e8980700
          <idle>-0     [000]  1097.616287: .handle_fasteoi_irq: post-action 260 4100
          <idle>-0     [000]  1097.616289: .handle_fasteoi_irq: EXIT. 260 4000
          <idle>-0     [000]  1097.616299: .napi_complete: napi_complete: ENTER c0000000e8980700
          <idle>-0     [000]  1097.616300: .napi_complete: napi_complete: EXIT c0000000e8980700
          <idle>-0     [000]  1097.616302: .ehea_poll: napi_reschedule COMpleted c0000000e8980700
          <idle>-0     [000]  1097.616303: .napi_complete: napi_complete: ENTER c0000000e8980700
          <idle>-0     [000]  1097.616304: .napi_complete: napi_complete: EXIT c0000000e8980700
*          <idle>-0     [000]  1097.616306: .ehea_poll:  EXIT !cqe rx(4) c0000000e8980700



Let me know if you want/need more or a variation, etc.. 

Thanks, 
-Will

