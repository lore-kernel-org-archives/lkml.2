Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0HYLYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:24:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52823 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0HYLYI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Wed, 25 Aug 2010 07:24:08 -0400
Message-Id: <4C751975020000780001214C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 25 Aug 2010 12:24:04 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Daniel Stodden" <daniel.stodden@citrix.com>
Cc: "Tom Kopec" <tek@acm.org>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Stable Kernel" <stable@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] Fix lost interrupt race in Xen
	 event channels
References: <4C743B2C.8070208@goop.org>
 <4C74E7C802000078000120C0@vpn.id2.novell.com>
 <1282730660.3092.106.camel@ramone.somacoma.net>
In-Reply-To: <1282730660.3092.106.camel@ramone.somacoma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.08.10 at 12:04, Daniel Stodden <daniel.stodden@citrix.com> wrote:
> On Wed, 2010-08-25 at 03:52 -0400, Jan Beulich wrote:
>> >>> On 24.08.10 at 23:35, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> > We worked out the root cause was that it was incorrectly treating Xen
>> > events as level rather than edge triggered interrupts, which works fine
>> > unless you're handling one interrupt, the interrupt gets migrated to
>> > another cpu and then re-raised.  This ends up losing the interrupt
>> > because the edge-triggering of the second interrupt is lost.
>> 
>> While this description would seem plausible at the first glance, it
>> doesn't match up with unmask_evtchn() already taking care of
>> exactly this case. Or are you implicitly saying that this code is
>> broken in some way (if so, how, and shouldn't it then be that
>> code that needs fixing, or removing if you want to stay with the
>> edge handling)?
> 
> Not broken, but a different problem. The unmask 'resend' only catches
> the edge lost if the event was raised while it was still masked. But
> level irq doesn't have to save PENDING state. In the Xen event migration
> case the edge isn't lost, but the upcall will drop the invocation when
> the handler is found inprogress on the previous cpu.

Hmm, indeed. But that problem must have existed in all post-2.6.18
kernels then... And that shouldn't be a problem with fasteoi, as that
one calls ->eoi() even when INPROGRESS was set (other than level,
which calls unmask only when it wasn't set).

>> I do however agree that using handle_level_irq() is problematic
>> (see 
> http://lists.xensource.com/archives/html/xen-devel/2010-04/msg01178.html),
>> but as said there I think using the fasteoi logic is preferable. No
>> matter whether using edge or level, the ->end() method will
>> never be called (whereas fasteoi calls ->eoi(), which would
>> just need to be vectored to the same function as ->end()).
>> Without end_pirq() ever called, you can't let Xen know of
>> bad PIRQs (so that it can disable them instead of continuing
>> to call the [now shortcut] handler in the owning domain).
> 
> Not an opinion, just confused: Isn't all that dealt with in
> chip->disable?

With disable_pirq() being empty (at least in the branches I
looked at)?

Jan

