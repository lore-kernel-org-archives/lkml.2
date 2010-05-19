Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0ESOim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:38:42 -0400
Received: from www.tglx.de ([62.245.132.106]:59290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0ESOil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:38:41 -0400
Date: Wed, 19 May 2010 16:38:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: michael@ellerman.id.au, Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Doug Maxey <doug.maxey@us.ibm.com>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
In-Reply-To: <4BF3F2DB.7030701@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Darren Hart wrote:

> On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> > On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> > > On 05/18/2010 02:52 PM, Brian King wrote:
> > > > Is IRQF_NODELAY something specific to the RT kernel? I don't see it in
> > > > mainline...
> > > 
> > > Yes, it basically says "don't make this handler threaded".
> > 
> > That is a good fix for EHEA, but the threaded handling is still broken
> > for anything else that is edge triggered isn't it?
> 
> No, I don't believe so. Edge triggered interrupts that are reported as edge
> triggered interrupts will use the edge handler (which was the approach
> Sebastien took to make this work back in 2008). Since XICS presents all
> interrupts as Level Triggered, they use the fasteoi path.

I wonder whether the XICS interrupts which are edge type can be
identified from the irq_desc->flags. Then we could avoid the masking
for those in the fasteoi_handler in general.

> > 
> > The result of the discussion about two years ago on this was that we
> > needed a custom flow handler for XICS on RT.
> 
> I'm still not clear on why the ultimate solution wasn't to have XICS report
> edge triggered as edge triggered. Probably some complexity of the entire power
> stack that I am ignorant of.
> 
> > Apart from the issue of loosing interrupts there is also the fact that
> > masking on the XICS requires an RTAS call which takes a global lock.

Right, I'd love to avoid that but with real level interrupts we'd run
into an interrupt storm. Though another solution would be to issue the
EOI after the threaded handler finished, that'd work as well, but
needs testing.

> Right, one of may reasons why we felt this was the right fix. The other is
> that there is no real additional overhead in running this as non-threaded
> since the receive handler is so short (just napi_schedule()).

Yes, in the case at hand it's the right thing to do, as we avoid
another wakeup/context switch.

Thanks,

	tglx
