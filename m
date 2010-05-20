Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0ETARN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:17:13 -0400
Received: from leo.clearchain.com ([199.73.29.74]:56106 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0ETARM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:17:12 -0400
Date: Thu, 20 May 2010 10:13:24 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100520001323.GA28116@barra.bne.redhat.com>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
 <20100519023727.GA21030@barra.bne.redhat.com>
 <4BF3D59E.1070801@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3D59E.1070801@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 20 May 2010 09:46:21 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 02:12:14PM +0200, Henrik Rydberg wrote:
> Peter Hutterer wrote:
> > On Tue, May 18, 2010 at 10:10:29PM +0200, Henrik Rydberg wrote:
> >> This patch adds documentation for the SYN_MT_SLOT event and gives
> >> examples of how to use the event slot protocol.
> > 
> > thanks, this is really nice documentation! the approach seems good, though I
> > do have a few questions inline.
> > 
> [...]
> > 
> > Is there a limit on the number of slots?
> 
> The slots are dynamically allocated by the driver, so there is no practical
> limit. Each slot currently takes 44 bytes, and allocating a few kilobytes of
> kernel memory is not a problem.
> 
> > Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
> > in advance if a device may use slots or not?
> 
> Eventually, this might become true, but you are pointing at one of the weaker
> points of the current setup. There is no bit field for the EV_SYN events, so
> there is no way to know in advance if SYN_MT_SYNC or SYN_MT_SLOT is used. This
> could quite possibly be added to the EVIO interface. Meanwhile, the method I use
> is to detect the first SYN_MT_SLOT and select parser based on that information.

I'd really prefer if there was some way to detect this. While I'm not quite
sure how the matching X drivers would look like it's likely that the setups
will be different for drivers that support slots and those that don't.
e.g. those that don't have slots simply send events as valuators, those that
do may split into multiple devices.

Doing this at runtime - after the device has been set up is...tricky.

> >> +
> >> +Protocol Example B
> >> +------------------
> >> +
> >> +Here is what a minimal event sequence for a two-contact touch would look
> >> +like for a type B device:
> >> +
> >> +   SYN_MT_SLOT 0
> >> +   ABS_MT_TRACKING_ID 45
> >> +   ABS_MT_POSITION_X x[0]
> >> +   ABS_MT_POSITION_Y y[0]
> >> +   SYN_MT_SLOT 1
> >> +   ABS_MT_TRACKING_ID 46
> >> +   ABS_MT_POSITION_X x[1]
> >> +   ABS_MT_POSITION_Y y[1]
> >> +   SYN_REPORT
> >> +
> >> +Here is the sequence after moving contact 45 in the x direction:
> >> +
> >> +   SYN_MT_SLOT 0
> >> +   ABS_MT_POSITION_X x[0]
> >> +   SYN_REPORT
> >> +
> >> +Here is the sequence after lifting the contact in slot 0:
> >> +
> >> +   ABS_MT_TRACKING_ID 0
> >> +   SYN_REPORT
> >> +
> >> +The active slot is already 0, so the SYN_MT_SLOT is omitted.  The message
> >> +removes the association of slot 0 with contact 45, thereby destroying
> >> +contact 45 and freeing slot 0 to be reused for another contact.
> > 
> > I'm probably missing something here, but how would a process know which one
> > is the active slot if it didn't get the previous event?
> 
> I am assuming you are not talking about losing events in the stream, but simply
> what information is available at the point of parsing it. The parser (the X
> evdev driver for instance) keeps all attributes of all slots, plus a single
> variable saying what slot is currently active, i.e, being modified.
> 
> If you are thinking of a setup where one program is already hooked up to the
> device, and a new one comes in just as the message in question appears on the
> wire, it just means the new program will have to spend some time catching up. If
> this should ever become a problem, one could possibly add a send-full-state
> method to the input layer, to be issued when the new program opens the device. I
> doubt this will be needed in practice though, since contacts change all the time.

This was the case I was wondering about. While I agree with the last part
(contacts change all the time) the side-effect that you'll get from this is
that devices can seemingly be non-responsive for random periods of time.

If you have a finger down when the X server starts or after a VT switch (or
even a fast user switch), the driver will have to drop events. So you can
wriggle your finger around and nothing happens, but once you lift it goes
"well, now it works again". Since this happens only once in a while, it can
make the whole lot appear flaky.  Especially if one finger works and the
other one doesn't.

So I guess it comes down to whether sending SYN_MT_SLOT with every event
costs too much compared to these admittedly rare use-cases. They're not much
different to the current button events either, if you weren't there when a
button was pressed you won't know. So I'm somewhat indifferent about this
bit.

And yes, you could add it once we find it's an issue, but by then someone
has already spent time to work around this. And when you then start sending
slot events all the time, you admit that writing the workaround was just a
time waster :)

> As a side note, the notion of a used slot depends on how the attributes of the
> slot are interpreted. The method described in the document treats an
> ABS_MT_TRACKING_ID value outside of the driver-specified value range as an
> unused slot.

It's easier for a latecomer to guess a tracking ID since you can just
assign any random value to it, provided the kernel guarantees to only send
updates on the tracking ID for changes. This doesn't quite work for slots.

But I'm not sure what your last sentence means. Does this mean the kernel
will open a new slot for out-of-range tracking IDs? I'm missing something
here.

Cheers,
  Peter
