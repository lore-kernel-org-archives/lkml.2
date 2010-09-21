Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0IULsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 07:48:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:62341 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0IULsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 07:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OX/EftoAFQMuHLRnOFnDlL67YHKkAIeXsGnBcBxrcP+0POgwMycYfR14xQn73nzgDk
         EU9DS8yPjqByNOwxO8Dg==
MIME-Version: 1.0
In-Reply-To: <1285062228.2275.826.camel@laptop>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	<1285061899.2275.824.camel@laptop>
	<1285062228.2275.826.camel@laptop>
Date: Tue, 21 Sep 2010 13:48:32 +0200
Message-ID: <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Tue, Sep 21, 2010 at 11:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-09-21 at 11:38 +0200, Peter Zijlstra wrote:
>> On Thu, 2010-09-09 at 15:05 +0200, Stephane Eranian wrote:
>> > The cgroup to monitor is designated by passing a file descriptor opened
>> > on a new per-cgroup file in the cgroup filesystem (perf_event.perf). The
>> > option must be activated by setting perf_event_attr.cgroup=1 and passing
>> > a valid file descriptor in perf_event_attr.cgroup_fd. Those are the only
>> > two ABI extensions.
>>
>> > +++ b/include/linux/perf_event.h
>> > @@ -215,8 +215,9 @@ struct perf_event_attr {
>> >                                  */
>> >                                 precise_ip     :  2, /* skid constraint       */
>> >                                 mmap_data      :  1, /* non-exec mmap data    */
>> > +                               cgroup         :  1, /* cgroup aggregation    */
>> >
>> > -                               __reserved_1   : 46;
>> > +                               __reserved_1   : 45;
>> >
>> >         union {
>> >                 __u32           wakeup_events;    /* wakeup every n events */
>> > @@ -226,6 +227,8 @@ struct perf_event_attr {
>> >         __u32                   bp_type;
>> >         __u64                   bp_addr;
>> >         __u64                   bp_len;
>> > +
>> > +       int                     cgroup_fd;
>> >  };
>> >
>> >  /*
>>
>> I'm not sure I like this much.. so we attach to {pid,cpu}, for nodes we
>> can use cpu_to_node(cpu), which would suggest to use
>> cgroup_of_task(pid), except that a task can be part of multiple cgroups,
>> so its not unique.
>>
>> One thing we could do is pass this cgroup identifier in the pid field
>> and use PERF_FLAG_CGROUP or something. Currently the syscall signature
>> uses pid_t, but I think we can safely change that to int.
>>
>> You create a special new file in the cgroup stuff, I'm not sure about
>> that either, but its not something I feel too strongly about, why
>> wouldn't a fd of any file or even directory of that cgroup work? Do the
>> cgroup people have an opinion?
>
> Ahh, I just read more of the patch, and you create a full perf cgroup,
> in which case cgroup_of_task(pid) will work, simply pick the perf
> cgroup's tasks.
>
> No need to actually create that file, open it and pass fds around, just
> pick a task from that cgroup and attach to the cgroup through that.
>
If I understand, you are proposing that we use the pid argument to the
syscall to designate the cgroup. A task belongs to only one cgroup at
a time. Thus with the pid you can identify a cgroup. No need for an
entry in cgroup_fs and therefore no need for cgroup_fd in perf_event_attr.
We would still need a flag somewhere to indicate that we don't want
per-thread mode but per-cpu per-cgroup. It could be a new field in the
bitfield in perf_event_attr. In fact, I already have such a field.

The main issue I see with this is that it relies on having at least one
task in the cgroup when you start the measurement. That is certainly
not always the case.
