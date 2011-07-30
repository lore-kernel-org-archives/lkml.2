Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1G3CnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 22:43:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1G3CnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 22:43:22 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=CRjEFeY9x6sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Rm1Ti5Hq3AYJN7bqYEQA:9 a=5QEzpG93NRJhbV4zZ1QA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=1pKGDqd-0a_2lHbY:21 a=BwaUZnna7j1pYbln:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJL_ektBTtVp==CbjLMaeO3Tz24=KmE50Qy+St0yc9dvYzuQFw@mail.gmail.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-5-git-send-email-vnagarnaik@google.com>
	 <1311974602.21143.92.camel@gandalf.stny.rr.com>
	 <CAL26m8K8_55r_KZ9hc1ZPxvFTnnRzmjB0RH62OUB=Be0FjpcjQ@mail.gmail.com>
	 <1311988337.21143.107.camel@gandalf.stny.rr.com>
	 <CAJL_ektBTtVp==CbjLMaeO3Tz24=KmE50Qy+St0yc9dvYzuQFw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 22:43:19 -0400
Message-ID: <1311993799.21143.120.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 18:50 -0700, David Sharp wrote:
> On Fri, Jul 29, 2011 at 6:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2011-07-29 at 16:30 -0700, Vaibhav Nagarnaik wrote:
> >> On Fri, Jul 29, 2011 at 2:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> There should only be IRQs and NMIs that preempt this operation since
> >> the removal operation of a cpu ring buffer is scheduled on keventd of
> >> the same CPU. But you're right there is a race between reading the
> >> to_remove pointer and cmpxchg() operation.
> >
> > Bah, this is what I get for reviewing patches and doing other work at
> > the same time. I saw the work/completion set up, but it didn't register
> > to me that this was calling schedule_work_on(cpu..).
> >
> > But that said, I'm not sure I really like that. This still seems a bit
> > too complex.
> 
> What is it that you don't like? the work/completion, the reliance on
> running on the same cpu, or just the complexity of procedure?

The added complexity. This is complex enough, we don't need to make it
more so.

> 
> >> While we are trying to remove the head page, the writer could move to
> >> the head page. Additionally, we will be adding complexity to manage data
> >> from all the removed pages for read_page.
> >>
> >> I discussed with David and here are some ways we thought to address
> >> this:
> >> 1. After the cmpxchg(), if we see that the tail page has moved to
> >>    to_remove page, then revert the cmpxchg() operation and try with the
> >>    next page. This might add some more complexity and doesn't work with
> >>    an interrupt storm coming in.
> >
> > Egad no. That will just make things more complex, and harder to verify
> > is correct.
> >
> >> 2. Disable/enable IRQs while removing pages. This won't stop traced NMIs
> >>    though and we are now affecting the system behavior.
> >> 3. David didn't like this, but we could increment
> >>    cpu_buffer->record_disabled to prevent writer from moving any pages
> >>    for the duration of this process. If we combine this with disabling
> >>    preemption, we would be losing traces from an IRQ/NMI context, but we
> >>    would be safe from races while this operation is going on.
> >>
> >> The reason we want to remove the pages after tail is to give priority to
> >> empty pages first before touching any data pages. Also according to your
> >> suggestion, I am not sure how to manage the data pages once they are
> >> removed, since they cannot be freed and the reader might not be present
> >> which will make the pages stay resident, a form of memory leak.
> >
> > They will be freed when they are eventually read. Right, if there's no
> > reader, then they will not be freed, but that isn't really a true memory
> > leak. It is basically just like we didn't remove the pages, but I do not
> > consider this a memory leak. The pages are just waiting to be reclaimed,
> > and will be freed on any reset of the ring buffer.
> >
> > Anyway, the choices are:
> >
> > * Remove from the HEAD and use the existing algorithm that we've been
> > using since 2008. This requires a bit of accounting on the reader side,
> > but nothing too complex.
> >
> > Pros: Should not have any major race conditions. Requires no
> > schedule_work_on() calls. Uses existing algorithm
> >
> > Cons: Can keep pages around if no reader is present, and ring buffer is
> > not reset.
> 
> Con: by definition, removes valid trace data from the ring buffer,
> even if it is not full. I think that's a pretty big con for the
> usability of the feature.

Um, how does it remove valid trace data? We don't free it, we off load
it. Think of it as "extended reader pages". That is, they are held off
until the user asks to read these pages. Then they will get the data
again. What is a con about that?

> 
> >
> > * Read from tail. Modify the already complex but tried and true lockless
> > algorithm.
> >
> > Pros: Removes empty pages first.
> >
> > Cons: Adds a lot more complexity to a complex system that has been
> > working since 2008.
> >
> >
> > The above makes me lean towards just taking from HEAD.
> >
> > If you are worried about leaked pages, we could even have a debugfs file
> > that lets us monitor the pages that are pending read, and have the user
> > (or application) be able to flush them if they see the ring buffer is
> > full anyway.
> 
> The reason we want per-cpu dynamic resizing is to increase memory
> utilization, so leaking pages would make me sad.

Shouldn't be too leaky, especially if something can read it. Perhaps we
could figure out a way to swap them back in.

> 
> Let us mull it over this weekend... maybe we'll come up with something
> that works more simply.

Hmm, actually, we could take an idea that Mathieu used for his ring
buffer. He couldn't swap out a page if the writer was on it, so he would
send out ipi's to push the writer off the page and just pad the rest.

We could do the same thing here. Use the writer logic to make the
change. That would require starting a commit, perhaps just write a
padding some how. If we fail the reserve, we just try again. The writers
are set up to sync with each other per cpu. We would need a way that the
NMIs and interrupts (if it doesn't work with interrupts enabled, it wont
work for NMIs, so I will not accept disabling interrupts) can work
together in this effort too.

But I'm working on other things right now and don't have time to think
about it. But perhaps you can come up with some ideas too.

-- Steve


