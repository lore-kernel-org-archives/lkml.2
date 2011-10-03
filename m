Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1JCUAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:00:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab1JCUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:00:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
Date: Mon, 3 Oct 2011 22:02:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel" <xen-devel@lists.xensource.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com> <alpine.LFD.2.02.1110032033530.1489@ionos>
In-Reply-To: <alpine.LFD.2.02.1110032033530.1489@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110032202.24237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 03, 2011, Thomas Gleixner wrote:
> On Mon, 3 Oct 2011, Ian Campbell wrote:
> > I can see a few options for how I might go about solving this in a
> > non-hacky way, which approach do you think would be preferable:
> 
> The question is whether you need to disable the IPI interrupt at
> all. If not, we have a flag for that.
>  
> >       * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and use it
> >         for these interrupts.
> 
> That's the preferable solution, as we could use that for PPC as well,
> unless we can move stuff around, so we disable stuff later. 
> 
> >       * register syscore ops for the Xen event channel subsystem to
> >         unmask the IPIs earlier (would probably look a lot like the code
> >         removed by 676dc3cf5bc3).
> 
> I'd like to avoid that.
> 
> >       * add syscore_ops to Xen smp subsystem to unmask the specific IPIs
> >         (which it binds at start of day) earlier.
> >       * push dpm_(suspend|resume)_noirq down into stop machine region
> 
> Where is stomp machine used?
> 
> >       * use something other than stop_machine to quiesce system and move
> >         to cpu0 for suspend (doesn't seem sensible to reproduce that
> >         functionality).
> 
> We already shut down the nonboot cpus on suspend. We could do that
> _before_ we disable devices and the interrupts.
>  
> Raphael ?

I'm afraid that wouldn't work.  At least right now our suspend sequence is
reasonably in line with what ACPI says.

Besides, we suspend devices in parallel now, so that would be going backwards
a bit.

Thanks,
Rafael
