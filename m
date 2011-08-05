Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1HERMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:12:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1HERMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:12:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tzyDz/yAX3NoiMgMxH7lnE+Pgyrf9ZbRcEhdUVgnDqG7Tn1Mzd7tUgdVjV62FUde6
	KPQRYlobXKBVtR3958k3A==
MIME-Version: 1.0
In-Reply-To: <20110805134042.GJ1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
	<1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
	<20110805134042.GJ1972@redhat.com>
Date: Fri, 5 Aug 2011 10:12:15 -0700
X-Google-Sender-Auth: 45crTSdbp43q0Th9l3OLwjFSATU
Message-ID: <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 6:40 AM, Don Zickus <dzickus@redhat.com> wrote:
> I'll have to play with a little bit, but I was wondering what happens when
> you have multiple stack traces coming in.  Before when it was printing to
> the console, it was probably a bit of professional courtesy to keep the
> warnings to a minimum.  But if you are going to use the proc fs, we can
> probably be a little noisier.  So I had two questions
>
> If you don't get to the proc fs fast enough, are you overwriting the
> shorter stall stack trace with a slightly longer stall stack trace.  It
> seems the
>
>> +                     hardstall_trace.nr_entries = 0;
>
> would reset things and you would lose the original worst_stall.
>
> Do we want to increment the worst stall time now?  Shouldn't we just stay
> at the current threshold and continue to print the same stack trace?  To
> me that is the definition of 'worst stall'.  This might contradict
> something I said earlier, I don't know (if it does I apologize).  Instead
> if someone wants to 'skip' that 'worst stall' they can possibly just
> increment the threshold?
I don't understand your notion of "worst." If there is a stall and a
slightly longer stall, then the longer one is the worst one.

I do see what you're saying about affording more noise. If we do what
you're saying (if I understand correctly), then the "worst" will not
really be the worst at all, but instead a purely user-tunable
threshold. The way the code is now, the user can already set their own
threshold, but the threshold will also adjust itself automatically.
The question becomes, "what is the best use case to support by
default?" For example, if a system is allowed to operate for a while
and then the user goes to check the stalls, then if we can only tell
them about one stall, the most informative one is probably the worst
one that happened during that period of operation. Based on your
suggestion, what they would be shown instead is the most recent stall.
After checking the stalls, the user can reset the worst/threshold to 0
or whatever else they would like and then check again later after
another while.

If the user is willing to micromanage these settings and basically
react to every stall, then they would benefit most from the threshold
never automatically adjusting itself. However, if they only check once
in a while, perhaps not even in response to any particular event, then
they could be better off if the kernel did some simple filtering on
its own and gave them back the most "interesting" piece of
information.

> Or another idea I just had (it adds work to this), perhaps create a sample
> frequency for the lockup timers.  What I mean by that is, currently the
> timer fires 5 times (or 2.5 for hardlockups) before the NMI triggers.  We
> could create a knob that allows us to sample at 10 or 20 or whatever.
> Then next time the hrtimer goes off it would just reload the new
> frequency.
>
> This would allow better resolution on the worst stall I believe, but it
> invovles more knobs now. So the knobs would look like
>
> watchdog_thresh - length of time before NMI fires (currently 10)
> watchdog_sample_freq - number of times hrtimer fires before NMI fires
>                        (currently 5, well 2.5)
> watchdog_worst_stall_hard - number of sample_freq before printing warning
>                                (currently 2 I think)
>
>
> Because you converted to ms resolution, it is easier to divide the
> frequency up.  Of course if you increase the sample frequency, you would
> probably have to increase the worst stall number too.
>
> The downside is the power management folks would whine that it drains
> laptop batteries.  But Matthew Garret sits a few cubes down from me, so I
> can probably have him help me hook into the idle thread to quiesce the
> timers.
>
> Thoughts?
Sounds useful. Doing this stuff excessively may waste not only power
but maybe even CPU time? Anyway, nothing wrong with making it
adjustable, as far as I can tell. However, I'd like it if at least the
basic foundation could get accepted soon, if only so I can pull it
down to Chromium OS ASAP.

> This lock is defined locally, I don't think that is what you want.  Locks
> need to be a shared variable.  You might want to use a mutex here so it
> can sleep in case the stack trace is long.  It is only called from the
> user context I believe so it should be fine.
Doesn't it just use one of the locks defined at the top of the file?
This lock protects the stack trace data structure, so it's not read
and written at once. This also means it is taken up by the kernel
during interrupts.

> Where do these get created?  Under /proc?  I don't think that will be
> allowed.  I would think this is a debug feature and we should create
> something under /sys/kernel/debug like lockup_detector and stick these files in
> there.
Okay, and I suppose I'll shove the *stall_worst files into the same
place (currently they're in /proc/sys/kernel/).
