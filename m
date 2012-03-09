Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2CIQxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:53:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56481 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555Ab2CIQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:53:18 -0500
Date: Fri, 9 Mar 2012 08:53:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        =?utf-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Message-ID: <20120309165313.GA24890@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F59A27D.9080705@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Mar 09, 2012 at 02:26:05PM +0800, Li Zefan wrote:
> The problem is, forks can happen at any time, so there's no way to prevent
> forks from happening while iterating tasks in a cgroup, so controllers
> have to deal with it. In fact freezer is somewhat aware of this issue,
> that's why it provides the ->fork callback, but there's race.
> 
> This patch is not too bad (needs a bit modification). cgroup core will detect
> (via seqcount) if something's happened to a cgroup and the tasks in it, and
> then cgroup will notify controllers to check if newly-forked tasks should
> be adjusted accordingly, so they will have consistent status with other tasks
> in the same cgroup.

But why can't we just do what every sane subsystem would do - link
first and then invoke notification callback?  I mean, we're now
essentially trying to do the following.

1. Take some action.
2. Trigger notification.
3. Link the result of the action to list.

So, of course, if someone tries to traverse the "results", there's a
race window between #2 and #3.  Your fix seems to change the traverser
to,

1. Traverse the list.
2. If something happened inbetween, take another look.

But, the right thing to do would be changing the fork path to

1. Take some action.
2. Link the result of the action to list.
3. Trigger notification.

If I'm missing something, please don't feel shy to hammer it into me
as I'm feeling very lost at the moment.

Thanks.

-- 
tejun
