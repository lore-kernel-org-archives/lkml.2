Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0DUBEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:04:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59802 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0DUBEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:04:11 -0400
Message-ID: <4BCE4F6E.10301@cn.fujitsu.com>
Date: Wed, 21 Apr 2010 09:05:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Paris <eparis@parisplace.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage - include/linux/cgroup.h:492
 invoked rcu_dereference_check() without protection!
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com> <20100311032843.GE6767@linux.vnet.ibm.com> <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com> <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop> <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com> <20100419230136.GA16856@linux.vnet.ibm.com>
In-Reply-To: <20100419230136.GA16856@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit 2836f18139267ea918ed2cf39023fb0eb38c4361
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Mon Apr 19 15:59:50 2010 -0700
> 
>     rcu: fix RCU lockdep splat on freezer_fork path
>     
>     Add an RCU read-side critical section to suppress this false positive.
>     
>     Located-by: Eric Paris <eparis@parisplace.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index da5e139..e5c0244 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
>  	 * No lock is needed, since the task isn't on tasklist yet,
>  	 * so it can't be moved to another cgroup, which means the
>  	 * freezer won't be removed and will be valid during this
> -	 * function call.
> +	 * function call.  Nevertheless, apply RCU read-side critical
> +	 * section to suppress RCU lockdep false positives.
>  	 */

It was me that added the original comment.

> +	rcu_read_lock();
>  	freezer = task_freezer(task);
> +	rcu_read_unlock();
>  
>  	/*
>  	 * The root cgroup is non-freezable, so we can skip the

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
