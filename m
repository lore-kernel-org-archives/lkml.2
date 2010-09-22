Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0IVI4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:56:13 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0IVI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:56:12 -0400
Subject: Re: [RFC] led-class: always implement blinking
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1285104248.1290.551.camel@rex>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
	 <20100921124419.6b88f7f6.akpm@linux-foundation.org>
	 <1285098497.12764.18.camel@jlt3.sipsolutions.net>
	 <1285104248.1290.551.camel@rex>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 10:56:06 +0200
Message-ID: <1285145766.3684.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 22:24 +0100, Richard Purdie wrote:

> > Well, this function gets assigned to led_cdev->blink_set(), which is a
> > function pointer that takes pass-by-reference arguments. The comment
> > there says:
> > 
> >         /* Activate hardware accelerated blink, delays are in
> >          * miliseconds and if none is provided then a sensible default
> >          * should be chosen. The call can adjust the timings if it can't
> >          * match the values specified exactly. */
> >         int             (*blink_set)(struct led_classdev *led_cdev,
> >                                      unsigned long *delay_on,
> >                                      unsigned long *delay_off);
> > 
> > but the software implementation doesn't adjust the timings, of course. I
> > suppose the "adjust the timings" was also meant to update the values.
> 
> The idea was that hardware fallbacks would let the caller know what
> values it had actually fallen back to. The software fallback using
> timers is generic so doesn't need to change the values.
> 
> I've been meaning to look more closely at the patch but I haven't got to
> it yet, sorry :(.

Right. But I actually ran into problems here. I had to add another
"blink_stop" software function, because even though the _internal_ code
in led-class.c currently assumes calling blink_set(0, 0) will stop
blinking, the documentation says that then it should chose a
"user-friendly" blinking speed... So there are bugs in the current
implementation, and not all LEDs implement this either.

Additionally, blink_set() may return an error, in which case software
fallback should be used.

I solved this yesterday in a new version of my patch by adding new API

void led_classdev_blink_set(*dev, *on, *off)

that will use blink_set() and then fall back to software.

HOWEVER, if you use that, then just doing brightness_set(dev, LED_OFF)
will not turn off blinking because we cannot hook into that from the
software blinking implementation. There are two ways to solve this:

a) provide a wrapper for brightness_set() as well, that will disable
   software blink, and should be used in preference of calling the
   function pointer directly, it may be an inline.

b) provide a function led_classdev_blink_stop() that will turn off the
   LED and stop the blinking

Which one would you prefer?

johannes

