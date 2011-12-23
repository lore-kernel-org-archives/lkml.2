Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1LWCiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:38:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab1LWCiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:38:19 -0500
Message-ID: <4EF3EA1C.4000806@cn.fujitsu.com>
Date: Fri, 23 Dec 2011 10:40:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/3] cgroup: remove tasklist_lock from cgroup_attach_proc
References: <1324601873-20773-1-git-send-email-msb@chromium.org> <20111223022742.GA28309@somewhere.redhat.com>
In-Reply-To: <20111223022742.GA28309@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-23 10:37:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-23 10:37:34,
	Serialize complete at 2011-12-23 10:37:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 1042b3c..032139d 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -2102,21 +2102,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>>  	if (retval)
>>  		goto out_free_group_list;
>>  
>> -	/* prevent changes to the threadgroup list while we take a snapshot. */
>> -	read_lock(&tasklist_lock);
>> -	if (!thread_group_leader(leader)) {
>> -		/*
>> -		 * a race with de_thread from another thread's exec() may strip
>> -		 * us of our leadership, making while_each_thread unsafe to use
>> -		 * on this task. if this happens, there is no choice but to
>> -		 * throw this task away and try again (from cgroup_procs_write);
>> -		 * this is "double-double-toil-and-trouble-check locking".
>> -		 */
>> -		read_unlock(&tasklist_lock);
>> -		retval = -EAGAIN;
>> -		goto out_free_group_list;
>> -	}
>> -
>>  	tsk = leader;
>>  	i = 0;
>>  	do {
>> @@ -2145,7 +2130,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>>  	group_size = i;
>>  	tset.tc_array = group;
>>  	tset.tc_array_len = group_size;
>> -	read_unlock(&tasklist_lock);
> 
> You still need rcu_read_lock()/rcu_read_unlock() around
> 	do {
> 
> 	} while_each_thread()
> 
> because threadgroup_lock() doesn't lock the part that remove a thread from
> its group on exit.
> 

and inside rcu critical section, you can't call kmalloc(GFP_KERNEL)!!
