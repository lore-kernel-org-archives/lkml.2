Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0E1K61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:58:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59153 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932616Ab0E1K6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:58:24 -0400
Date: Fri, 28 May 2010 12:04:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528120445.245c7075@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	<20100527181433.GG3543@srcf.ucam.org>
	<20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
	<201005280110.17075.rjw@sisk.pl>
	<20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
	<AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a much harder question to answer that what we need to use
> opportunistic suspend. The question we ask is more like this: "Is all
> important work complete?". In the simplest case these can be the same,

I don't believe you can answer that question without telepathy and a
crystal ball.

The application doesn't know because it has no idea how to balance
conflicting resource demands or to infer the users requirements and
wishes. Most apps will misbehave anyway.

The OS doesn't know because it cannot tell what the app wants

So at best you have a heuristic.

> What happens if the user presses the button right before you set QoS
> of 'user apps' to  QS_NONE?

Read down a paragraph.

> To me it looks like this solution would result in this sequence which
> may ignore the button press:
>         Button pushed
>         Button driver sets QoS of app it wakes to QS_ABOVESUSPEND
>         Set QoS of 'user apps' to QS_NONE
> 
> 
> >        That would I think solve the reliable wakeup case although
> >        drivers raising a QoS parameter is a bit unusual in the kernel.
> >        That would at least however be specific to a few Android drivers
> >        and maybe a tiny amount of shared driver stuff so probably not
> >        unacceptable. (wake_up_pri(&queue, priority); isn't going to
> >        kill anyone is it - especially if it usually ignores the
> >        priority argument)
> 
> Why is "wake_up_pri(&queue, priority)" more acceptable than "suspend_block(..."?

We keep it kernel side
It expresses policy and wishes rather than enforcing a behaviour.

What for example does "suspend_block" mean on a virtual machine ?

I would prefer "priority" was some kind of resource constraint model
instead but I'm just trying to think how to be absolutely minimally
invasible at this point.

> What happens if the button press happend before this line:
> >        count2 = tasks to QS_NONE | QS_NOTCHANGED
> >        Screen off
> >                                        Button Press
> >                                        task to QS_ABOVESUSPEND
> >        count = tasks that are QS_NOTCHANGED to QS_NONE
> >
> >        if (count != count2) {
> >                Stuff happened ... rethink
> >        }
> >
> > That is still a bit weird and wonderful but all the logic is in the right
> > places. The special magic remains in the Android policy code and in the
> > kernel specifics for Android.
> >
> > Thoughts ?
> 
> I don't think it works. Also, it does not seem much less invasive than
> suspend blockers.

"I don't think it works" isn't that helpful. I don't think it works
because .. would help me a lot more.

I think it's a loss let invasive because you are not exposing a ton of
stuff to user space in general (just some private chit chat between a
couple of processes). I would prefer it didn't even do that but simply
used QoS guarantees. However I don't see a way to achieve that given your
intended QoS guarantees change according to actions like screen off.

Alan
