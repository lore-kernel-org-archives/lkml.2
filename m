Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0JNK0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:26:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0JNK0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bgoGLSTuUgjc7UTS7WTyaqrMHjcoCfa6UX+z/kYU4X5L6BhWSF2I7ndCcb98P3HS44
         OKhsyLFHWVJYXJXWsu7A==
MIME-Version: 1.0
In-Reply-To: <20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101012074910.GA9893@in.ibm.com> <20101012075202.GD9893@in.ibm.com>
 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com> <1287047542.29097.169.camel@twins>
 <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com> <1287050395.29097.176.camel@twins>
 <20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Oct 2010 03:25:33 -0700
Message-ID: <AANLkTikFRLXrdY6_qV5PHeSgH1Dd24ApaHs8R-ixOed=@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed their
 local quota
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, bharata@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 3:08 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 14 Oct 2010 11:59:55 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, 2010-10-14 at 18:50 +0900, KAMEZAWA Hiroyuki wrote:
>> > On Thu, 14 Oct 2010 11:12:22 +0200
>> > Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > > On Wed, 2010-10-13 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
>> > > > cpu.share and bandwidth control can't be used simultaneously or...
>> > > > is this fair ? I'm not familiar with scheduler but this allows boost this tg.
>> > > > Could you add a brief documentaion of a spec/feature. in the next post ?
>> > >
>> > > Like explained, shares control the proportional distribution of time
>> > > between groups, bandwidth puts a limit on how much time a group can
>> > > take. It can cause a group to receive less than its fair share, but
>> > > never more.
>> > >
>> > > There is, however, a problem with all this, and that is that all this
>> > > explicit idling of tasks can lead to a form of priority inversion.
>> > > Regular preemptive scheduling already suffers from this, but explicitly
>> > > idling tasks exacerbates the situation.
>> > >
>> > > You basically get to add the longest induced idle time to all your lock
>> > > hold times.
>> > >
>> >
>> > What is the user-visible difference of the problem between
>> >   1) limit share to be very small.
>> >   2) use throttole.
>> >
>> > If share is used, lock-hodler's priority is boosted ?
>>
>> No, both lead to the same problem, its just that this adds another
>> dimension to it.. and I'm fairly sure people won't realise this until it
>> bites them in the ass.
>>
> Hmm, them, existing problem but this add a new pitfall.
>
> What's your recomendation to make progess on this work ?
>
> I think 1st step will be..
> - explain the problem of priority inversion in cgroup+cfs documenation with
>  !!CAUTION!!
>
> I'm sorry I'm not sure there have been trials for fixing priority inversion
> in the linux scheduler development.
>
> Explaining my motivation, a user of this feature on my customer is virtual machine
> rental service. So, some fuctionality as
> "When vcpu holds spinlock in kernel, please don't sleep.." will be nice.
> Is there patch already ?
>


Per above:

When a group exceeds its bandwidth we don't actively force it off the
cpu, we only set TIF_RESCHED; we won't process the throttling until we
drop back down to userspace and handle the flag.

This means: we'll never throttle a spinlock

We'll also only throttle a sleepable lock (that doesn't disable
preemption) when they voluntarily reschedule without releasing the
lock, at which point they've chosen to open themselves to an arbitrary
latency period anyway.

**

The case of a guest cpu holding spinlocks is part of a much larger
rabbit hole that is spinlock enlightenment which should occur via
pvops/etc interaction.  The sane thing for this to do would be to (at
least) preempt_disable() at which point the vcpu will be protected
from throttling.

This seems somewhat orthogonal to this patchset however.

**

Agreed that PI inversion across threads and across vcpus are rather
sickly beasts; especially given how bare the curtains are on the first
case (which the second can only really build upon).

>
> Thanks,
> -Kame
>
>
>
>
>
>
>
>
>
>
>
>
>
