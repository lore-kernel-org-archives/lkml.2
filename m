Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0CVS5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:57:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0CVS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:57:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=HOPUMrKlhQ11jFifdyxbXIgH7JGog1W7O6OK+wWC7eGsZTMJQJfNopXzE4Vm+4bB1
	XTNadTALZ46nF5Cgm5s2g==
MIME-Version: 1.0
In-Reply-To: <1267466740.1579.36.camel@laptop>
References: <20100227020242.1384.9945.stgit@austin.mtv.corp.google.com> 
	<1267271025.22519.740.camel@laptop> <af41c7c41003010744m54fc325bjccae0ff6965656eb@mail.gmail.com> 
	<1267466740.1579.36.camel@laptop>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 22 Mar 2010 11:57:11 -0700
Message-ID: <af41c7c41003221157q1d620b57v699ac931a525722f@mail.gmail.com>
Subject: Re: [PATCH][RESEND] Export per-tid and per-tgid cputime in 
	nanoseconds.
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, kenchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 10:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-03-01 at 07:44 -0800, Divyesh Shah wrote:
>> On Sat, Feb 27, 2010 at 3:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > On Fri, 2010-02-26 at 18:03 -0800, Divyesh Shah wrote:
>> > > This can be used by applications to get finer granularity cputime usage on
>> > > platforms that use timestamp counters or HPET.
>> >
>> > I guess the patch looks good, I'm just not sure what HPET got to do with
>> > anything.. the scheduler certainly doesn't use HPET for timekeeping, its
>> > terribly slow to read.
>>
>> Yes you're right. Please ignore the HPET comment.
>>
>> >
>> > Also, it would be good to get some more justification than 'some
>> > applications can use this', which is basically a truism for any patch
>> > that adds a user interface.
>>
>> 1) This should be useful for a shared or virtualized environment where
>> the shared management infrastructure needs to charge each application
>> as accurately as possible for cpu usage.
>> 2) An application that services different users and does some
>> cpu-intensive work may want to measure cpu time spent for each user by
>> the serving thread.
>>
>> I think applications like web servers, remote database servers, etc.
>> fit into the second category.
>>
>> For units of work smaller than a jiffy, this really helps as some
>> threads could potentially hide from the jiffy based accounting.
>>
>> Please let me know if you want me to send the patch again with the
>> corrected description and added justification.
>
>
> Its all should and may, anything concrete?

Both of the use cases above are what we've been using (the shared
environment case) and plan on using this interface for at Google. So
they are indeed concrete use-cases. It should be useful for similar
scenarios to other users in the linux community.

>
> Also, doesn't muck like schedstat, task_delay_accounting, cpuacct-cgroup
> or some other stuff expose this number already?

I took a look at /proc/<pid>/schedstat. It does export this number
along with some other info but it doesn't do any aggregation of
threads when the pid is a thread group leader and also is less
accurate than cputime_ns as it does not include the cputime since last
tick. I have a patch that adds both of these but it I am not sure if
this affects any userspace tools which depend on the semantics of the
existing interface. Please advise whether it makes sense to change the
shcedstat interface or add this one.

>
>
