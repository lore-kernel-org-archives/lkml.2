Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2GIXTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:19:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2GIXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:19:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND AGAIN][PATCH] pcmcia: move unbind/rebind into dev_pm_ops.complete
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 10 Jul 2012 01:19:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207100119.25214.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, keyboard splat)

On Tuesday, July 10, 2012 01:01:31 AM Andrew Morton wrote:
> On Tue, 10 Jul 2012 00:54:54 +0200
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Monday, July 09, 2012 11:59:39 PM Andrew Morton wrote:
> > > On Fri, 6 Jul 2012 14:30:16 -0700
> > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > On Fri, Jul 06, 2012 at 11:23:52PM +0200, Christian Lamparter wrote:
> > > > > The idea of moving rebind procedure into pm.complete
> > > > > was taken from the usb-subsystem, which has similar
> > > > > problems with reattaching devices during/after
> > > > > resume.
> > > > > 
> > > > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > > > > ---
> > > > > To Greg:
> > > > > 
> > > > > I have submitted this patch back in March and again in May.
> > > > > As far as I can tell it was neither rejected nor was it
> > > > > accepted into linux-pcmcia.git since. So I'm asking you,
> > > > > if you could take the patch instead... please.
> > > > 
> > > > There is a PCMCIA "team" who should be taking these types of patches.
> > > > Why are they not doing so?
> > > > 
> > > 
> > > Things are pretty quiet in pcmcia world, but Dominik does appear to
> > > still be doing stuff.
> > > 
> > > I sometimes queue PCMCIA patches for people, but not this one.  The
> > > changelog is just junk.  What does the patch do?  Why does it do it? 
> > > What problems does it solve?  What are these mysterious "problems with
> > > reattaching devices" to which it refers?  Useless...
> > > 
> > Well, that can be improved, but it is a bit tricky. 
> > AFAICT the usb subsystem dealt with pm in this commit:
> > 
> > "commit 5096aedcd2eb70fbea83f09281f97f9ec973d9de
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Tue Aug 12 14:34:14 2008 -0400
> > 
> >     USB: Don't rebind before "complete" callback
> > 
> > 	[...] We are not allowed to call drivers' probe routines during 
> > 	a system sleep transition between the "prepare" and "complete"
> > 	callbacks, but that's exactly what we do when a driver doesn't
> > 	have full suspend/resume support. [...]"
> > 
> > And on the pcmcia subsystem we have this:
> > 
> > "commit 88b060d6c03fcb9e4d2018b4349954c4242a5c7f
> > Author: Dominik Brodowski <linux@dominikbrodowski.net>
> > Date:   Sat Jan 2 14:14:23 2010 +0100
> > 
> >     pcmcia: improve check for same card in slot after resume
> > 
> >     During a suspend/resume cycle, an user may change the card in the
> >     PCMCIA/CardBus slot. [...]
> >     
> >     For CardBus devices, the PCI hotplug interface doesn't offer a "rescan"
> >     facility which also _removes_ devices no longer to be found behind a
> >     bridge. Therefore, remove and re-add all devices unconditionally."
> > 
> > Unfortunately, the "re-add" is currently done in the *pm resume* callback
> > (socket_late_resume), but according to "USB: Don't rebind..." is not
> > allowed to have it there, so the patch moves it into the *pm complete*
> > callback. The Documentation/power/* contains mostly informations for
> > drivers developers, but AFAICT it doesn't say much about the subsystem
> > to which the device is connected should behave, so there's a bit of a
> > "citing-gap".
> 
> hm, it does seem a bit of a screwup.
> 
> What's unclear to me is whether your patch fixes any observed runtime
> problems.  Or adds any runtime problems, which looks to be a distinct
> possibility.

well, the patch for the pcmcia subsystem is part of a fix for this
bug-report: <https://bugzilla.kernel.org/show_bug.cgi?id=40772>
(Note: the firmware-core changes I talk about there have been fixed
by Rafael with his "firmware_class: Rework usermodehelper check"
series)

But that could very well be a straw-man argument. As I can't really
tell without the same HW. (I have mostly minipci hardware, and the
laptop I have with a cardbus doesn't really suspend reliably).

> > So, my question now: Would you accept the pcmcia patch if I add the
> > "USB: Don't rebind..." as a reference to why the re-add needs to be
> > done in complete? Or do you think that I should bug the pm people
> > (and Alan - since he wrote that it is "not allowed") in this case
> > so I can link their official answer to this patch?
> 
> Well I could grab it and give it a little bit of testing in linux-next.
> But I'd be super-reluctant to send such a patch upstream without
> detailed input from Alan/Greg/Rafael/Dominik/etc.
Alright, I've added them in the 'CC'.

To Alan:
Can you please tell me, if you (still) know the details why the "re-add"
is not allowed in _resume callback (see patch message & commit id from
above: USB: Don't rebind before "complete")?

Regards,
	Chr

Good night!
