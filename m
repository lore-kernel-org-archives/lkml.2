Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2KZTDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:03:35 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60058 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2KZTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:03:33 -0500
Date: Mon, 26 Nov 2012 20:03:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121126190329.GB12602@dhcp22.suse.cz>
References: <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126174622.GE2799@cmpxchg.org>
 <20121126180444.GA12602@dhcp22.suse.cz>
 <20121126182421.GB2301@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126182421.GB2301@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-11-12 13:24:21, Johannes Weiner wrote:
> On Mon, Nov 26, 2012 at 07:04:44PM +0100, Michal Hocko wrote:
> > On Mon 26-11-12 12:46:22, Johannes Weiner wrote:
[...]
> > > I think global oom already handles this in a much better way: invoke
> > > the OOM killer, sleep for a second, then return to userspace to
> > > relinquish all kernel resources and locks.  The only reason why we
> > > can't simply change from an endless retry loop is because we don't
> > > want to return VM_FAULT_OOM and invoke the global OOM killer.
> > 
> > Exactly.
> > 
> > > But maybe we can return a new VM_FAULT_OOM_HANDLED for memcg OOM and
> > > just restart the pagefault.  Return -ENOMEM to the buffered IO syscall
> > > respectively.  This way, the memcg OOM killer is invoked as it should
> > > but nobody gets stuck anywhere livelocking with the exiting task.
> > 
> > Hmm, we would still have a problem with oom disabled (aka user space OOM
> > killer), right? All processes but those in mem_cgroup_handle_oom are
> > risky to be killed.
> 
> Could we still let everybody get stuck in there when the OOM killer is
> disabled and let userspace take care of it?

I am not sure what exactly you mean by "userspace take care of it" but
if those processes are stuck and holding the lock then it is usually
hard to find that out. Well if somebody is familiar with internal then
it is doable but this makes the interface really unusable for regular
usage.

> > Other POV might be, why we should trigger an OOM killer from those paths
> > in the first place. Write or read (or even readahead) are all calls that
> > should rather fail than cause an OOM killer in my opinion.
> 
> Readahead is arguable, but we kill globally for read() and write() and
> I think we should do the same for memcg.

Fair point but the global case is little bit easier than memcg in this
case because nobody can hook on OOM killer and provide a userspace
implementation for it which is one of the cooler feature of memcg...
I am all open to any suggestions but we should somehow fix this (and
backport it to stable trees as this is there for quite some time. The
current report shows that the problem is not that hard to trigger).

> The OOM killer is there to resolve a problem that comes from
> overcommitting the machine but the overuse does not have to be from
> the application that pushes the machine over the edge, that's why we
> don't just kill the allocating task but actually go look for the best
> candidate.  If you have one memory hog that overuses the resources,
> attempted memory consumption in a different program should invoke the
> OOM killer.  

> It does not matter if this is a page fault (would still happen with
> your patch) or a bufferd read/write (would no longer happen).

true and it is sad that mmap then behaves slightly different than
read/write which should I've mentioned in the changelog. As I said I am
open to other suggestions.

Thanks
-- 
Michal Hocko
SUSE Labs
