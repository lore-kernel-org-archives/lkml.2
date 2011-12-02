Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1LBORR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:17:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23379 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab1LBORQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:17:16 -0500
Message-ID: <4ED8DDE4.8040609@parallels.com>
Date: Fri, 02 Dec 2011 18:17:08 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pedro Alves <pedro@codesourcery.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
References: <20111129191252.769160532@openvz.org> <201112021344.40177.pedro@codesourcery.com> <4ED8D82B.9080408@parallels.com> <201112021400.42762.pedro@codesourcery.com>
In-Reply-To: <201112021400.42762.pedro@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Yes, just like the task/ dir gives you directories named with the
>>>>> processes's thread ids.  Opening /proc/PID/children/PID-CHILD1/ would get
>>>>> you the same as opening /proc/PID-CHILD1/.  Just like
>>>>> opening /proc/PID/task/PID-CHILD1/ gets you (almost) the same as opening
>>>>> /proc/PID-CHILD1/.
>>>>
>>>> You cannot make the dentry named /proc/<pid1>/children/<pid2> be a hardlink on
>>>> the /proc/<pid2>. Thus you have to make arbitrary amount of inodes to point to
>>>> a single task. This brings unnecessary complexity and memory usage (by dentries
>>>> and proc inodes).
>>>
>>> How is this different from the _already existing_ /proc/<pid1>/task/ directory?
>>
>> Those living in /proc/<pid1>/task do not live in /proc. At all. This explains
>> everything below.
> 
> Well, except they do, and it doesn't.  The're not visible when
> listing /proc/, but they're there.  Try it.
> 
> $ls /proc/ | grep 854
> 
> (empty)
> 
> $ ls /proc/8167/task/854
> attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> 
> $ls /proc/854/
> attr       cgroup      comm             cwd      fd      latency   maps       mounts      numa_maps  oom_score_adj  root       sessionid  stat    syscall
> autogroup  clear_refs  coredump_filter  environ  fdinfo  limits    mem        mountstats  oom_adj    pagemap        sched      smaps      statm   task
> auxv       cmdline     cpuset           exe      io      loginuid  mountinfo  net         oom_score  personality    schedstat  stack      status  wchan
> 

O_O   OK, I was wrong, they do live there. But I consider this as bug.

Anyway -- my concern about unneeded memory overhead still stands.
Even a simple find /proc will result in smth like

/proc/1
/proc/1/children/2
/proc/1/children/2/children/4
/proc/1/children/3
/proc/1/children/3/children/5
/proc/2
/proc/2/children/4
/proc/3
/proc/3/children/5
/proc/4
/proc/5

Instead of

/proc/1
/proc/2
/proc/3
/proc/4
/proc/5

I.e. each task will be shown multiple times, which is not very fun, but memory exhaustive from my POV.

Thanks,
Pavel
