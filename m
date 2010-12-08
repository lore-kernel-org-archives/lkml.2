Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0LHWqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:46:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:33578 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab0LHWqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:46:45 -0500
Subject: Re: [PATCH] Introduce mips_late_time_init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Anoop P A <anoop.pa@gmail.com>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1012082217230.2653@localhost6.localdomain6>
References: <1291623812.31822.6.camel@paanoop1-desktop>
	 <4CFD2095.9040404@caviumnetworks.com>
	 <20101208203704.GB30923@linux-mips.org>
	 <alpine.LFD.2.00.1012082217230.2653@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 09:45:46 +1100
Message-ID: <1291848346.16694.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 22:21 +0100, Thomas Gleixner wrote:
> On Wed, 8 Dec 2010, Ralf Baechle wrote:
> > Running everything from late_time_init() instead allows the use of kmalloc.
> > X86 has the same issue with requiring kmalloc in time_init which is why
> > they had moved everything to late_time_init.
> 
> It's more ioremap, but yeah.
>  
> > So the real question is, why can't we just move the call of time_init()
> > in setup_kernel() to where late_time_init() is getting called from for
> > all architectures, does anything rely on it getting called early?
> 
> That's a good question and I asked it myself already. I can't see a
> real reason why something would need it early. Definitely worth to
> try.

Well, I can see some reasons at least...

On ppc at least, we calibrate the timebase/decrementer in time_init, so
things like udelay etc... are going to be unreliable until we've done
that, which could be a problem if done too late due to sensitive HW
accessors that might rely on these.

So we'd probably need to move that to a different (early) arch callback
if time_init is moved.

Also, still on server PPC, you can't really disable the decrementer
(only delay it). So if interrupts are enabled, we will eventually get
timer ones.

So we'd have to be careful about keeping some state, knowing that the
stuff isn't initialized yet and just set the decrementer to fire again
as late as possible, until it's properly configured.

Besides, we can use kmalloc that early nowadays, can't we ? That's what
the gfp_allowed_mask is all about ...

Cheers,
Ben.


