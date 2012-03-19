Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572Ab2CSNoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:44:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33500 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2CSNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:44:22 -0400
Date: Mon, 19 Mar 2012 14:44:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        =?utf-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Message-ID: <20120319134413.GC2660@somewhere>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
 <20120309165313.GA24890@google.com>
 <4F5DBB8C.6090904@cn.fujitsu.com>
 <20120312161040.GA23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312161040.GA23255@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:10:40AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Mar 12, 2012 at 05:02:04PM +0800, Li Zefan wrote:
> > - We still need some kind of locking to syncronize fork and the traverser.
> > fork side is protected by tasklist_lock, while the traverser takes
> > css_set_lock.
> 
> Can't we do both after tasklist_lock is released under css_set_lock?
> 
> > - After linking the new task to css set list, the task is visible and thus
> > can be moved to another cgroup, which makes things more complicated and
> > the subsystem callbacks may have to acquire cgroup_mutex.
> 
> Hmmm... freezer currently doesn't allow migrating in and out of frozen
> cgroup and even when it does callbacks in the migration path should
> synchronize against freezer->lock.  I *think* that should be enough
> and can't see why this will be simpler or more complex depending on
> when fork callback is called.
> 
> > - The task_counter subsystem wants to get notified before the new task
> > is linked, so it's able to abort the fork.
> 
> This one maybe but for this cgroup_fork_callbacks() is already too
> late, isn't it?  We better have pre-fork callbacks instead, no?

Nope, cgroup_fork_callbacks() is called soon enough to be able
to cancel a fork. The task counter subsystem cancels from that point.
