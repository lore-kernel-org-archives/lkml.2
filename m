Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab0EXFCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:02:44 -0400
Received: from leo.clearchain.com ([199.73.29.74]:47129 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0EXFCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:02:42 -0400
Date: Mon, 24 May 2010 14:58:55 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100524045855.GC16369@barra>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
 <20100519023727.GA21030@barra.bne.redhat.com>
 <4BF3D59E.1070801@euromail.se>
 <20100520001323.GA28116@barra.bne.redhat.com>
 <4BF51188.3090608@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF51188.3090608@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Mon, 24 May 2010 14:31:51 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:40:08PM +0200, Henrik Rydberg wrote:
> Peter Hutterer wrote:
> [...]
> >>> Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
> >>> in advance if a device may use slots or not?
> >> Eventually, this might become true, but you are pointing at one of the weaker
> >> points of the current setup. There is no bit field for the EV_SYN events, so
> >> there is no way to know in advance if SYN_MT_SYNC or SYN_MT_SLOT is used. This
> >> could quite possibly be added to the EVIO interface. Meanwhile, the method I use
> >> is to detect the first SYN_MT_SLOT and select parser based on that information.
> > 
> > I'd really prefer if there was some way to detect this. While I'm not quite
> > sure how the matching X drivers would look like it's likely that the setups
> > will be different for drivers that support slots and those that don't.
> > e.g. those that don't have slots simply send events as valuators, those that
> > do may split into multiple devices.
> > 
> > Doing this at runtime - after the device has been set up is...tricky.
> 
> Changing SYN_MT_SLOT to ABS_MT_SLOT will take care of this.
> 
> >> If you are thinking of a setup where one program is already hooked up to the
> >> device, and a new one comes in just as the message in question appears on the
> >> wire, it just means the new program will have to spend some time catching up. If
> >> this should ever become a problem, one could possibly add a send-full-state
> >> method to the input layer, to be issued when the new program opens the device. I
> >> doubt this will be needed in practice though, since contacts change all the time.
> > 
> > This was the case I was wondering about. While I agree with the last part
> > (contacts change all the time) the side-effect that you'll get from this is
> > that devices can seemingly be non-responsive for random periods of time.
> > 
> > If you have a finger down when the X server starts or after a VT switch (or
> > even a fast user switch), the driver will have to drop events. So you can
> > wriggle your finger around and nothing happens, but once you lift it goes
> > "well, now it works again". Since this happens only once in a while, it can
> > make the whole lot appear flaky.  Especially if one finger works and the
> > other one doesn't.
> >
> > So I guess it comes down to whether sending SYN_MT_SLOT with every event
> > costs too much compared to these admittedly rare use-cases. They're not much
> > different to the current button events either, if you weren't there when a
> > button was pressed you won't know. So I'm somewhat indifferent about this
> > bit.
> 
> Yes, it is a inherent property of the input protocol between the kernel and user
> space. A different problem, in other words.
> 
> > And yes, you could add it once we find it's an issue, but by then someone
> > has already spent time to work around this. And when you then start sending
> > slot events all the time, you admit that writing the workaround was just a
> > time waster :)
> 
> Work around what, exactly?

I was referring to having a protocol where processes has to ignore contacts
already down until they've been there when a contact was pressed (and your
comment that if this becomes an issue it could be added lateron). 
Now, the ignoring part needs to be written (this is the "workaround"
referred to above). if you're planning to add it later, we need to cater for
that part as well then, having two implementations depending on the kernel
versions.

but this is just for clarification, it's a moot point anyway given that
button events have the same behaviour. so, nevermind, I think we can just
ignore it and get on with life.

Cheers,
  Peter

> >> As a side note, the notion of a used slot depends on how the attributes of the
> >> slot are interpreted. The method described in the document treats an
> >> ABS_MT_TRACKING_ID value outside of the driver-specified value range as an
> >> unused slot.
> > 
> > It's easier for a latecomer to guess a tracking ID since you can just
> > assign any random value to it, provided the kernel guarantees to only send
> > updates on the tracking ID for changes. This doesn't quite work for slots.
> > 
> > But I'm not sure what your last sentence means. Does this mean the kernel
> > will open a new slot for out-of-range tracking IDs? I'm missing something
> > here.
> 
> I am referring to the notion of create-move-destroy from earlier discussions,
> and the question of how it is implemented using slots. The document is a bit
> unclear on this point, so I will add a note stating something like this:
> 
> * Every slot with a tracking id within the value range represents a contact.
> 
> * Tracking ids not previously present are considered new.
> 
> * Tracking ids no longer present are considered removed.
> 
> Cheers,
> Henrik
> 
