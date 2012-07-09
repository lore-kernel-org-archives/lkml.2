Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2GIXHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:07:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2GIXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:07:40 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND AGAIN][PATCH] pcmcia: move unbind/rebind into dev_pm_ops.complete
Date: Tue, 10 Jul 2012 01:07:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc5-wl+; KDE/4.8.4; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
References: <201207062323.52785.chunkeey@googlemail.com> <201207100054.54535.chunkeey@googlemail.com> <20120709160131.ed3d18d4.akpm@linux-foundation.org>
In-Reply-To: <20120709160131.ed3d18d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207100107.26305.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 10, 2012 01:01:31 AM Andrew Morton wrote:
> On Tue, 10 Jul 2012 00:54:54 +0200
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> 
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

well, there is this bug

> 
> > So, my question now: Would you accept the pcmcia patch if I add the
> > "USB: Don't rebind..." as a reference to why the re-add needs to be
> > done in complete? Or do you think that I should bug the pm people
> > (and Alan - since he wrote that it is "not allowed") in this case
> > so I can link their official answer to this patch?
> 
> Well I could grab it and give it a little bit of testing in linux-next.
> But I'd be super-reluctant to send such a patch upstream without
> detailed input from Alan/Greg/Rafael/Dominik/etc.
> 
> 
