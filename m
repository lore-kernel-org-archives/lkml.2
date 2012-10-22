Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2JVJaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:30:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48876 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JVJaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121020223709.GA5626@htj.dyndns.org>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
	<CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
	<20121019193808.GL13370@google.com>
	<CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
	<20121019210738.GA1180@google.com>
	<CAFTL4hy+vrvJKrc1Y2FW44k=LBi72H=34337xALpbtG_3u5O7w@mail.gmail.com>
	<20121020223709.GA5626@htj.dyndns.org>
Date: Mon, 22 Oct 2012 11:30:18 +0200
Message-ID: <CAFTL4hyW+WUUye2BTf5V+Qp_nDVjUnedutoOe-wbU1hT5wgHig@mail.gmail.com>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/21 Tejun Heo <tj@kernel.org>:
> Hello, Frederic.
>
> On Sat, Oct 20, 2012 at 02:21:43PM -0400, Frederic Weisbecker wrote:
>> CPU 0
>>                     CPU 1
>>
>> cgroup_task_migrate {
>>         task_lock(p)
>>         rcu_assign_pointer(tsk->cgroups, newcg);
>>         task_unlock(tsk);
>>
>>         write_lock(&css_set_lock);
>>         if (!list_empty(&tsk->cg_list))
>>             list_move(&tsk->cg_list, &newcg->tasks);
>>         write_unlock(&css_set_lock);
>>
>>                           write_lock(&css_set_lock);
>>       put_css_set(oldcg);
>>          list_add(&child->cg_list, &child->cgroups->tasks); (1)
>
> Man, that's confusing. :)

Sorry and I'm currently stuck in some airport and too lazy to reorder
the above lines :)

>
>> On (1), child->cgroups should have the value of newcg and not oldcg
>> due to the memory ordering implied by the locking of css_set_lock. Now
>> I can't guarantee that because I'm no memory ordering expert. And even
>> if it's safe, it's so very non obvious that I now agree with you:
>> let's revert  the patch and restart with a better base by gathering
>> all the cgroup fork code in the current cgroup_post_fork place.
>
> Aye aye, let's move everything to cgroup_post_fork() and then we don't
> have to worry about grabbing task_lock multiple times.

Agreed. and Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
