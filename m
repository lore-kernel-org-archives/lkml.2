Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722Ab2DLA6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:58:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49533 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760688Ab2DLA6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:58:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F862851.3040208@jp.fujitsu.com>
Date: Thu, 12 Apr 2012 09:56:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com>
In-Reply-To: <20120411185715.GA4317@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/12 3:57), Frederic Weisbecker wrote:

> Hi,
> 
> While talking with Tejun about targetting the cgroup task counter subsystem
> for the next merge window, he suggested to check if this could be merged into
> the memcg subsystem rather than creating a new one cgroup subsystem just
> for task count limit purpose.
> 
> So I'm pinging you guys to seek your insight.
> 
> I assume not everybody in the Cc list knows what the task counter subsystem
> is all about. So here is a summary: this is a cgroup subsystem (latest version
> in https://lwn.net/Articles/478631/) that keeps track of the number of tasks
> present in a cgroup. Hooks are set in task fork/exit and cgroup migration to
> maintain this accounting visible to a special tasks.usage file. The user can
> set a limit on the number of tasks by writing on the tasks.limit file.
> Further forks or cgroup migration are then rejected if the limit is exceeded.
> 
> This feature is especially useful to protect against forkbombs in containers.
> Or more generally to limit the resources on the number of tasks on a cgroup
> as it involves some kernel memory allocation.
> 
> Now the dilemna is how to implement it?
> 
> 1) As a standalone subsystem, as it stands currently (https://lwn.net/Articles/478631/)
> 
> 2) As a feature in memcg, part of the memory.kmem.* files. This makes sense
> because this is about kernel memory allocation limitation. We could have a
> memory.kmem.tasks.count
> 
> My personal opinion is that the task counter brings some overhead: a charge
> across the whole hierarchy at every fork, and the mirrored uncharge on task exit.
> And this overhead happens even in the off-case (when the task counter susbsystem
> is mounted but the limit is the default: ULLONG_MAX).
> 
> So if we choose the second solution, this overhead will be added unconditionally
> to memcg.
> But I don't expect every users of memcg will need the task counter. So perhaps
> the overhead should be kept in its own separate subsystem.
> 
> OTOH memory.kmem.* interface would have be a good fit.
> 
> What do you think?


Sounds interesting to me. Hm, does your 'overhead' of task accounting is
enough large to be visible to users ? How performance regression is big ?

BTW, now, all memcg's limit interfaces use 'bytes' as an unit of accounting.
It's a small concern to me to have mixture of bytes and numbers of objects
for accounting. But I think increasing number of subsystem is not very good....
 
Regards,
-Kame




