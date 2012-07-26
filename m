Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2GZPP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:15:29 -0400
Received: from science.horizon.com ([71.41.210.146]:16714 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349Ab2GZPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:15:26 -0400
Date: 26 Jul 2012 11:15:24 -0400
Message-ID: <20120726151524.17390.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dmitry.torokhov@gmail.com, linux@horizon.com
Subject: Re: [REPOST #3 PATCH v2] Input: atkbd - make repeat period more accurate.
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120725073940.GB15997@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response!  I'd been checking mailing list archive sites
to see if my submissions were making it out to the list.

>> In addition to a slightly inaccurate lookup table, the
>> old code would round up to the next repeat period.
>> E.g. to get a period of 9/60 = 0.15 seconds, you had to
>> ask for no more than 149 ms; if you asked for 150, it
>> would round up to 167.

> This works as intended - it was designed to never have faster than
> requested.

The old code didn't do *that* correctly, either.  If you asked for 370
or 470 ms, it would give you 366.66 or 466.66 ms, respectively.

I can amend the code to do the same, but this leads to some questions:

Should the reported values be rounded down so that setting the repeat
period to the reported value is always safe?  Or should it allow rounding
down by <= 0.5 ms, so that asking for 117 ms will give you 166.66
without complaint?

And what do you do if the requested delay or period is longer than can
be supported (1000 and 500 ms, respectively)?

Finally, is this rounding documented clearly anywhere?  I thought rounding
to nearest gave the least surprising results for someone using various
slightly-inaccurate lists of the repeatable keyboard rates.  Including,
particularly, the previous code's values.

>> Signed-off-by: George Spelvin <linux@horizon.com>

> I am sorry but I have to ask - is this your real name?

Well, it's meant to be an obvious pen name, but since I use it
consistently and live in a common-law country, it's a "real"
as any other.

>> One possible bug I observed in the code that calls this:
>> 
>> Users of the KDKBDREP ioctl seem to assume that it returns the actual
>> values set, but I'm not sure it really works that way; I don't think
>> the command to change the parameters makes its way through the event
>> queue and atkbd's schedule_delayed_work() to actually set dev->rep[]
>> to the rounded values before kbd_rate_helper returns them to userspace.
>> 
>> If desired, the fix that's most obvious to me would be to split this
>> function in two: perform the conversion to a command byte synchronously,
>> and only defer the actual ps2_command().

> Yes, I agree, this is a problem.

I was trying to start simple, since this is a separate issue,
but I could make an attempt at this fix, too.

The *big* problsm is what if there's a peripheral that actually requires
a USB transaction to set the rate before being able to determine what
the rounded rate to report is, it'll require a major overhaul of the
in-kernel interfaces.


Another thing that would be possible is supporting an arbitrary repeat
rate, as long as it's slower than the maximum autorepeat rate.  Just set
the hardware repeat slightly faster than the software repeat rate and
buffer the autorepeat reports until the correct software-repeat time.

I don't know if it's worth bothering, though.
