Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0DUGkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:40:06 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:39336 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0DUGkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EvM1jM8AZ4naDJbg8pkSvreNCpgPFoNjNbvWaeGJzb7N3CYHP7aI+QryGD7vgCXR+C
         ScASNYdIRp0b6KfCc+UJwQ7AEWRLG416Ts0X9TtYebO8sizk+Se64FdkyhrIxK1c4l++
         Dxh4ENJjaGKIzEVRzZF3Fk47CW5vgDFTG9Nk0=
Date: Tue, 20 Apr 2010 23:39:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] input: Add LED support to Synaptics device
Message-ID: <20100421063954.GK4364@core.coreip.homeip.net>
References: <1271257823-23566-1-git-send-email-tiwai@suse.de>
 <1271257823-23566-3-git-send-email-tiwai@suse.de>
 <20100415191217.GA1495@ucw.cz>
 <s5hy6gnu8rv.wl%tiwai@suse.de>
 <s5hiq7npvrb.wl%tiwai@suse.de>
 <20100421054303.GC4364@core.coreip.homeip.net>
 <s5hbpddz58s.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbpddz58s.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 08:31:15AM +0200, Takashi Iwai wrote:
> At Tue, 20 Apr 2010 22:43:03 -0700,
> Dmitry Torokhov wrote:
> > 
> > On Mon, Apr 19, 2010 at 12:44:08PM +0200, Takashi Iwai wrote:
> > > At Fri, 16 Apr 2010 10:00:20 +0200,
> > > I wrote:
> > > > 
> > > > At Thu, 15 Apr 2010 21:12:18 +0200,
> > > > Pavel Machek wrote:
> > > > > 
> > > > > Hi!
> > > > > 
> > > > > > The new Synaptics devices have an LED on the top-left corner.
> > > > > > This is controlled via the command 0x0a with parameters 0x88 or 0x10.
> > > > > > 
> > > > > > The detection of the LED isn't clear yet.  It should have been the new
> > > > > > capability bits that indicate the presence, but on real machines, it
> > > > > > doesn't fit.  So, for the time being, the driver checks the product id
> > > > > > in the ext capability bits and assumes that LED exists on the known
> > > > > > devices.
> > > > > > 
> > > > > > The support of LED is controlled via a normal input event with EV_LED
> > > > > > bit mask.  It supports LED_MUTE bit.  X driver can detect the LED
> > > > > > support by checking these bits.
> > > > > 
> > > > > Could we use generic LED API for this?
> > > > 
> > > > Yeah, actually I started implementing with LED ADI at first.
> > > > 
> > > > But, then it turned out to be that it's much easier to use the
> > > > existing LED input bits since this LED is really tightly coupled with
> > > > the synaptics input device.  An individual LED device makes hard to
> > > > find out the corresponding input device.
> > > > 
> > > > If we assume there is only one synaptics and only one synaptics-LED
> > > > device, then yes, the situation can be a bit easier, though.
> > > > 
> > > > > It is not really 'mute' led after all...
> > > > 
> > > > If the problem is the misuse of LED_MUTE bit, how about adding a new
> > > > LED bit, e.g. LED_TOUCHPAD?
> > > 
> > > The revised patch with an addition of LED_TOUCHPAD is below.
> > > 
> > 
> > Sorry Takashi, but I will not add any new LED types to input. Even
> > current input LEDs are going to be accessible thought standard LED
> > framework (even though I have not apploed Samuel's patch yet I do think
> > it would move kernel in the right direction).
> 
> Hrm, OK, we can live in other way, too.  For touchpad, it wouldn't be
> a big problem because it's likely a single device.
> 
> But, how can we link a led class device and another device, in
> general?

I think this question is to Richard, I am a bit fuzzy on LED subsystem.
But in general I'd expect LED have touchpad input device as parent.

> 
> Also, another remaining question is the lifetime of led device.
> The mouse device tends to be re-assigned often, e.g. at each time you
> suspend/hibernate.

We go to a great lengths to properly resume the device keeping the same
input_dev structure and the same event node (for historical reasons
really, nowadays X is hotplug aware so we could do without), do you see
it being recreated often?

>  Should led device also be removed and revived at
> each time, or should we keep it and just ignore event?  If we remove
> it, how can we avoid race?

I am not sure what race you see - psmouse protocol switch should not
race so if you remove LED there you shoudl be race-free. If you see
something racing I am definitely interested in hearing about it.

Thanks!

-- 
Dmitry
