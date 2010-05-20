Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0ETKkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:40:35 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60483 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab0ETKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:40:33 -0400
Message-ID: <4BF51188.3090608@euromail.se>
Date: Thu, 20 May 2010 12:40:08 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se> <1274213429-22667-2-git-send-email-rydberg@euromail.se> <20100519023727.GA21030@barra.bne.redhat.com> <4BF3D59E.1070801@euromail.se> <20100520001323.GA28116@barra.bne.redhat.com>
In-Reply-To: <20100520001323.GA28116@barra.bne.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1OF3Am-0001Ew-AA.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OF3Am-0001Ew-AA 8c8edc1c7702ba6a23ef41cb7b5eb9a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hutterer wrote:
[...]
>>> Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
>>> in advance if a device may use slots or not?
>> Eventually, this might become true, but you are pointing at one of the weaker
>> points of the current setup. There is no bit field for the EV_SYN events, so
>> there is no way to know in advance if SYN_MT_SYNC or SYN_MT_SLOT is used. This
>> could quite possibly be added to the EVIO interface. Meanwhile, the method I use
>> is to detect the first SYN_MT_SLOT and select parser based on that information.
> 
> I'd really prefer if there was some way to detect this. While I'm not quite
> sure how the matching X drivers would look like it's likely that the setups
> will be different for drivers that support slots and those that don't.
> e.g. those that don't have slots simply send events as valuators, those that
> do may split into multiple devices.
> 
> Doing this at runtime - after the device has been set up is...tricky.

Changing SYN_MT_SLOT to ABS_MT_SLOT will take care of this.

>> If you are thinking of a setup where one program is already hooked up to the
>> device, and a new one comes in just as the message in question appears on the
>> wire, it just means the new program will have to spend some time catching up. If
>> this should ever become a problem, one could possibly add a send-full-state
>> method to the input layer, to be issued when the new program opens the device. I
>> doubt this will be needed in practice though, since contacts change all the time.
> 
> This was the case I was wondering about. While I agree with the last part
> (contacts change all the time) the side-effect that you'll get from this is
> that devices can seemingly be non-responsive for random periods of time.
> 
> If you have a finger down when the X server starts or after a VT switch (or
> even a fast user switch), the driver will have to drop events. So you can
> wriggle your finger around and nothing happens, but once you lift it goes
> "well, now it works again". Since this happens only once in a while, it can
> make the whole lot appear flaky.  Especially if one finger works and the
> other one doesn't.
>
> So I guess it comes down to whether sending SYN_MT_SLOT with every event
> costs too much compared to these admittedly rare use-cases. They're not much
> different to the current button events either, if you weren't there when a
> button was pressed you won't know. So I'm somewhat indifferent about this
> bit.

Yes, it is a inherent property of the input protocol between the kernel and user
space. A different problem, in other words.

> And yes, you could add it once we find it's an issue, but by then someone
> has already spent time to work around this. And when you then start sending
> slot events all the time, you admit that writing the workaround was just a
> time waster :)

Work around what, exactly?

>> As a side note, the notion of a used slot depends on how the attributes of the
>> slot are interpreted. The method described in the document treats an
>> ABS_MT_TRACKING_ID value outside of the driver-specified value range as an
>> unused slot.
> 
> It's easier for a latecomer to guess a tracking ID since you can just
> assign any random value to it, provided the kernel guarantees to only send
> updates on the tracking ID for changes. This doesn't quite work for slots.
> 
> But I'm not sure what your last sentence means. Does this mean the kernel
> will open a new slot for out-of-range tracking IDs? I'm missing something
> here.

I am referring to the notion of create-move-destroy from earlier discussions,
and the question of how it is implemented using slots. The document is a bit
unclear on this point, so I will add a note stating something like this:

* Every slot with a tracking id within the value range represents a contact.

* Tracking ids not previously present are considered new.

* Tracking ids no longer present are considered removed.

Cheers,
Henrik

