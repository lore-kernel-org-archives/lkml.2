Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0ESVJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:09:05 -0400
Received: from www.tglx.de ([62.245.132.106]:57686 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab0ESVJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:09:03 -0400
Date: Wed, 19 May 2010 23:08:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: michael@ellerman.id.au, Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Doug Maxey <doug.maxey@us.ibm.com>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
In-Reply-To: <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com> <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Thomas Gleixner wrote:
> > I'm still not clear on why the ultimate solution wasn't to have XICS report
> > edge triggered as edge triggered. Probably some complexity of the entire power
> > stack that I am ignorant of.
> > 
> > > Apart from the issue of loosing interrupts there is also the fact that
> > > masking on the XICS requires an RTAS call which takes a global lock.
> 
> Right, I'd love to avoid that but with real level interrupts we'd run
> into an interrupt storm. Though another solution would be to issue the
> EOI after the threaded handler finished, that'd work as well, but
> needs testing.

Thought more about that. The case at hand (ehea) is nasty:

The driver does _NOT_ disable the rx interrupt in the card in the rx
interrupt handler - for whatever reason.

 So even in mainline you get repeated rx interrupts when packets
 arrive while napi is processing the poll, which is suboptimal at
 least. In fact it is counterproductive as the whole purpose of NAPI
 is to _NOT_ get interrupts for consecutive incoming packets while the
 poll is active.

Most of the other network drivers do:

      rx_irq()
	disable rx interrupts on card
	napi_schedule()

Now when the napi poll is done (no more packets available) then the
driver reenables the rx interrupt on the card.

Thanks,

	tglx
