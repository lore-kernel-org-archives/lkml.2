Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2CLI7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:59:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43039 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2CLI7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:59:01 -0400
X-IronPort-AV: E=Sophos;i="4.73,570,1325433600"; 
   d="scan'208";a="4512315"
Message-ID: <4F5DBB8C.6090904@cn.fujitsu.com>
Date: Mon, 12 Mar 2012 17:02:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
References: <4F587199.6050404@cn.fujitsu.com> <20120308182622.GC25508@google.com> <4F59A27D.9080705@cn.fujitsu.com> <20120309165313.GA24890@google.com>
In-Reply-To: <20120309165313.GA24890@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-12 16:56:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-12 16:56:59,
	Serialize complete at 2012-03-12 16:56:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Li.
> 
> On Fri, Mar 09, 2012 at 02:26:05PM +0800, Li Zefan wrote:
>> The problem is, forks can happen at any time, so there's no way to prevent
>> forks from happening while iterating tasks in a cgroup, so controllers
>> have to deal with it. In fact freezer is somewhat aware of this issue,
>> that's why it provides the ->fork callback, but there's race.
>>
>> This patch is not too bad (needs a bit modification). cgroup core will detect
>> (via seqcount) if something's happened to a cgroup and the tasks in it, and
>> then cgroup will notify controllers to check if newly-forked tasks should
>> be adjusted accordingly, so they will have consistent status with other tasks
>> in the same cgroup.
> 
> But why can't we just do what every sane subsystem would do - link
> first and then invoke notification callback?  I mean, we're now
> essentially trying to do the following.
> 
> 1. Take some action.
> 2. Trigger notification.
> 3. Link the result of the action to list.
> 
> So, of course, if someone tries to traverse the "results", there's a
> race window between #2 and #3.  Your fix seems to change the traverser
> to,
> 
> 1. Traverse the list.
> 2. If something happened inbetween, take another look.
> 
> But, the right thing to do would be changing the fork path to
> 
> 1. Take some action.
> 2. Link the result of the action to list.
> 3. Trigger notification.
> 

The reasons are

- We still need some kind of locking to syncronize fork and the traverser.
fork side is protected by tasklist_lock, while the traverser takes
css_set_lock.

- After linking the new task to css set list, the task is visible and thus
can be moved to another cgroup, which makes things more complicated and
the subsystem callbacks may have to acquire cgroup_mutex.

- The task_counter subsystem wants to get notified before the new task
is linked, so it's able to abort the fork.
