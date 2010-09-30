Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0I3TOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:14:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0I3TOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MlRLPLE+pA8K2lbEnYrN22CFYx79Fh9bW8XV4XQdbGjjAPx9Vr+/vdtpHG1QGzEsWI
         JB13BWnOvuxbwZiNSBWg==
MIME-Version: 1.0
In-Reply-To: <1285843669.2144.2.camel@laptop>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	<1285843669.2144.2.camel@laptop>
Date: Thu, 30 Sep 2010 12:14:42 -0700
X-Google-Sender-Auth: jM8bS3R_jX8ZjVYlMQioyObt-zg
Message-ID: <AANLkTikVQist_VnCcpZzU78t0TVuocwOcDPG4POVzSdv@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group change
From: Dima Zavin <dima@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

>> This adds a new callback, prep_move_task, to struct sched_class
>> to give sched_fair the opportunity to adjust the task's vruntime
>> just before setting its new group.
>>
>> This allows us to properly normalize a sleeping task's vruntime
>> when moving it between different cgroups.
>
> Don't much like these patches, and changelogs need full descriptions not
> fuzzy links out to the interwebs that might or might not stay valid.

Sorry, I'll resend with a better changelog and no tubes.

> If you change a task's cgroup, the task is new in that cgroup and should
> be placed like a new task would, carrying over any history it has in the
> old cgroup is dubious at best.

That is certainly not the behavior today for running tasks as I
understand it. They get their vruntime normalized before being taken
off the run_queue of old group, and then get the new min_vruntime
added when they get re-enqueued. For sleeping tasks it's just plain
broken (see below).

Also, I am skeptical that the behavior you describe is desired. If you
were to just place the task in the new cgroup like it was a brand new
task, it could allow threads to game the system and potentially let
them reset their vruntime back. If I do a bunch of work and then move
myself out of the group and then back onto it, I may get lower
vruntime than by just staying on the group.

> Please explain this stuff..

The situation today is quite bad for sleeping tasks. Currently, when
you move a sleeping thread between cgroups, the thread can retain its
old vruntime value if the old group was far ahead of the new group
since it essentially does a max(se->vruntime, new_vruntime) in
place_entity. This can prevent the task from running for a very long
time. That is what this patch was trying to address. It normalizes the
sleeper thread's vruntime before moving it to the new group.

Thanks in advance.

--Dima
