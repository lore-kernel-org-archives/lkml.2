Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab0FBW1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:27:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46387 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777Ab0FBW13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1275511271.2799.516.camel@mulgrave.site>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<1275451342.21962.1777.camel@mulgrave.site>
	<AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	<1275491111.2799.110.camel@mulgrave.site>
	<20100602214748.7742e3ae@schatten.dmk.lab>
	<1275511271.2799.516.camel@mulgrave.site>
Date: Wed, 2 Jun 2010 15:27:28 -0700
Message-ID: <AANLkTikeHarkwvO5-Fdrxt1FzTQL2lGHiQXBSG0vsKob@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       tytso@mit.edu, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, mark.gross@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 1:41 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> On Wed, 2010-06-02 at 21:47 +0200, Florian Mickler wrote:
>> On Wed, 02 Jun 2010 10:05:11 -0500
>> James Bottomley <James.Bottomley@suse.de> wrote:
>>
>> > On Tue, 2010-06-01 at 21:41 -0700, Arve Hjønnevåg wrote:
>> > > No, they have to be two separate constraints, otherwise a constraint
>> > > to block suspend would override a constraint to block a low power idle
>> > > mode or the other way around.
>> >
>> > Depends.  If you block the system from going into low power idle, does
>> > that mean you still want it to be fully suspended?
>> >
>> > If yes, then we do have independent constraints.  If not, they have a
>> > hierarchy:
>> >
>> >       * Fully Interactive (no low power idle or suspend)
>> >       * Partially Interactive (may go into low power idle but not
>> >         suspend)
>> >       * None (may go into low power idle or suspend)
>> >
>> > Which is expressable as a ternary constraint.
>> >
>> > James
>> >
>>
>> But unblocking suspend at the moment is independent to getting idle.
>> If you have the requirement to stay in the highest-idle level (i.e.
>> best latency you can get) that does not (currently) mean, that you can
>> not suspend.
>
> I don't understand that as a reason.  If we looks at this a qos
> constraints, you're saying that the system may not drop into certain low
> power states because it might turn something off that's currently being
> used by a driver or a process.  Suspend is certainly the lowest state of
> that because it turns everything off, why would it be legal to drop into
> that?

Because the driver gets called on suspend which gives it a change to
stop using it.

>
> I also couldn't find this notion of separation of idleness power from
> suspend blocking in the original suspend block patch set ... if you can
> either tell me where it is, or give me an example of the separated use
> cases, I'd understand better.
>

The suspend block patchset only deals with suspend, not low power idle
modes. The original wakelock patchset had two wakelock types, idle and
suspend.

>> To preserve that explicit fall-through while still having working
>> run-time-powermanagement I think the qos-constraints need to be
>> separated.
>
> OK, as above, why?  or better yet, just give an example.
>

The i2c bus on the Nexus One is used by the other core to turn off the
power you our core when we enter the lowest power mode. This means
that we cannot enter that low power mode while the i2c bus is active,
so we block low power idle modes. At some point we also tries to block
suspend in this case, but this caused a lot of failed suspend attempts
since the frequency scaling code would try to ramp up while freezing
processes which in turn aborted the process freezing attempts.

>> <disclaimer: just from what I read>
>> Provided you can reach the same power state from idle, current suspend
>> could probably also be implemented by just the freezing part and a hint
>> to the idle-loop to provide accelerated fall-through to lowest power.
>> </disclaimer>
>>
>> At that point, you could probably merge the constraints.
>>
>> But the freezing part is also the hard part, isn't it? (I have no
>> idea. Thomas seems to think about cgroups for that and doing smth about the timers.)
>
> Um, well, as I said, I think using suspend from idle and freezer is
> longer term.  I think if we express the constraints as qos android can
> then use them to gate when to enter S3 .. which is functionally
> equivalent to suspend blockers.  And the vanilla kernel can use them to
> gate power states for the drivers in suspend from idle.
>
> James
>
>
>



-- 
Arve Hjønnevåg
