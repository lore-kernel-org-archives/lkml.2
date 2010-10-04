Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0JDTSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:18:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab0JDTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kVaobv1jahjjBehS6WAsJHobDS1bvIlyb78dCwkOb5rf+93JfPYyKR1wD08/eshIbV
         /IxtdT1jl2/O13UUo/HQ==
MIME-Version: 1.0
In-Reply-To: <1285934368.2144.60.camel@laptop>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	<1285843669.2144.2.camel@laptop>
	<AANLkTikVQist_VnCcpZzU78t0TVuocwOcDPG4POVzSdv@mail.gmail.com>
	<1285934368.2144.60.camel@laptop>
Date: Mon, 4 Oct 2010 12:18:20 -0700
X-Google-Sender-Auth: DFV5ETwKx4rbXc_Q0h7rq_NX9Q8
Message-ID: <AANLkTimpzfCDHuVQkExLvQHaVY==SFJ2AUWO7tZkcK2T@mail.gmail.com>
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

>> > Please explain this stuff..
>>
>> The situation today is quite bad for sleeping tasks. Currently, when
>> you move a sleeping thread between cgroups, the thread can retain its
>> old vruntime value if the old group was far ahead of the new group
>> since it essentially does a max(se->vruntime, new_vruntime) in
>> place_entity. This can prevent the task from running for a very long
>> time. That is what this patch was trying to address. It normalizes the
>> sleeper thread's vruntime before moving it to the new group.
>>
>>
>
> Hrm,.. ok, I tend to not use this cgroup gunk more that I absolutely
> have to, so I'll take your word for it.
>
> But doesn't normal cross-cpu task migration already solve this problem?
> Therefore wouldn't it be possible to adapt/extend that code to also deal
> with this particular issue?

It does, but from what I can tell it does so lazily for sleeping
tasks, i.e. the logic is in try_to_wake_up(). The cgroup attach moves
the task immediately, so when we attempt to wake it up it will already
be too late for the wake_up code to do the right thing since the task
has the new cpu_rq assigned from sched_move_task(). The wakeup logic
will not have the old group info.

--Dima
