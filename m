Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2JRUHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:07:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56417 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2JRUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:07:10 -0400
Date: Thu, 18 Oct 2012 13:07:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Message-ID: <20121018200705.GG13370@google.com>
References: <20121008020000.GB2575@localhost>
 <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
 <20121016193341.GD16166@google.com>
 <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Thu, Oct 18, 2012 at 04:50:59PM +0200, Frederic Weisbecker wrote:
> Ah right I was confused. Hmm, indeed we have a race here on
> cgroup_fork(). How about using css_try_get() in cgroup_fork() and
> refetch the parent's css until we succeed? This requires rcu_read_lock
> though, and freeing the css_set under RCU.
> 
> Don't know which is better.

For now, I'll revert the patches and cc stable.  Let's think about
improving it later.

> Different problem but I really would like we sanitize the cgroup hooks
> in fork. There is cgroup_fork(), cgroup_post_fork() which takes that
> big css_set_lock, plus the big threadgroup lock... I hope we can
> simplify the mess there.

Oh yeah, I've been looking at that one too.  There are a few problems
in that area.  I think all we need is clearing ->cgroups to NULL on
copy_process() and all the rest can be moved to cgroup_post_fork().
I'd also like to make it very explicit that migration can't happen
before post_fork is complete.

> > I really don't know.  Why isn't it locking the threadgroup to begin
> > with?
> 
> No idea, sounds like something to fix.

Alrighty.

Thanks.

-- 
tejun
