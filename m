Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2JTSXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:23:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44061 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2JTSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hy+vrvJKrc1Y2FW44k=LBi72H=34337xALpbtG_3u5O7w@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
	<CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
	<20121019193808.GL13370@google.com>
	<CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
	<20121019210738.GA1180@google.com>
	<CAFTL4hy+vrvJKrc1Y2FW44k=LBi72H=34337xALpbtG_3u5O7w@mail.gmail.com>
Date: Sat, 20 Oct 2012 14:23:31 -0400
Message-ID: <CAFTL4hzwxqBgVBos00snoVaKAxXfv=DL+HermOOA6EsEhfjheA@mail.gmail.com>
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

2012/10/20 Frederic Weisbecker <fweisbec@gmail.com>:
> 2012/10/19 Tejun Heo <tj@kernel.org>:
>> Hello, Frederic.
>>
>> On Fri, Oct 19, 2012 at 03:44:20PM -0400, Frederic Weisbecker wrote:
>>> > For -stable, I think it's better to revert.  If you want to remove
>>> > task_lock, let's do it for 3.8.
>>>
>>> I don't think that a wrong comment justifies a patch to stable.
>>
>> I'm not really sure whether it's safe or not.  It seems all usages are
>> protected by write locking css_set_lock but maybe I'm missing
>> something and as the commit is born out of confusion, I'm very
>> inclined to revert it by default.  Are you sure this one is safe?
>
> Thinking about it further, one scenario is worrying me but it
> eventually looks safe but by accident.
>
> CPU 0
>                     CPU 1
>
> cgroup_task_migrate {
>         task_lock(p)
>         rcu_assign_pointer(tsk->cgroups, newcg);
>         task_unlock(tsk);
>
>         write_lock(&css_set_lock);
>         if (!list_empty(&tsk->cg_list))
>             list_move(&tsk->cg_list, &newcg->tasks);
>         write_unlock(&css_set_lock);
>
>                           write_lock(&css_set_lock);
>         put_css_set(oldcg);
>          list_add(&child->cg_list, &child->cgroups->tasks); (1)

gmail mangled everything :(
