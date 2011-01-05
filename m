Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1AEIcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:32:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1AEIck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UumFgYCB3W6tETgEsbvGIEBNgbaIOQO5T31pLQMQzPQ4+3vliFNnDoDoIMIx87lyku
         KP+MHBdpegmfjEtt2/sQ==
MIME-Version: 1.0
In-Reply-To: <4D23E1D1.3000400@cn.fujitsu.com>
References: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
	<4D23E1D1.3000400@cn.fujitsu.com>
Date: Wed, 5 Jan 2011 09:32:37 +0100
Message-ID: <AANLkTi=fCBQyq9GHw38P6d0ZFb6U7YUZk8vfC8i6yxE0@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v7)
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
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

Li,

Thanks for your comment. Good catch on perf_detach_cgroup().
I will resubmit this patch (part 4/5).

On Wed, Jan 5, 2011 at 4:13 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Stephane Eranian wrote:
>> This kernel patch adds the ability to filter monitoring based on
>> container groups (cgroups). This is for use in per-cpu mode only.
>>
>> The cgroup to monitor is passed as a file descriptor in the pid
>> argument to the syscall. The file descriptor must be opened to
>> the cgroup name in the cgroup filesystem. For instance, if the
>> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
>> file descriptor is opened to /cgroup/foo. Cgroup mode is
>> activated by passing PERF_FLAG_PID_CGROUP in the flags argument
>> to the syscall.
>>
>> For instance to measure in cgroup foo on CPU1 assuming
>> cgroupfs is mounted under /cgroup:
>>
>> struct perf_event_attr attr;
>> int cgroup_fd, fd;
>>
>> cgroup_fd = open("/cgroup/foo", O_RDONLY);
>> fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
>> close(cgroup_fd);
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> For the cgroup part:
>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
>
> a few comments below:
>
>>
> ...
>> +config CGROUP_PERF
>> +     bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
>> +     depends on PERF_EVENTS && CGROUPS
>
> Depending on CGROUPS is already implicated by "if CGROUPS"
>
>> +     help
>> +       This option extends the per-cpu mode to restrict monitoring to
>> +       threads which belong to the cgroup specificied and run on the
>> +       designated cpu.
>> +
>> +       Say N if unsure.
>> +
>>  menuconfig CGROUP_SCHED
>>       bool "Group CPU scheduler"
>>       depends on EXPERIMENTAL
> ...
>> +static inline int perf_cgroup_connect(int fd, struct perf_event *event,
>> +                                   struct perf_event_attr *attr,
>> +                                   struct perf_event *group_leader)
>> +{
>> +     struct perf_cgroup *cgrp;
>> +     struct cgroup_subsys_state *css;
>> +     struct file *file;
>> +     int ret = 0, fput_needed;
>> +
>> +     file = fget_light(fd, &fput_needed);
>> +     if (!file)
>> +             return -EBADF;
>> +
>> +     css = cgroup_css_from_dir(file, perf_subsys_id);
>> +     if (IS_ERR(css))
>> +             return PTR_ERR(css);
>> +
>> +     cgrp = container_of(css, struct perf_cgroup, css);
>> +     event->cgrp = cgrp;
>> +
>> +     /*
>> +      * all events in a group must monitor
>> +      * the same cgroup because a thread belongs
>> +      * to only one perf cgroup at a time
>> +      */
>> +     if (group_leader && group_leader->cgrp != cgrp) {
>> +             perf_detach_cgroup(event);
>
> This doesn't seem right, because we haven't got the cgroup
> refcount.
>
>> +             ret = -EINVAL;
>> +     } else {
>> +             /* must be done before we fput() the file */
>> +             perf_get_cgroup(event);
>> +     }
>> +     fput_light(file, fput_needed);
>> +     return ret;
>> +}
>
