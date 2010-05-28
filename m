Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0E1PNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:13:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0E1PNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:13:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=sOzo1/sy8YUZsBZB8Tw1z+fwtJIN7JkyL8nXB51znD+RbaoS6GAhp50gHG8oxAyKH
	/F0c0yFlSHT1VwvWWtLTA==
MIME-Version: 1.0
In-Reply-To: <20100528160628.7c121dab@lxorguk.ukuu.org.uk>
References: <20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<20100528133900.GG26177@thunk.org>
	<4BFFCFC7.7070302@nokia.com>
	<20100528142124.GA26733@srcf.ucam.org>
	<AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
	<20100528160628.7c121dab@lxorguk.ukuu.org.uk>
Date: Fri, 28 May 2010 08:13:08 -0700
Message-ID: <AANLkTin3suKfGBSfiDj0n8ztY8UiHzr4af_Cr0SPOevY@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Igor Stoppa <igor.stoppa@nokia.com>,
       tytso@mit.edu, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 8:06 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Arve points out that qos constraint objects could work (but not if
>> specifically tied to apps): http://lkml.org/lkml/2010/5/28/120 though
>> he suggests that "latency" constraints don't represent this as well as
>> "state" constraints.
>
> With latency you have an "I don't give damn" latency in your model which
> we could describe as infinite or "manyana" perhaps.

I think Arve's concern was the representation of the "I care, but only
a little" or "just low enough to ensure threads must run" level which
is what suspend blockers would map to (low enough to ensure we
shouldn't halt the world but not necessarily implying a hard latency
constraint beyond that).

>> Though if you look at it that way, then suspend_blockers become qos
>> constraint objects, but their implementation and usage remain pretty
>> much the same as we have now, which does not address Alan's concern
>> regarding code turning up in drivers, etc.  I'm not sure how you can
>> solve this problem (avoiding races around entering/exiting the suspend
>> or suspend-like state) without having a means for drivers to prevent
>> entry to that state.
>
> I am much much less concerned about general expressions of constraint
> appearing in drivers. One of my early mails gave a list of other
> people/projects/problems that need them - from hard real time, to high
> speed serial on low end embedded to virtualisation.
>
> They fix a general problem in terms of a driver specific item. We end up
> making changes around the tree but we make everyone happy not just
> Android. Also we are isolating policy properly. The apps and drivers say
> "I have these needs", the power manager figures out how to meet them.

That makes sense -- and as I've mentioned elsewhere, we're really not
super picky about naming -- if it turns out that
wakelocks/suspendblockers were shorthand for "request a qos constraint
that ensures that threads are running", we'll be able to get things
done just as well as we do now.

> Where it gets ugly is if you start trying to have drivers giving an app a
> guarantee which the app then magically has to know to dispose of.

Yeah -- which is something we've avoided in the existing model with
overlapping wakelocks during handoff between domains.
- input service is select()ing on input devices
- when select() returns it grabs a wakelock, reads events, passes them
on, releases the wakelock
- the event subsystem can then safely drop its "should be running
threads" constraint as soon as the last event is read because it has
no queues for userspace to drain, but the overlapping wakelock
prevents the system from immediately snapping back to sleep

> If you are prepared to exclude untrusted apps from perfectly reliable
> event reporting (ie from finger to application action) that doesn't seem
> to be a neccessity anyway.

Currently in the Android userpace only trusted (system) apps can
directly obtain wakelocks -- arbitrary apps obtain them via rpc to a
trusted system service (which ensures the app has been granted
permission to do this and tracks usage for accountability to
user/developer).

Brian
