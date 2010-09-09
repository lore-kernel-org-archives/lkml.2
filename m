Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0IIVls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:41:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab0IIVlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AZ7e7xQ7jJKCV/LBWvR/RzgjYhmfjmoHgok2AXr+EGMxO8V2pNLOcldBfvsSz4GNbp
         vx+bPTxHGjuJSsHEEqgQ==
MIME-Version: 1.0
In-Reply-To: <1284040322.2589.174.camel@edumazet-laptop>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	<1284040322.2589.174.camel@edumazet-laptop>
Date: Thu, 9 Sep 2010 23:41:39 +0200
Message-ID: <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Thu, Sep 9, 2010 at 3:52 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 09 septembre 2010 à 06:09 -0700, Stephane Eranian a écrit :
>> This kernel patch adds the ability to filter monitoring based on
>> container groups (cgroups). This is for use in per-cpu mode only.
>>
>> The patch adds perf_event_attr.cgroup, a boolean, to activate
>> this new mode. The cgroup is designated by passing in
>> perf_event_attr.cgroup_fd, an opened file descriptor to
>> the <mnt>/<cgroup>/perf_event.perf file.
>>
>> This is the second version of this patch. It corrects the way
>> time_enabled is accounted for. In cgroup mode, time_enabled reflects
>> the time the cgroup was active, i.e., threads from the cgroup executed
>> on the monitored CPU.  This is a more useful metric than just
>> wall-clock. The meaning of time_enabled without cgroup is unaffected.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
>
>> +#ifdef CONFIG_CGROUPS
>> +struct perf_cgroup_time {
>> +     u64 time;
>> +     u64 timestamp;
>> +};
>> +
>> +struct perf_cgroup {
>> +     struct cgroup_subsys_state css;
>> +     struct perf_cgroup_time *time;
>
>        struct perf_cgroup_time __percpu *time;
>
> Please run sparse  after this "__percpu" change.
>
>
Will do.

>> +     jc->time = alloc_percpu(struct perf_cgroup_time);
>> +     if (!jc->time) {
>> +             vfree(jc);
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>> +
>> +     for_each_possible_cpu(c) {
>> +             t = per_cpu_ptr(jc->time, c);
>> +             t->time = 0;
>> +             t->timestamp = 0;
>> +     }
>
> alloc_percpu() is zalloc_percpu() in fact, memory is already cleared.
>
I remember thinking about this and trying to trace to the code down
to figure this out. But it is rather complicated. If alloc_percpu() always
clears the memory, then I think that calling is zalloc_percpu()
would be more helpful....

>
>
