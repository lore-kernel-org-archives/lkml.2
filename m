Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0ETIOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:14:23 -0400
Received: from www.tglx.de ([62.245.132.106]:59346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0ETIOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:14:20 -0400
Date: Thu, 20 May 2010 10:14:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan-Bernd Themann <THEMANN@de.ibm.com>
cc: michael@ellerman.id.au, Brian King <brking@linux.vnet.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, dvhltc@linux.vnet.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, niv@linux.vnet.ibm.com,
       Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
In-Reply-To: <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com>
Message-ID: <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com>  <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>  <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>  <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain> 
 <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain> <1274319248.22892.40.camel@concordia> <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Jan-Bernd Themann wrote:
> > > Thought more about that. The case at hand (ehea) is nasty:
> > >
> > > The driver does _NOT_ disable the rx interrupt in the card in the rx
> > > interrupt handler - for whatever reason.
> >
> > Yeah I saw that, but I don't know why it's written that way. Perhaps
> > Jan-Bernd or Doug will chime in and enlighten us? :)
> 
> From our perspective there is no need to disable interrupts for the
> RX side as the chip does not fire further interrupts until we tell
> the chip to do so for a particular queue. We have multiple receive

The traces tell a different story though:

    ehea_recv_irq_handler()
      napi_reschedule()
    eoi()
    ehea_poll()
      ...
      ehea_recv_irq_handler()    <---------------- ???
        napi_reschedule()
      ...
      napi_complete()

Can't tell whether you can see the same behaviour in mainline, but I
don't see a reason why not.

> queues with an own interrupt each so that the interrupts can arrive
> on multiple CPUs in parallel.  Interrupts are enabled again when we
> leave the NAPI Poll function for the corresponding receive queue.

I can't see a piece of code which does that, but that's probably just
lack of detailed hardware knowledge on my side.

Thanks,

	tglx
