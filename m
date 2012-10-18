Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2JROvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:51:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62091 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2JROvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:51:01 -0400
MIME-Version: 1.0
In-Reply-To: <20121016193341.GD16166@google.com>
References: <20121008020000.GB2575@localhost>
	<CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
	<20121016193341.GD16166@google.com>
Date: Thu, 18 Oct 2012 16:50:59 +0200
Message-ID: <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 Tejun Heo <tj@kernel.org>:
> Hey, Frederic.
>
> On Mon, Oct 08, 2012 at 02:48:58PM +0200, Frederic Weisbecker wrote:
>> Yeah I missed this one.
>> Now the whole cgroup_attach_task() is clusteracy without the
>
> Clusteracy?
>
>> threadgroup lock anyway:
>>
>> * The PF_EXITING check is racy (we are neither holding tsk->flags nor
>> threagroup lock).
>
> PF_EXITING is *always* protected by threadgroup_change_begin/end().
>
>> * The cgrp == oldcgrp is racy (exit() can change the oldcgrp anytime.
>
> So, as long as this happens after PF_EXITING check, it should be safe.
>
>> * can_attach / attach / cancel_attach can race against fork/exit (and
>> post_fork if you consider those interested in cgroup task link like
>> the freezer. But that is racy in any case already even with
>> threadgroup lock)
>
> Against exit, no.  Against forking a new process, can they?  If so, we
> need to fix it.
>
>> It has been designed to be called under that lock. So I suspect the
>
> Ummm.... threadgroup_lock is a recent addition so things couldn't have
> been designed to be called under that lock.  threadgroup_lock protects
> the *threadgroup* - creating a new task in the same process or a task
> of the process exiting.  It doesn't do anything about other processes.
> In fact, the lock itself is per-process.
>
>> best, at least for now, is to threadgroup lock from
>> cgroup_attach_task_all(). And also make cgroup_attach_task() static to
>> avoid future unsafe callers.
>
> Oh, from that call path, sure.  Can someone teach me why we need that
> one at all?  I think we're confusing each other here.  I was talking
> about the usual migration path not protected against forking a new
> process.

Ah right I was confused. Hmm, indeed we have a race here on
cgroup_fork(). How about using css_try_get() in cgroup_fork() and
refetch the parent's css until we succeed? This requires rcu_read_lock
though, and freeing the css_set under RCU.

Don't know which is better.

Different problem but I really would like we sanitize the cgroup hooks
in fork. There is cgroup_fork(), cgroup_post_fork() which takes that
big css_set_lock, plus the big threadgroup lock... I hope we can
simplify the mess there.

>
>> There is no harm yet because the only user of it calls that with
>> current as the "task" parameter, in a place that is
>> not in the middle of a fork. So no need to worry about some stable backport.
>>
>> Also, looking at cgroup_attach_task_all(), what guarantee do we have
>> that "from" is not concurrently exiting and removing its cgrp. Which
>> is a separate problem. But we probably need to do some css_set_get()
>> before playing with it.
>
> I really don't know.  Why isn't it locking the threadgroup to begin
> with?

No idea, sounds like something to fix.
