Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2CIGXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:23:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2CIGXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:23:10 -0500
X-IronPort-AV: E=Sophos;i="4.73,556,1325433600"; 
   d="scan'208";a="4497483"
Message-ID: <4F59A27D.9080705@cn.fujitsu.com>
Date: Fri, 09 Mar 2012 14:26:05 +0800
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
References: <4F587199.6050404@cn.fujitsu.com> <20120308182622.GC25508@google.com>
In-Reply-To: <20120308182622.GC25508@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 14:21:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 14:21:11,
	Serialize complete at 2012-03-09 14:21:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02:26, Tejun Heo wrote:
> Hello, Li, Frederic.
> 
> On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
>> +static void freezer_post_fork(struct cgroup_subsys *ss,
>> +			      struct task_struct *task)
>> +{
>> +	struct freezer *freezer;
>> +
>> +	cgroup_lock();
>> +
>> +	freezer = task_freezer(task);
>> +	if (!freezer->css.cgroup->parent)
>> +		goto out;
>> +
>> +	spin_lock_irq(&freezer->lock);
>> +	if (freezer->state != CGROUP_THAWED)
>> +		freeze_task(task);
>> +	spin_unlock_irq(&freezer->lock);
>> +out:
>> +	cgroup_unlock();
>> +}
> 
> Urgh... this is requiring policy implementations to synchronize with
> problem caused by cgroup core optimization and it's so very subtle.
> IMHO, this definitely should be contained in cgroup core and in a very
> confined form even inside cgroup core.
> 
> Any other ideas?
> 

The problem is, forks can happen at any time, so there's no way to prevent
forks from happening while iterating tasks in a cgroup, so controllers
have to deal with it. In fact freezer is somewhat aware of this issue,
that's why it provides the ->fork callback, but there's race.

This patch is not too bad (needs a bit modification). cgroup core will detect
(via seqcount) if something's happened to a cgroup and the tasks in it, and
then cgroup will notify controllers to check if newly-forked tasks should
be adjusted accordingly, so they will have consistent status with other tasks
in the same cgroup.
