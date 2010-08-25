Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0HYKE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:04:29 -0400
Received: from static-ip-62-75-137-225.inaddr.intergenia.de ([62.75.137.225]:42912
	"EHLO vs137225.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0HYKE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:04:26 -0400
Subject: Re: [Xen-devel] [GIT PULL] Fix lost interrupt race in Xen	 event
 channels
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tom Kopec <tek@acm.org>,
        Stable Kernel <stable@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C74E7C802000078000120C0@vpn.id2.novell.com>
References: <4C743B2C.8070208@goop.org>
	 <4C74E7C802000078000120C0@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix VMD
Date: Wed, 25 Aug 2010 03:04:20 -0700
Message-ID: <1282730660.3092.106.camel@ramone.somacoma.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 03:52 -0400, Jan Beulich wrote:
> >>> On 24.08.10 at 23:35, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > We worked out the root cause was that it was incorrectly treating Xen
> > events as level rather than edge triggered interrupts, which works fine
> > unless you're handling one interrupt, the interrupt gets migrated to
> > another cpu and then re-raised.  This ends up losing the interrupt
> > because the edge-triggering of the second interrupt is lost.
> 
> While this description would seem plausible at the first glance, it
> doesn't match up with unmask_evtchn() already taking care of
> exactly this case. Or are you implicitly saying that this code is
> broken in some way (if so, how, and shouldn't it then be that
> code that needs fixing, or removing if you want to stay with the
> edge handling)?

Not broken, but a different problem. The unmask 'resend' only catches
the edge lost if the event was raised while it was still masked. But
level irq doesn't have to save PENDING state. In the Xen event migration
case the edge isn't lost, but the upcall will drop the invocation when
the handler is found inprogress on the previous cpu.

> I do however agree that using handle_level_irq() is problematic
> (see http://lists.xensource.com/archives/html/xen-devel/2010-04/msg01178.html),
> but as said there I think using the fasteoi logic is preferable. No
> matter whether using edge or level, the ->end() method will
> never be called (whereas fasteoi calls ->eoi(), which would
> just need to be vectored to the same function as ->end()).
> Without end_pirq() ever called, you can't let Xen know of
> bad PIRQs (so that it can disable them instead of continuing
> to call the [now shortcut] handler in the owning domain).

Not an opinion, just confused: Isn't all that dealt with in
chip->disable?

Daniel

