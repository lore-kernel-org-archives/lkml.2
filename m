Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0LDQKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 11:10:55 -0500
Received: from www.tglx.de ([62.245.132.106]:55568 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0LDQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 11:10:54 -0500
Date: Sat, 4 Dec 2010 17:10:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/5] KVM&genirq: Enable adaptive IRQ sharing for
 passed-through devices
In-Reply-To: <4CFA560C.3050206@web.de>
Message-ID: <alpine.LFD.2.00.1012041706050.2653@localhost6.localdomain6>
References: <cover.1291419444.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6> <4CFA2763.4060102@web.de> <alpine.LFD.2.00.1012041526280.2653@localhost6.localdomain6> <4CFA560C.3050206@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Dec 2010, Jan Kiszka wrote:
> Am 04.12.2010 15:41, Thomas Gleixner wrote:
> > Also there is a pretty simple solution for this: The core code knows,
> > that there is an ONESHOT interrupt in flight, so it simply can call
> 
> It doesn't synchronize the tail part against the masking in the
> handler(s), that's driver business.

Right, but the core knows from the irq state, that the line is masked
and due to the ONESHOT or whatever feature it knows that it needs to
call the handler.

The other way round shared -> exclusive does not matter at all.

> > the primary handler of that device with the appropriate flag set
> > (maybe an additional one to indicate the transition) and let that deal
> > with it. Needs some thought vs. locking and races, but that shouldn't
> > be hard.
> 
> Yes, I thought about this kind of transition (re-invoking the existing
> handler) already. We do need notification of the switch (at least for
> exclusive->shared) as only the driver can migrate the masking for
> in-flight interrupts.

Right. It needs to set the device level mask in that case. As the
interrupt handler already has the code to do that it's the most
obvious function to call.

Thanks,

	tglx
