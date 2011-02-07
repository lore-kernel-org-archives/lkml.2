Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1BGVWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:22:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:49242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1BGVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=I0cReawQzoIcV+Wu19yQ127WV1IbdQ6bUEGxCUpq8vYx+EZLzDn6JzQGZO9wEjkQMS
         isv86sQtewJJVJrEBOoA==
MIME-Version: 1.0
In-Reply-To: <1297108959.13327.54.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com> <1296650792.26581.319.camel@laptop>
 <20110202190251.GB16409@balbir.in.ibm.com> <1297095033.13327.46.camel@laptop>
 <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com> <1297108959.13327.54.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Mon, 7 Feb 2011 13:21:35 -0800
Message-ID: <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com>
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 12:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-02-07 at 11:28 -0800, Paul Menage wrote:
>> On Mon, Feb 7, 2011 at 8:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > Make the ::exit method act like ::attach, it is after all very nearly
>> > the same thing.
>>
>> The major difference between attach and exit is that the former is
>> only triggered in response to user cgroup-management action, whereas
>> the latter is triggered whenever a task exits, even if cgroups aren't
>> set up.
>
> And the major likeness is that they both migrate a task from one cgroup
> to another. You cannot simply ignore that.

True, and the exit path for cgroups has always been a bit fuzzy - that
was kind of inherited from cpusets, where this worked out OK, but the
CPU subsystem has more interesting requirements.

An important semantic difference between attach and exit is that in
the exit case the destination is always the root, and the task in
question is going to be exiting before doing anything else
interesting. So it should be possible to optimize that path a lot
compared to the regular attach (many things related to resource usage
can be ignored, since the task won't have time to actually use any
non-trivial amount of resources).

>
> If maybe you're like respond more often than about once every two months
> I might actually care what you think.

Yes, sadly since switching groups at Google, cgroups has become pretty
much just a spare-time activity for me - but that in itself doesn't
automatically invalidate my opinion when I do have time to respond.
It's still the case that cgroup_mutex is an incredibly heavyweight
mutex that has no business being in the task exit path. Or do you just
believe that ad hominem is a valid style of argument?

How about if the exit callback was moved before the preceding
task_unlock()? Since I think the scheduler is still the only user of
the exit callback, redefining the locking semantics should be fine.

Paul
