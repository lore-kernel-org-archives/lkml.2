Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0ETIWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:22:04 -0400
Received: from www.tglx.de ([62.245.132.106]:45440 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab0ETIV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:21:59 -0400
Date: Thu, 20 May 2010 10:21:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Darren Hart <dvhltc@us.ibm.com>, Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Doug Maxey <doug.maxey@us.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
In-Reply-To: <1274319125.22892.38.camel@concordia>
Message-ID: <alpine.LFD.2.00.1005201014250.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com>  <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>  <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>  <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
 <1274319125.22892.38.camel@concordia>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Michael Ellerman wrote:
> On Wed, 2010-05-19 at 16:38 +0200, Thomas Gleixner wrote:
> > On Wed, 19 May 2010, Darren Hart wrote:
> > 
> > > On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> > > > On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> 
> > > > The result of the discussion about two years ago on this was that we
> > > > needed a custom flow handler for XICS on RT.
> > > 
> > > I'm still not clear on why the ultimate solution wasn't to have XICS report
> > > edge triggered as edge triggered. Probably some complexity of the entire power
> > > stack that I am ignorant of.
> > > 
> > > > Apart from the issue of loosing interrupts there is also the fact that
> > > > masking on the XICS requires an RTAS call which takes a global lock.
> > 
> > Right, I'd love to avoid that but with real level interrupts we'd run
> > into an interrupt storm. Though another solution would be to issue the
> > EOI after the threaded handler finished, that'd work as well, but
> > needs testing.
> 
> Yeah I think that was the idea for the custom flow handler. We'd reset
> the processor priority so we can take other interrupts (which the EOI
> usually does for you), then do the actual EOI after the handler
> finished.

That only works when the card does not issue new interrupts until the
EOI happens. If the EOI is only relevant for the interrupt controller,
then you are going to lose any edge which comes in before the EOI as
well.

Thanks,

	tglx

