Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2CLQKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:10:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61414 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2CLQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:10:49 -0400
Date: Mon, 12 Mar 2012 09:10:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        =?utf-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Message-ID: <20120312161040.GA23255@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
 <20120309165313.GA24890@google.com>
 <4F5DBB8C.6090904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DBB8C.6090904@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 12, 2012 at 05:02:04PM +0800, Li Zefan wrote:
> - We still need some kind of locking to syncronize fork and the traverser.
> fork side is protected by tasklist_lock, while the traverser takes
> css_set_lock.

Can't we do both after tasklist_lock is released under css_set_lock?

> - After linking the new task to css set list, the task is visible and thus
> can be moved to another cgroup, which makes things more complicated and
> the subsystem callbacks may have to acquire cgroup_mutex.

Hmmm... freezer currently doesn't allow migrating in and out of frozen
cgroup and even when it does callbacks in the migration path should
synchronize against freezer->lock.  I *think* that should be enough
and can't see why this will be simpler or more complex depending on
when fork callback is called.

> - The task_counter subsystem wants to get notified before the new task
> is linked, so it's able to abort the fork.

This one maybe but for this cgroup_fork_callbacks() is already too
late, isn't it?  We better have pre-fork callbacks instead, no?

Thanks.

-- 
tejun
