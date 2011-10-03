Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1JCSmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:42:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:53256 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1JCSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:42:27 -0400
Date: Mon, 3 Oct 2011 20:42:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
In-Reply-To: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.02.1110032033530.1489@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Ian Campbell wrote:
> I can see a few options for how I might go about solving this in a
> non-hacky way, which approach do you think would be preferable:

The question is whether you need to disable the IPI interrupt at
all. If not, we have a flag for that.
 
>       * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and use it
>         for these interrupts.

That's the preferable solution, as we could use that for PPC as well,
unless we can move stuff around, so we disable stuff later. 

>       * register syscore ops for the Xen event channel subsystem to
>         unmask the IPIs earlier (would probably look a lot like the code
>         removed by 676dc3cf5bc3).

I'd like to avoid that.

>       * add syscore_ops to Xen smp subsystem to unmask the specific IPIs
>         (which it binds at start of day) earlier.
>       * push dpm_(suspend|resume)_noirq down into stop machine region

Where is stomp machine used?

>       * use something other than stop_machine to quiesce system and move
>         to cpu0 for suspend (doesn't seem sensible to reproduce that
>         functionality).

We already shut down the nonboot cpus on suspend. We could do that
_before_ we disable devices and the interrupts.
 
Raphael ?

Thanks,

	tglx
