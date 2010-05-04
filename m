Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab0EDSGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:06:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34823 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0EDSGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:06:45 -0400
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev?= =?iso-8859-1?Q?=E5g?= 
	<arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<87wrvl5479.fsf@deeprootsystems.com>
	<20100503180741.GB2098@rakim.wolfsonmicro.main>
	<201005032318.35383.rjw@sisk.pl> <87sk68r1zh.fsf@deeprootsystems.com>
	<s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com>
	<w2pa55d774e1005031743x859e82fz401346fae7fe873a@mail.gmail.com>
	<20100504135907.GA3651@opensource.wolfsonmicro.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 04 May 2010 11:06:39 -0700
In-Reply-To: <20100504135907.GA3651@opensource.wolfsonmicro.com> (Mark Brown's message of "Tue\, 4 May 2010 14\:59\:07 +0100")
Message-ID: <87r5lrh780.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> On Mon, May 03, 2010 at 05:43:34PM -0700, Brian Swetland wrote:
>> On Mon, May 3, 2010 at 5:09 PM, Arve Hjønnevåg <arve@android.com> wrote:
>> > On Mon, May 3, 2010 at 4:37 PM, Kevin Hilman
>
>> >> This last point is especially troubling.  I don't find it a comforting
>> >> path to go down if the drivers have to start caring about which PM
>> >> policy is currently in use.
>
>> I'll echo Arve here -- all drivers should seek to be in the lowest
>> power state possible at all times.  We've never suggested that
>> suspend_block is a substitute for that.
>
> Looking at this from a subsystem/driver author point of view the problem
> I'm faced with is that as a result of using system suspend much more
> aggressively the subsystem and driver layers are getting conflicting
> instructions about what the lowest power state possible is.

Exactly.

With runtime PM, there is flexibility in choosing the lowest power
state at the device/subsystem level, based on activity, timeouts,
bitrate, dependencies, latency/throughput constraints, etc.

With opportunistic suspend, all of this flexibility is gone, and the
device/subsystem is told to go into the lowest power, highest latency
state, period.

>> Suspend blockers give us some flexibility on systems where runtime pm
>> will not get us all the way there. If you can meet your power needs
>> without needing suspend blockers, awesome, you don't need them on that
>> platform.  The patchset Arve sent out makes this feature an
>> off-by-default kernel configuration option that compiles out to no-ops
>> when disabled.
>
> I think a big part of this for me is that this approach changes the
> intended use of the system-wide suspend a bit, complicating it a bit
> further than it already is.  We end up doing a suspend (which in the
> normal course of affairs means that the driver should shut everything
> down) partly as a substitute for runtime PM on the core system devices
> and partly because our runtime PM isn't doing as well as it should on
> the individual devices.

Agreed, and because of this, part of my concern is that opportunistic
suspend will take the place of doing the "right thing" which (IMHO) 
would be to improve runtime PM for devices.

> I'd be a lot more comfortable with this if it came with a mechanism for
> communicating the intended effect of a suspend on a per-device level so
> that the drivers have a clear way of figuring out what to do when the
> system suspends.  If there isn't one we can add subsystem or driver
> specific hooks, of course, but it'd be better to address this at the
> system level.

I agree.

I think there needs to be more discussion on the indended usage
of suspend blockers by drivers/subsystems, especially those PM aware
drivers and subsystems already doing runtime PM with constraints etc.

>> In our experience, periodic timers and polling, both userspace side
>> and kernelside make suspend blockers a win even on platforms like OMAP
>> which have pretty flexible hardware power management.  Going to low
>> power states in idle results in higher average power consumption than
>> going to the same states in full suspend, at least on Android devices
>> shipping today.
>
> There's definite work to be done here, yes.

And I've admitted this to be the only compelling reason for
opportunistic suspend so far.

But the driver/subsystem implications of opportunistic suspend still
need some fleshing out IMO.

Kevin
