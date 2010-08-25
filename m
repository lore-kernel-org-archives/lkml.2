Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0HYHwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:52:16 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47989 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0HYHwO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Wed, 25 Aug 2010 03:52:14 -0400
Message-Id: <4C74E7C802000078000120C0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 25 Aug 2010 08:52:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Tom Kopec" <tek@acm.org>, "Daniel Stodden" <daniel.stodden@citrix.com>,
        "Stable Kernel" <stable@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] Fix lost interrupt race in Xen
	 event channels
References: <4C743B2C.8070208@goop.org>
In-Reply-To: <4C743B2C.8070208@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >>> On 24.08.10 at 23:35, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> We worked out the root cause was that it was incorrectly treating Xen
> events as level rather than edge triggered interrupts, which works fine
> unless you're handling one interrupt, the interrupt gets migrated to
> another cpu and then re-raised.  This ends up losing the interrupt
> because the edge-triggering of the second interrupt is lost.

While this description would seem plausible at the first glance, it
doesn't match up with unmask_evtchn() already taking care of
exactly this case. Or are you implicitly saying that this code is
broken in some way (if so, how, and shouldn't it then be that
code that needs fixing, or removing if you want to stay with the
edge handling)?

I do however agree that using handle_level_irq() is problematic
(see http://lists.xensource.com/archives/html/xen-devel/2010-04/msg01178.html),
but as said there I think using the fasteoi logic is preferable. No
matter whether using edge or level, the ->end() method will
never be called (whereas fasteoi calls ->eoi(), which would
just need to be vectored to the same function as ->end()).
Without end_pirq() ever called, you can't let Xen know of
bad PIRQs (so that it can disable them instead of continuing
to call the [now shortcut] handler in the owning domain).

> The other change changes IPI and VIRQ event sources to use
> handle_percpu_irq, because treating them as level is also wrong, and
> they're actually inherently percpu events, much like LAPIC vectors.

This doesn't seem right for the general VIRQ case: global ones
should not be disallowed migration between CPUs. Since in your
model the requestor has to pass IRQF_PERCPU anyway,
shouldn't you make the selection of the handler dependent
upon this flag?

Jan

