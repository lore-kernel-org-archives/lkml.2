Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2JRUxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:53:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35721 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2JRUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <20121018200705.GG13370@google.com>
References: <20121008020000.GB2575@localhost>
	<CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
	<20121016193341.GD16166@google.com>
	<CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
	<20121018200705.GG13370@google.com>
Date: Thu, 18 Oct 2012 22:53:47 +0200
Message-ID: <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/18 Tejun Heo <tj@kernel.org>:
> Hello, Frederic.
>
> On Thu, Oct 18, 2012 at 04:50:59PM +0200, Frederic Weisbecker wrote:
>> Ah right I was confused. Hmm, indeed we have a race here on
>> cgroup_fork(). How about using css_try_get() in cgroup_fork() and
>> refetch the parent's css until we succeed? This requires rcu_read_lock
>> though, and freeing the css_set under RCU.
>>
>> Don't know which is better.
>
> For now, I'll revert the patches and cc stable.  Let's think about
> improving it later.

Ok for reverting in cgroup_fork(). Is it necessary for the
cgroup_post_fork() thing? I don't immediately see any race involved
there.

>> Different problem but I really would like we sanitize the cgroup hooks
>> in fork. There is cgroup_fork(), cgroup_post_fork() which takes that
>> big css_set_lock, plus the big threadgroup lock... I hope we can
>> simplify the mess there.
>
> Oh yeah, I've been looking at that one too.  There are a few problems
> in that area.  I think all we need is clearing ->cgroups to NULL on
> copy_process() and all the rest can be moved to cgroup_post_fork().
> I'd also like to make it very explicit that migration can't happen
> before post_fork is complete.

Sounds right.

>
>> > I really don't know.  Why isn't it locking the threadgroup to begin
>> > with?
>>
>> No idea, sounds like something to fix.
>
> Alrighty.

Ok thanks.

> Thanks.
>
> --
> tejun
