Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1GZBZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:25:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1GZBZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:25:29 -0400
Message-ID: <4E2E178B.3000500@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 09:25:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/7] cgroups: Add a max number of tasks subsystem
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-8-git-send-email-fweisbec@gmail.com> <CAJniumW7ZKLLDaXSZ4TZ_=PX0ARERTeEyL-iTir12hciOArJqA@mail.gmail.com>
In-Reply-To: <CAJniumW7ZKLLDaXSZ4TZ_=PX0ARERTeEyL-iTir12hciOArJqA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 09:24:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 09:24:34,
	Serialize complete at 2011-07-26 09:24:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>  /* */
>> +
>> +#ifdef CONFIG_CGROUP_MAX_TASKS
>> +SUBSYS(max_tasks)
>> +#endif
> 
> I think I'd be inclined to make the naming slightly (IMO) cleaner:
> call the subsystem 'tasks' and the files 'limit' and 'count' (or maybe
> 'usage' to be more in line with memcg).
>>
>> +config CGROUP_MAX_TASKS
>> +        bool "Control max number of tasks in a cgroup"
>> +       depends on RESOURCE_COUNTERS
>> +       help
>> +         This option let the user to set up an upper bound allowed number
>> +         of tasks.
>> +
> 
> Needs to depend on CGROUPS too?
> 

it's done implicitly, because it's inside "menuconfig CGROUPS".

>> +
>> +
>> +struct task_counter {
>> +       struct res_counter              res;
>> +       struct cgroup_subsys_state      css;
>> +};
> 
> All other CSS structures put the "css" field as the first thing in the
> structure. Not sure that anything relies on that, but consistency

no as far as I know, and that's a bad thing.

> can't hurt and it probably makes the code fractionally smaller since
> the translation between CSS and task_counter becomes a no-op.
> 
>> +static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
>> +                             struct cgroup *old_cgrp, struct task_struct *task)
>> +{
>> +       struct task_counter *cnt = cgroup_task_counter(old_cgrp);
>> +
>> +       if (cnt != &root_counter)
>> +               res_counter_uncharge_until(&cnt->res, &root_counter.res, 1);
>> +}
> 
> Do we even need the root_counter to be exposed in any way? Why not
> make children of the root cgroup just have a NULL parent res_counter?
> 
> You'll still need a task_counter object so that the cgroups framework
> has a CSS object for cgroups housekeeping, but I don't think it needs
> to actually be used for anything.
> 
> Paul
> 
