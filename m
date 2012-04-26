Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2DZDGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 23:06:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60255 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DZDGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 23:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120426065803.59b96cb3@notabene.brown>
References: <20120425122139.512c6890@notabene.brown>
	<20120425050919.GB27843@core.coreip.homeip.net>
	<20120425152603.3d24547f@notabene.brown>
	<1335372965.1571.15.camel@anish-Inspiron-N5050>
	<20120426065803.59b96cb3@notabene.brown>
Date: Thu, 26 Apr 2012 08:36:12 +0530
Message-ID: <CAK7N6voY+8NkB_T0V82M22CMx5Zz693u_t=U3nvKdtma4eY+Pg@mail.gmail.com>
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on resume
From: anish singh <anish198519851985@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 2:28 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 25 Apr 2012 22:26:05 +0530 anish kumar <anish198519851985@gmail.com>
> wrote:
>
>> On Wed, 2012-04-25 at 15:26 +1000, NeilBrown wrote:
>> > On Tue, 24 Apr 2012 22:09:19 -0700 Dmitry Torokhov
>> > <dmitry.torokhov@gmail.com> wrote:
>> >
>> > > Hi Neil,
>> > >
>> > > On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
>> > > >
>> > > > If we press and release the power button before the press interrupt is
>> > > > handled - as can happen on resume - we lose the press event so the
>> > > > release event is ignored and we don't know what happened to cause the
>> > > > wakeup.
>> I didn't understand this.If power button is waking up the device then
>> obviously power button interrupt handler is called right?If yes then how
>> can we lose the press event?Is user space not ready to take the event?
>> May be I didn't understand it properly.Can you kindly explain?
>
> Yes, the interrupt handler is running.
>
> However the way the driver is currently written, an interrupt is not enough
> to generate an "button press" event.
> What happens is when the kernel-thread half of the interrupt handler finally
> runs, it samples the state of the button and generates an event based on that
> level.  So if the button has been released again by the time the ISR runs,
> then only a "button release" event is generated.
>
> When this gets to the input layer, the input later *knows* that the button is
> currently released so it suppresses the new "button release" event.
> A "sync" event does still get through to the App, but they can come at all
> sorts of time even when nothing is happening to the button, so they are best
> ignored (when by themselves).
>
> What the driver needs to do is acknowledge that just getting an interrupt
> means  that something changed, and to ensure that a change gets passed up to
> the input layer.
>
> Is that clearer?
Perfect explanation.Thanks a ton.
>
> Thanks,
> NeilBrown
>
>
>> > >
>> > > What kind of latency do you observe?
>> >
>> > When I have debugging enabled, hundreds of milliseconds.
>> >
>> > When I don't have debugging enabled ... it doesn't tell me, but I'm fairly
>> > sure it is several tens of milliseconds and the button press can be quicker
>> > than that.
>> >
>> > If it will help I can try to instrument the driver and get some timings.
>> >
>> > >
>> > > >
>> > > > So make sure that each interrupt handled does generate an event.
>> > > > Because twl4030 queues interrupt events we will see two interrupts
>> > > > for a press-release even if we handle the first one later.  This means
>> > > > that such a sequence will be reported as two button presses.  This
>> > > > is unfortunate but is better than no button presses.
>> > > > Possibly we could set the PENDDIS_MASK to disable queuing of
>> > > > interrupts, but that might adversely affect other interrupt sources.
>> > > >
>> > >
>> > > It looks like we'd have to modify every driver to ensure consistent
>> > > behavior as we do not have any guarantees on how long resume takes.
>> > > Maybe this is something that input core needs to implement?
>> >
>> > Well if every driver is buggy....
>> >
>> > I don't see how this could be implemented in the input core.  And even if it
>> > was, you'd probably need to change each driver to interact with this new
>> > functionality which would be much the same work as changing them to work with
>> > the current functionality....
>> > But maybe I have no imagination - if you can suggest a way that the input core
>> > could support this without changing the drivers, I'm happy to try it out.
>> >
>> > Thanks,
>> > NeilBrown
>>
>
