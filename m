Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0DTRxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:53:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0DTRxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:53:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=o2Cuo8uE+JPJH+vPE7njcENQnF5H6g95S1Us19FValQ1kPSwstnwjD/I7VSsPs5AH
	obWvrhkryYvMFKFoJmJ5w==
MIME-Version: 1.0
In-Reply-To: <20100420045038.GB2915@dirshya.in.ibm.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>
	 <h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
	 <1271703701.1676.235.camel@laptop>
	 <20100420045038.GB2915@dirshya.in.ibm.com>
Date: Tue, 20 Apr 2010 10:52:58 -0700
Message-ID: <k2y4352991a1004201052lbef1fd73g714d527e872162fd@mail.gmail.com>
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Salman Qazi <sqazi@google.com>
To: svaidy@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 9:50 PM, Vaidyanathan Srinivasan
<svaidy@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-04-19 21:01:41]:
>
>> On Mon, 2010-04-19 at 10:20 -0700, Salman Qazi wrote:
>> > On Thu, Apr 15, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
>> > >> As we discussed earlier this year, Google has an implementation that it
>> > >> would like to share.  I have finally gotten around to porting it to
>> > >> v2.6.33 and cleaning up the interfaces.  It is provided in the following
>> > >> messages for your review.  I realize that when we first discussed this
>> > >> idea, a lot of ideas were presented for enhancing it.  Thanks alot for
>> > >> your suggestions.  I haven't gotten around to implementing any of them.
>> > >
>> > > .33 is way too old to submit patches against.
>> >
>> > Will bump up the version when I refresh the change.
>> >
>> > >
>> > > That said, I really really dislike this approach, I would much rather
>> > > see it tie in with power aware scheduling.
>> >
>> > I think I can see your point:  there is potentially better information
>> > about the power consumption of the CPU beyond the time it was busy.
>> > But please clarify: is your complaint the lack of use of this
>> > information or are you arguing for a deeper integration into the
>> > scheduler (I.e. implementing it as part of the scheduler rather than
>> > an independent thread) or both?
>>
>> Right, so the IBM folks who were looking at power aware scheduling were
>> working on an interface to quantify the amount of power to save.
>
> Indicating required system capacity to the loadbalance and using that
> information to evacuate cores or socket was the basic idea.
>
> Ref: http://lkml.org/lkml/2009/5/13/173
>
> The challenges with that approach is the predictable evacuation or
> forced idleness is not guaranteed.
>
>> But their approach, was an extension of the regular power aware
>> load-balancer, which basically groups tasks onto sockets so that whole
>> sockets can go idle.
>
> Integrating with the load balancer will make the design cleaner and
> avoid forcefully running an idle thread.  The scheduler should
> schedule 'nothing' so that idleness can happen and cpuidle governor
> can take care of idle states.

I am actually not sure which one would be more aesthetically pleasing.
 Putting it into the scheduler would
also place a lot of complexity (basically, the same set of timers) in
the scheduler.

>
>> However Arjan explained to me that your approach, which idles the whole
>> machine, has the advantage that also memory banks can go into idle mode
>> and save power.
>
> Well, this is an ideal goal.  Injecting some amount of idle time
> across all cores/threads preferably with overlapping time window will
> save quite a lot of power on x86.  But atleast overlapping idle times
> among sibling threads are required to get any power savings.

Agreed.  For sibling threads, we need a hard guarantee of simultaneous
injection, which is best achieved by using a single timer for all the
siblings.  It is in my list of things to do.  Is it necessary for the
first cut of idle cycle injector?

For improving power savings in the non-SMT case, as Arjan suggested, I
will make the changes for heuristically aligning the injection on
multiple cores.  This will not be perfect, but then because it's a
power optimization, it doesn't have to always work.  I presume that
this works best when done according to the CPU hierarchy?  That is, it
is more beneficial to idle an entire socket than the same number of
cores on different sockets?

>
> This proposed approach does not yet have the ability to do overlapping
> idle times, though they may randomly occur.
>
>> Still in the interest to cut back on power-saving interfaces it would be
>> nice to see if there is anything we can do to merge these things, but I
>> really haven't thought much about that yet.
>
> Atleast integrating this with ACPI cpu aggregation driver can be a good
> first step.  Both the drivers and code are for the same power capping
> purpose using idle time injection and running an high priority idle
> thread for short duration.
>
> ACPI Processor Aggregator Driver for 2.6.32-rc1
> Ref: http://lkml.org/lkml/2009/10/3/13

This is reasonable.  I could merge the two implementations.  Are there
features in that implementation that our implementation is missing?
>From a cursory glance, the driver is a naive idle cycle injector, in
that it doesn't take existing idle time or scheduler issues into
account.  But if it did, it won't harm its original purpose.

>
> --Vaidy
>
>
