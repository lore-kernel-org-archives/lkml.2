Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab1CXLt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:49:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1CXLt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U/9ja5viN2JpKwFD4PtPjU8+U2C4sxWYJnIBHKF69MeqzvV3Nj6nk+0daVklLEpCps
         DHvGVo9GoHNb+ASV9pja7816+Iv/VvfnuN0P2wqVcgOV54OKYgv367aWfvxK9HstBLsO
         CAmj4ooYiSuW8AOys7/4GbV/uyYNYujGboiMo=
MIME-Version: 1.0
In-Reply-To: <20110324073009.GB3783@elte.hu>
References: <20110323203426.GC7709@kroah.com>
	<20110323203437.GD7709@kroah.com>
	<4D8A8DC9.1060502@suse.cz>
	<20110324025133.GA23564@suse.de>
	<20110324073009.GB3783@elte.hu>
Date: Thu, 24 Mar 2011 12:49:56 +0100
Message-ID: <AANLkTimUaJ7i4D6bsgq6UTqW79nkybtLdd7pbVM_TrQi@mail.gmail.com>
Subject: Re: Linux 2.6.32.34
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/24 Ingo Molnar <mingo@elte.hu>:
>
> * Greg KH <gregkh@suse.de> wrote:
>
>> On Thu, Mar 24, 2011 at 01:18:17AM +0100, Jiri Slaby wrote:
>> > On 03/23/2011 09:34 PM, Greg KH wrote:
>> > > --- a/kernel/perf_event.c
>> > > +++ b/kernel/perf_event.c
>> > > @@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct perf_event *event)
>> > >
>> > >  static const struct pmu *tp_perf_event_init(struct perf_event *event)
>> > >  {
>> > > + if (event->hw.state & PERF_HES_STOPPED)
>> > > +         return 0;
>> > >   /*
>> > >    * Raw tracepoint data is a severe data leak, only allow root to
>> > >    * have these.
>> >
>> > This causes build to fail:
>> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:
>> > In function 'tp_perf_event_init':
>> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>> > error: 'struct hw_perf_event' has no member named 'state'
>> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>> > error: 'PERF_HES_STOPPED' undeclared (first use in this function)
>> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>> > error: (Each undeclared identifier is reported only once
>> > /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
>> > error: for each function it appears in.)
>> >
>> >
>> > The source:
>> > commit 6f197b73304b3bd3d5a43b931383a5331d6b2987
>> > Author: Frederic Weisbecker <fweisbec@gmail.com>
>> > Date:   Mon Mar 7 21:27:09 2011 +0100
>> >
>> >     perf: Handle stopped state with tracepoints
>> >
>> >     commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.
>> >
>> >     We toggle the state from start and stop callbacks but actually
>> >     don't check it when the event triggers. Do it so that
>> >     these callbacks actually work.
>>
>> Ick, I don't know why it builds fine here.  Federic, should I just drop
>> this patch for the .32 tree?
>
> Yes, please drop it.
>
> Thanks,
>
>        Ingo
>

Yeah sorry for this. The patch actually only applies starting from 2.6.37
Naked stable@kernel.org tags (which I confess I use too) without version slice
are sometimes creepy because they can cause such patches that may physically
apply but not logically. And that's not the first time. Sometimes it's
even worse when
it applies and builds but fails on runtime because the old code flow
was different. I
remember a similar case with an old breakpoint patch that needed a
different backport
version in .33, I was lucky enough to anticipate but a naked stable
tag would have broken.

OTOH the flow of patches that get stable tags is bigger now that people are
used to stable workflow. And checking every versions for all of them
may require quite some time. This implies one to keep these trees handy in
his filesystems and do careful checks, not even only build. That can be a bit
of a congestion point as more stable trees are maintained by the time. But
probably needed. Often it's simply a matter of doing a binary search to find
the first tree that starts the slice of the backport.
