Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab0JGNpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:45:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50480 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab0JGNpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XrpEMYjijpdnnZZO39upH0QNz3+ZnbrW/NFwlv4WCpwWA2gIDinK/LN4e6BlTwcr67
         SLternbf7LWb2jDgXIa9IUOs5JzwdInYfvdwFbE9vX58y73P1FWoFugVnwKQOdxygx5N
         9v1TejS+omE2ASYYLIphAYwE8rUdd9JUbSYkM=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4CAD206A.1090708@cn.fujitsu.com>
References: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
	<4CAD206A.1090708@cn.fujitsu.com>
Date: Thu, 7 Oct 2010 15:45:20 +0200
Message-ID: <AANLkTikcc_egoo==_R6usUdCm07Cuog7gD4DEjX8rfaP@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v4)
From: stephane eranian <eranian@googlemail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 3:20 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Stephane Eranian wrote:
>> This kernel patch adds the ability to filter monitoring based on
>> container groups (cgroups). This is for use in per-cpu mode only.
>>
>> The cgroup to monitor is passed as a file descriptor in the pid
>> argument to the syscall. The file descriptor must be opened to
>> the cgroup name in the cgroup filesystem. For instance, if the
>> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
>> file descriptor is opened to /cgroup/foo. Cgroup mode is
>> activated by passing PERF_FLAG_PID_CGROUP into the flags argument
>> to the syscall.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> ---
>>
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 709dfb9..67cf276 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -623,6 +623,8 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
>>  unsigned short css_id(struct cgroup_subsys_state *css);
>>  unsigned short css_depth(struct cgroup_subsys_state *css);
>>
>> +struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
>> +
>>  #else /* !CONFIG_CGROUPS */
>>
>>  static inline int cgroup_init_early(void) { return 0; }
>> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
>> index ccefff0..93f86b7 100644
>> --- a/include/linux/cgroup_subsys.h
>> +++ b/include/linux/cgroup_subsys.h
>> @@ -65,4 +65,8 @@ SUBSYS(net_cls)
>>  SUBSYS(blkio)
>>  #endif
>>
>> +#ifdef CONFIG_PERF_EVENTS
>> +SUBSYS(perf)
>> +#endif
>> +
>>  /* */
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index 61b1e2d..ad79f0a 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -454,6 +454,7 @@ enum perf_callchain_context {
>>
>>  #define PERF_FLAG_FD_NO_GROUP        (1U << 0)
>>  #define PERF_FLAG_FD_OUTPUT  (1U << 1)
>> +#define PERF_FLAG_PID_CGROUP (1U << 2) /* pid=cgroup id, per-cpu mode */
>>
>>  #ifdef __KERNEL__
>>  /*
>> @@ -461,6 +462,7 @@ enum perf_callchain_context {
>>   */
>>
>>  #ifdef CONFIG_PERF_EVENTS
>> +# include <linux/cgroup.h>
>>  # include <asm/perf_event.h>
>>  # include <asm/local64.h>
>>  #endif
>> @@ -698,6 +700,18 @@ struct swevent_hlist {
>>  #define PERF_ATTACH_CONTEXT  0x01
>>  #define PERF_ATTACH_GROUP    0x02
>>
>> +#ifdef CONFIG_CGROUPS
>> +struct perf_cgroup_time {
>> +     u64 time;
>> +     u64 timestamp;
>> +};
>> +
>> +struct perf_cgroup {
>> +     struct cgroup_subsys_state css;
>> +     struct perf_cgroup_time *time;
>> +};
>
> Can we avoid adding this perf cgroup subsystem? It has 2 disavantages:
>
Well, I need to maintain some timing information for each cgroup. This has
to be stored somewhere.

> - If one mounted cgroup fs without perf cgroup subsys, he can't monitor it.

That's unfortunately true ;-)

> - If there are several different cgroup mount points, only one can be
>  monitored.
>
> To choose which cgroup hierarchy to monitor, hierarchy id can be passed
> from userspace, which is the 2nd column below:
>
Ok, I will investigate this. As long as the hierarchy id is unique AND it can be
searched, then we can use it. Using /proc is fine with me.

> $ cat /proc/cgroups
> #subsys_name    hierarchy       num_cgroups     enabled
> debug   0       1       1
> net_cls 0       1       1
>
>> +#endif
>
