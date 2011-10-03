Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab1JCTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:09:18 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:32797 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab1JCTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:08:30 -0400
X-IronPort-AV: E=Sophos;i="4.68,481,1312156800"; 
   d="scan'208";a="8186372"
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.2.02.1110032033530.1489@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110032033530.1489@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Mon, 3 Oct 2011 20:08:28 +0100
Message-ID: <1317668908.11991.20.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 19:42 +0100, Thomas Gleixner wrote:
> On Mon, 3 Oct 2011, Ian Campbell wrote:
> > I can see a few options for how I might go about solving this in a
> > non-hacky way, which approach do you think would be preferable:
> 
> The question is whether you need to disable the IPI interrupt at
> all. If not, we have a flag for that.

We already that flag for these (I think that was why it was added even).
The issue is that in the resuming domain on the other side event
channels all start off masked and something needs to unmask them.

> >       * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and use it
> >         for these interrupts.
> 
> That's the preferable solution, as we could use that for PPC as well,
> unless we can move stuff around, so we disable stuff later.

OK

> >       * register syscore ops for the Xen event channel subsystem to
> >         unmask the IPIs earlier (would probably look a lot like the code
> >         removed by 676dc3cf5bc3).
> 
> I'd like to avoid that.

Sure.

> >       * add syscore_ops to Xen smp subsystem to unmask the specific IPIs
> >         (which it binds at start of day) earlier.
> >       * push dpm_(suspend|resume)_noirq down into stop machine region
> 
> Where is stomp machine used?

It is used by the xen PV suspend handler which runs in that context in
order to quiesce non-boot CPUs (which Xen does not unplug like native
does).

> >       * use something other than stop_machine to quiesce system and move
> >         to cpu0 for suspend (doesn't seem sensible to reproduce that
> >         functionality).
> 
> We already shut down the nonboot cpus on suspend. We could do that
> _before_ we disable devices and the interrupts.

Xen PV suspend uses many of the PM/suspend core code paths but it does
not have the bit which shuts down non-boot CPUs.

It was a while ago but IIRC Xen used to unplug the secondary processors
and it was found to lead to larger latencies in the migration and
checkpointing cases (which at their core are a suspend/resume). The
disaster recovery folks in particular care about this latency since they
want to do rolling checkpoints many times a second.

Ian.

>  
> Raphael ?
> 
> Thanks,
> 
> 	tglx


