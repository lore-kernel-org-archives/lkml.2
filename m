Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1IAGZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:25:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:39722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1IAGZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,312,1312182000"; 
   d="scan'208";a="13103148"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Lars Boegild Thomsen <lth@cow.dk>
Date: Thu, 1 Sep 2011 14:24:49 +0800
Subject: RE: [regression] Ideapad S10-3 does not wake up from suspend (Re:
 [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating them)
Thread-Topic: [regression] Ideapad S10-3 does not wake up from suspend (Re:
 [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating them)
Thread-Index: AcxmAlgnRkuGtf1RQRaLutBO1QO8PwCa1S2A
Message-ID: <625BA99ED14B2D499DC4E29D8138F15063048B864D@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
In-Reply-To: <20110829041532.GA22087@elie.gateway.2wire.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jonathan Nieder [mailto:jrnieder@gmail.com]
> Sent: Monday, August 29, 2011 12:16 PM
> 
> Hi,
> 
> Lars Boegild Thomsen writes[1]:
> 
> > After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up after
> > sleep.  Back to latest 2.6 kernel works fine.
> [...]
> > Upon wakeup, the power light go from slow flashing to on, the battery light
> > goes from off to on, the hdd light blink once and then everything is dead.
> > Nothing happens on the screen, all keys dead.  The fan/hdd switch on
> > physically (very hard to hear on this model or I am getting deaf).
> > Ctrl+alt+del or the alt+sysreq is non-responsive.  The only LED that show
> > keyboard status is CAPS lock and that is unresponsive too.  Only way I have
> > found to get it rebooted is holding down the power button a few secs until it
> > switch physically off and then switch it on again.
> [...]
> > Here's the result of the final bisect:
> >
> > 983bbf1af0664b78689612b247acb514300f62c7 is the first bad commit
> [...]
> > I also tried to go back to HEAD and manually change arch/x86/irq.c revert this
> > particular commit and it works.
> 
> For reference:
> 
> > commit 983bbf1af0664b78689612b247acb514300f62c7
> > Author: Tian, Kevin <kevin.tian@intel.com>
> > Date:   Fri May 6 14:43:56 2011 +0800
> >
> >    x86: Don't unmask disabled irqs when migrating them
> >
> >    It doesn't make sense to unconditionally unmask a disabled irq when
> >    migrating it from offlined cpu to another. If the irq triggers then it
> >    will be disabled in the interrupt handler anyway. So we can just avoid
> >    unmasking it.
> >
> >    [ tglx: Made masking unconditional again and fixed the changelog ]
> >
> >    Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
> >    Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> >    Cc: Ian Campbell <Ian.Campbell@citrix.com>
> >    Cc: Jan Beulich <JBeulich@novell.com>
> >    Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
> >    Link:
> http://lkml.kernel.org/r/%3C625BA99ED14B2D499DC4E29D8138F1505C8ED7F
> 7E3%40shsmsx502.ccr.corp.intel.com%3
> >    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >
> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index 544efe2741be..6c0802eb2f7f 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> > @@ -276,7 +276,8 @@ void fixup_irqs(void)
> >  		else if (!(warned++))
> >  			set_affinity = 0;
> >
> > -		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
> > +		if (!irqd_can_move_in_process_context(data) &&
> > +		    !irqd_irq_disabled(data) && chip->irq_unmask)
> >  			chip->irq_unmask(data);
> >
> >  		raw_spin_unlock(&desc->lock);
> 
> Known problem?  Ideas?
> 

this is the 1st problem reported on this change. But honestly speaking
I didn't see obvious problem with it. As the commit msg says, it simply
completes a delayed irq disable action, by keeping interrupt line masked,
instead of relying on a future interrupt handler to actually mask it.

fixup_irqs is invoked in suspend path. The only impact this change may
bring to resume path is the interrupt line state, which is saved later
in suspend and then restored in resume. w/ above change after resume
given interrupt line is always masked, while w/o it there may be at least
one interrupt raising. If this does matter to make your ideapad working,
I'd think there may have other bugs which are hidden originally, e.g. by
triggering a reschedule from that interrupt though the handler itself
does nothing except masking the interrupt line.

So... above commit is not important which can be easily reverted. My
only concern is whether other severe issues are just hidden.

btw, any serial output you may capture?

Thanks
Kevin
