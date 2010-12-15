Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0LOMKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:10:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0LOMKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=j+FQHCSDqvp1TkesTjeOOoGyAJnnU+3Q4CeuhNfpD6euyQLsFzS89qkc4bTFGqlYI1
         tn8GXjYAO7GavhP4CiMQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimUiPVrJ8KY1Tj_qGJmDbSmy3BUuudeAWeQ88Fc@mail.gmail.com>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <4CF5C379.8030204@google.com>
 <1291184173.7466.147.camel@marge.simson.net> <4CF87C14.8000708@google.com>
 <AANLkTimmZE0QROje3vLKJOa+uVFfNqiGNF_MJ9vt9xHW@mail.gmail.com>
 <AANLkTikPwXjNixYg+Wc=hrfPzpy7uygQ+zmYUKYAcrkd@mail.gmail.com> <AANLkTimUiPVrJ8KY1Tj_qGJmDbSmy3BUuudeAWeQ88Fc@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 15 Dec 2010 04:10:08 -0800
Message-ID: <AANLkTikdNe4mhx8E0J1C9vcOu4cdmr8KAMnAvrJeWzGq@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This goose is now cooked.

It turns out the new shares code is doing the "right" thing, but in
the wrong order for tasks with very small time slices.  This made it
rather gnarly to track down since at all times the new evaluation /
the old evaluation / and an "OPT" evaluation were all in agreement!

As we hierarchically dequeue we now instantaneously adjust entity
weights to account for the new global state (good).  However, when we
then update on the parent (e.g. the group entity owning the
just-adjusted cfs_rq), the accrued unaccounted time is charged at the
new weight for that entity instead of the old.

For longer running processes, the periodic updates hide this.
However, for an interactive process, such as Xorg (which uses many
_small_ timeslices -- e.g. almost all accounting ends up being at
dequeue as opposed to periodic) this results in significant vruntime
over-charging and a loss of fairness.  In Xorg's case the loss of
fairness is compounded by the fact that there is only one runnable
thread means we transition between NICE_0_LOAD and MIN_SHARES for the
over-charging above.

This is fixed by charging the unaccounted time versus a group entity
before we manipulate its weight (as a result of child movement).

Thanks for your patience while I tracked this down.. it's been a few
sleepless nights while I cranked through a number of dead-end theories
(rather frustrating when the numbers are all right but the results are
all wrong! ;).  Cleaned up patch inbound in the morning.

- Paul

On Tue, Dec 7, 2010 at 3:32 AM, Paul Turner <pjt@google.com> wrote:
> Desktop hardware came in today and I can now reproduce the issues
> Mike's been seeing; tuning in progress.
>
> On Sat, Dec 4, 2010 at 9:11 PM, Paul Turner <pjt@google.com> wrote:
>> On Sat, Dec 4, 2010 at 3:55 PM, James Courtier-Dutton
>> <james.dutton@gmail.com> wrote:
>>> On 3 December 2010 05:11, Paul Turner <pjt@google.com> wrote:
>>>>
>>>> I actually don't have a desktop setup handy to test "interactivity" (sad but
>>>> true -- working on grabbing one).  But it looks better on under synthetic
>>>> load.
>>>>
>>>
>>> What tools are actually used to test "interactivity" ?
>>> I posted a tool to the list some time ago, but I don't think anyone noticed.
>>> My tool is very simple.
>>> When you hold a key down, it should repeat. It should repeat at a
>>> constant predictable interval.
>>> So, my tool just waits for key presses and times when each one occurred.
>>> The tester simply presses a key and holds it down.
>>> If the time between each key press is constant, it indicates good
>>> "interactivity". If the time between each key press varies a lot, it
>>> indicates bad "interactivity".
>>> You can reliably test if one kernel is better than the next using
>>> actual measurable figures.
>>>
>>> Kind Regards
>>>
>>> James
>>>
>>
>> Could you drop me a pointer?  I can certainly give it a try.  It would
>> be extra useful if it included any histogram functionality.
>>
>> I've been using a combination of various synthetic wakeup and load
>> scripts and measuring the received bandwidth / wakeup latency.
>>
>> They have not succeeded in reproducing the starvation or poor latency
>> observed by Mike above however.  (Although I've pulled a box to try
>> reproducing his exact conditions [ e.g. user environment ] on Monday).
>>
>
