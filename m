Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1G3EQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:16:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1G3EQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:16:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=mhFWUPjucOpw7frYovEuKoFPiqq8YGdlMqsqqFMKIl6VenvcHlEMmncD2L+eTW9yB
	PKdUVSJbCsReQ9S4gSZmw==
MIME-Version: 1.0
In-Reply-To: <1311993799.21143.120.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1311721194-12164-5-git-send-email-vnagarnaik@google.com> <1311974602.21143.92.camel@gandalf.stny.rr.com>
 <CAL26m8K8_55r_KZ9hc1ZPxvFTnnRzmjB0RH62OUB=Be0FjpcjQ@mail.gmail.com>
 <1311988337.21143.107.camel@gandalf.stny.rr.com> <CAJL_ektBTtVp==CbjLMaeO3Tz24=KmE50Qy+St0yc9dvYzuQFw@mail.gmail.com>
 <1311993799.21143.120.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Fri, 29 Jul 2011 20:44:51 -0700
Message-ID: <CAJL_eksbJTkD61SRwGQQBHE03aTDQDrWXyb9WeWQzm-3rUrqaA@mail.gmail.com>
Subject: Re: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 7:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-07-29 at 18:50 -0700, David Sharp wrote:
>> On Fri, Jul 29, 2011 at 6:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Fri, 2011-07-29 at 16:30 -0700, Vaibhav Nagarnaik wrote:

>> What is it that you don't like? the work/completion, the reliance on
>> running on the same cpu, or just the complexity of procedure?
>
> The added complexity. This is complex enough, we don't need to make it
> more so.

Sure, complexity should be part of the cost-benefit analysis. I think
this will be a pretty powerful feature, though. Let's see how it goes;
maybe Vaibhav and I can come up with something simpler, or using
established protocols.

>> > Anyway, the choices are:
>> >
>> > * Remove from the HEAD and use the existing algorithm that we've been
>> > using since 2008. This requires a bit of accounting on the reader side,
>> > but nothing too complex.
>> >
>> > Pros: Should not have any major race conditions. Requires no
>> > schedule_work_on() calls. Uses existing algorithm
>> >
>> > Cons: Can keep pages around if no reader is present, and ring buffer is
>> > not reset.
>>
>> Con: by definition, removes valid trace data from the ring buffer,
>> even if it is not full. I think that's a pretty big con for the
>> usability of the feature.
>
> Um, how does it remove valid trace data? We don't free it, we off load
> it. Think of it as "extended reader pages". That is, they are held off
> until the user asks to read these pages. Then they will get the data
> again. What is a con about that?

I think we're talking about different things. You're talking about
keeping the "removed" pages around for the reader if it wants it,
whereas I'm talking about trying to free the pages. In our use case,
we're trying to free up memory, so we would want to immediately use
the "flush the extended reader pages" control file you suggested
below. So, in effect, for us it really is the same as removing valid
trace data, even if there are empty pages. "Offloading" the pages
isn't really good enough. It's another interesting use case, but
doesn't meet the goal of this patch series.

Maybe the use case hasn't been stated coherently: We're in overwrite
mode (but perhaps still before overflow has happened), not reading the
trace yet, waiting for something interesting to happen. In the
meantime, CPUs have varying rates of events occurring on them, and we
have only so much memory on the system set aside for tracing. In order
to efficiently use that memory, we want to adjust the sizes of the
per-cpu buffers in flight so that each CPU has approximately the same
time span, and for as far back as possible within our memory
allocation. Therefore, we want to free empty pages first, and then the
pages with the oldest data.

>
>>
>> >
>> > * Read from tail. Modify the already complex but tried and true lockless
>> > algorithm.
>> >
>> > Pros: Removes empty pages first.
>> >
>> > Cons: Adds a lot more complexity to a complex system that has been
>> > working since 2008.
>> >
>> >
>> > The above makes me lean towards just taking from HEAD.
>> >
>> > If you are worried about leaked pages, we could even have a debugfs file
>> > that lets us monitor the pages that are pending read, and have the user
>> > (or application) be able to flush them if they see the ring buffer is
>> > full anyway.
>>
>> The reason we want per-cpu dynamic resizing is to increase memory
>> utilization, so leaking pages would make me sad.
>
> Shouldn't be too leaky, especially if something can read it. Perhaps we
> could figure out a way to swap them back in.
>
>>
>> Let us mull it over this weekend... maybe we'll come up with something
>> that works more simply.
>
> Hmm, actually, we could take an idea that Mathieu used for his ring
> buffer. He couldn't swap out a page if the writer was on it, so he would
> send out ipi's to push the writer off the page and just pad the rest.

hmm, I'm not seeing how we could use that technique without dropping
recent events. Dropping older events is preferable, in which case we
might as well remove from the head page. I'll add it to my toolbox
though, as I think about it.

> (if it doesn't work with interrupts enabled, it wont
> work for NMIs, so I will not accept disabling interrupts)

I agree, we should not disable interrupts.
