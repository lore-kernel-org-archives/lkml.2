Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2DISJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:09:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59287 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2DISJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:09:40 -0400
Date: Mon, 9 Apr 2012 11:09:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, Paul Turner <pjt@google.com>,
        cgroups@vger.kernel.org, "devel@openvz.org" <devel@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: bind() call in cgroup's css structure
Message-ID: <20120409180932.GB7522@google.com>
References: <4F82EB5C.7090003@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F82EB5C.7090003@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Mon, Apr 09, 2012 at 10:59:56AM -0300, Glauber Costa wrote:
> During your cgroup refactor, I was wondering if you have any plans
> to get rid of the bind() callback that is called when hierarchies
> are moved?
>
> At least in tree, there seems to be no users for that.

I don't have any current plan for the callback but if it doesn't have
in-kernel user, I'd prefer to remove it.

> I actually planned to use it myself, to start or remove a jump label
> when cpuacct and cpu cgroups were comounted.

I see.

> Problem is, because we have some calls in the cpuset cgroup from
> inside the cpu hotplug handler, we end up taking the almighty
> cgroup_mutex from inside the cpu_hotplug.lock.

Yeah, those two are pretty big locks.

> jump labels take it in most arches through the get_online_cpus()
> function call. This means we effectively can't apply jump labels
> with the cgroup_mutex held, which is the case throughout the whole
> bind() call.
> 
> All that explained, I figured I might as well ask before I attempted
> a solution to that myself: as much as populate(), bind seems to be
> one of the overly complicated callbacks, designed for a scenario in
> which everything can come and go at will, which is something we're
> trying to fix.

I haven't read the code so this could be completely off but if this is
jump label optimization which can be made to work w/o it immediately
applied, maybe just punt it to a work item from the callback?  Note
that if cancellation is necessary for e.g. unbinding, it may
re-introduce locking dependency through flushing.

Thanks.

-- 
tejun
