Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0HYRyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:54:44 -0400
Received: from claw.goop.org ([74.207.240.146]:40922 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0HYRym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:54:42 -0400
Message-ID: <4C7558E0.1060806@goop.org>
Date: Wed, 25 Aug 2010 10:54:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Tom Kopec <tek@acm.org>, Daniel Stodden <daniel.stodden@citrix.com>,
        Stable Kernel <stable@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] Fix lost interrupt race in Xen	 event
 channels
References: <4C743B2C.8070208@goop.org> <4C74E7C802000078000120C0@vpn.id2.novell.com>
In-Reply-To: <4C74E7C802000078000120C0@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/25/2010 12:52 AM, Jan Beulich wrote:
>  >>> On 24.08.10 at 23:35, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> We worked out the root cause was that it was incorrectly treating Xen
>> events as level rather than edge triggered interrupts, which works fine
>> unless you're handling one interrupt, the interrupt gets migrated to
>> another cpu and then re-raised.  This ends up losing the interrupt
>> because the edge-triggering of the second interrupt is lost.
> While this description would seem plausible at the first glance, it
> doesn't match up with unmask_evtchn() already taking care of
> exactly this case. Or are you implicitly saying that this code is
> broken in some way (if so, how, and shouldn't it then be that
> code that needs fixing, or removing if you want to stay with the
> edge handling)?
>
> I do however agree that using handle_level_irq() is problematic
> (see http://lists.xensource.com/archives/html/xen-devel/2010-04/msg01178.html),
> but as said there I think using the fasteoi logic is preferable. No
> matter whether using edge or level, the ->end() method will
> never be called (whereas fasteoi calls ->eoi(), which would
> just need to be vectored to the same function as ->end()).
> Without end_pirq() ever called, you can't let Xen know of
> bad PIRQs (so that it can disable them instead of continuing
> to call the [now shortcut] handler in the owning domain).

Note that this patch is specifically for upstream Xen, which doesn't
have any pirq support in it at present.

However,  I did consider using fasteoi, but I couldn't see how to make
it work.  The problem is that it only does a single call into the
irq_chip for EOI after calling the interrupt handler, but there is no
call beforehand to ack the interrupt (which means clear the event flag
in our case).  This leads to a race where an event can be lost after the
interrupt handler has returned, but before the event flag has been
cleared (because Xen won't set pending or call the upcall function if
the event is already set).  I guess I could pre-clear the event in the
upcall function, but I'm not sure that's any better.

In the dom0 kernels, I followed the example of the IOAPIC irq_chip
implementation, which does the hardware EOI in the ack call at the start
of handle_edge_irq, can did the EOI hypercall (when necessary) there.  I
welcome a reviewer's eye on this though.

>> The other change changes IPI and VIRQ event sources to use
>> handle_percpu_irq, because treating them as level is also wrong, and
>> they're actually inherently percpu events, much like LAPIC vectors.
> This doesn't seem right for the general VIRQ case: global ones
> should not be disallowed migration between CPUs. Since in your
> model the requestor has to pass IRQF_PERCPU anyway,
> shouldn't you make the selection of the handler dependent
> upon this flag?

I was thinking specifically of the timer, debug and console virqs.  The
last is the only one which could conceivably be non-percpu, but in
practice I think it would be a bad idea to put it on anything other than
cpu0.  What other global virqs are there?  Nothing that's high-frequency
enough to be worth migrating?

But yes, if necessary, I could make it depend on the IRQF_PERCPU flag.

    J
