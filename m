Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1LUDOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:14:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62458 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1LUDOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:14:05 -0500
Message-ID: <4EF14F7B.2040507@cn.fujitsu.com>
Date: Wed, 21 Dec 2011 11:16:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 2/2 v2] cgroup: Drop task_lock(parent) on cgroup_fork()
References: <1324432958-20414-1-git-send-email-fweisbec@gmail.com> <1324432958-20414-3-git-send-email-fweisbec@gmail.com> <4EF14176.9040206@cn.fujitsu.com> <20111221024849.GC17668@somewhere>
In-Reply-To: <20111221024849.GC17668@somewhere>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 11:13:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 11:13:23,
	Serialize complete at 2011-12-21 11:13:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> @@ -4556,7 +4556,7 @@ static const struct file_operations proc_cgroupstats_operations = {
>>>   *
>>>   * A pointer to the shared css_set was automatically copied in
>>>   * fork.c by dup_task_struct().  However, we ignore that copy, since
>>> - * it was not made under the protection of RCU or cgroup_mutex, so
>>> + * it was not made under the protection of threadgroup_change_begin(), so
>>
>> I think the original comment still stands, but now threadgroup_change_begin()
>> can also protect the cgroup pointer from becoming invalid.
> 
> Right but I'm not sure it's worth quoting RCU and cgroup_mutex. The reason
> why we use threadgroup_change_begin() is not only to ensure the pointer
> validity but also to synchronize the whole cgroup proc logic. This way
> when we attach a whole proc with cgroup_attach_proc(), we are sure that
> no thread forked too soon or too late such that it wouldn't be migrated with
> the rest.
> 
> RCU or cgroup_mutex on dup_task_struct() (+ a get_css_set()) would have
> protected the pointer validity but not the whole above described machinery.
> So I don't think it's even worth quoting those solutions. But if you prefer
> I can keep the old comment.
> 

No, I don't have strong opinion here.

So I'll ack this patch.

> OTOH what I think is missing in the comment is that explanation on the synchronization
> against entire proc migration. I can edit that.
> 

I would appreciate this. :)

>>
>>>   * might no longer be a valid cgroup pointer.  cgroup_attach_task() might
>>>   * have already changed current->cgroups, allowing the previously
>>>   * referenced cgroup group to be removed and freed.
>>> @@ -4566,10 +4566,14 @@ static const struct file_operations proc_cgroupstats_operations = {
>>>   */
>>>  void cgroup_fork(struct task_struct *child)
>>>  {
>>> -	task_lock(current);
>>> +	/*
>>> +	 * We don't need to task_lock() current because current->cgroups
>>> +	 * can't be changed concurrently here. The parent obviously hasn't
>>> +	 * exited and called cgroup_exit(), and we are synchronized against
>>> +	 * cgroup migration through threadgroup_change_begin().
>>> +	 */
>>>  	child->cgroups = current->cgroups;
>>>  	get_css_set(child->cgroups);
>>> -	task_unlock(current);
>>>  	INIT_LIST_HEAD(&child->cg_list);
>>>  }
>>>  
> 
