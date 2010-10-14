Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0JNJ7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:59:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab0JNJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=cmKIZZSIAZZbchKXVkLh9DaHzs1qsgInZStnGGMgF42bHLKBrE9jczef2T8P4AFTBm
         DHEyPu92XVKZfA/Tm27g==
MIME-Version: 1.0
In-Reply-To: <1287047542.29097.169.camel@twins>
References: <20101012074910.GA9893@in.ibm.com> <20101012075202.GD9893@in.ibm.com>
 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com> <1287047542.29097.169.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Oct 2010 02:58:33 -0700
Message-ID: <AANLkTikkoC+45AnpwosszanrLBjg-OPnV8Bjynq47E9s@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed their
 local quota
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 2:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-13 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
>> cpu.share and bandwidth control can't be used simultaneously or...
>> is this fair ? I'm not familiar with scheduler but this allows boost this tg.
>> Could you add a brief documentaion of a spec/feature. in the next post ?
>
> Like explained, shares control the proportional distribution of time
> between groups, bandwidth puts a limit on how much time a group can
> take. It can cause a group to receive less than its fair share, but
> never more.
>
> There is, however, a problem with all this, and that is that all this
> explicit idling of tasks can lead to a form of priority inversion.
> Regular preemptive scheduling already suffers from this, but explicitly
> idling tasks exacerbates the situation.
>
> You basically get to add the longest induced idle time to all your lock
> hold times.
>

This is a concern (especially for exit starvation, since the task
needs to be scheduled for reaping); the way throttling is enacted
should help to mitigate the risk / starvation here.  When a group
exceeds its bandwidth we don't actively force it off the cpu, we only
set TIF_RESCHED; this the "enforcement" of throttling until we drop
back down through put_prev_task().

This should mean we won't extend a semaphore wait time unless someone
explicitly issues something a cond_resched() within it [at which point
they are choosing a potentially arbitrary latency delay anyway,
although this does expand it relative to the target
sched_latency_period].

>
>
