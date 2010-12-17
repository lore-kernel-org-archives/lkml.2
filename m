Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0LQQdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:33:09 -0500
Received: from www.tglx.de ([62.245.132.106]:36839 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0LQQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:33:08 -0500
Date: Fri, 17 Dec 2010 17:32:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@ieee.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D0B8A73.4050005@siemens.com>
Message-ID: <alpine.LFD.2.00.1012171725300.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de>
 <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6> <4D0B3C11.4090307@siemens.com> <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6> <4D0B400D.8010903@siemens.com> <alpine.LFD.2.00.1012171315260.12146@localhost6.localdomain6>
 <4D0B8A73.4050005@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Jan Kiszka wrote:
> Am 17.12.2010 16:25, Thomas Gleixner wrote:
> > Your aproach with disable_irq_nosync() is completely flawed, simply
> > because you try to pretend that your interrupt handler is done, while
> > it is not done at all. The threaded interrupt handler is done when
> > user space completes. Everything else is just hacking around the
> > problem and creates all that nasty transitional problems.
> 
> disable_irq_nosync is the pattern currently used in KVM, it's nothing
> new in fact.

That does not make it less flawed :)

> The approach looks interesting but requires separate code for
> non-PCI-2.3 devices, i.e. when we have no means to mask at device level.

Why? You can have the same code, you just can't request COND_ONESHOT
handlers for it, so it needs unshared ONESHOT or it won't work at all,
no matter what approach you chose. No device level mask, no sharing,
it's that simple.

> Further drawbacks - unless I missed something on first glance:
> 
> - prevents any future optimizations that would work without IRQ thread
>   ping-pong (ie. once we allow guest IRQ injection from hardirq context
>   for selected but typical setups)
> - two additional, though light-weight, context switches on each
>   interrupt completion

The drawback of these two points is way less than the horror which you
need to introduce to do the whole async handler disable, userspace
enable dance. Robust and simple solutions really a preferred over
complex and fragile horror which has a questionable runtime benefit.

> - continuous polling if user space decides to leave the interrupt
>   unhandled (e.g. because the virtual IRQ line is masked)
 
That should be a solvable problem.

Thanks,

	tglx
