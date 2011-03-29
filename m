Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1C2APs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:15:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36070 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1C2APr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:15:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 09:09:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329090924.6a565ef3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110328114430.GE5693@tiehlicka.suse.cz>
References: <20110328093957.089007035@suse.cz>
	<20110328200332.17fb4b78.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328114430.GE5693@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 13:44:30 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Mon 28-03-11 20:03:32, KAMEZAWA Hiroyuki wrote:
> > On Mon, 28 Mar 2011 11:39:57 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > 
> > Isn't it the same result with the case where no cgroup is used ?
> 
> Yes and that is the point of the patchset. Memory cgroups will not give
> you anything else but the top limit wrt. to the global memory activity.
> 
> > What is the problem ?
> 
> That we cannot prevent from paging out memory of process(es), even though
> we have intentionaly isolated them in a group (read as we do not have
> any other possibility for the isolation), because of unrelated memory
> activity.
> 
Because the design of memory cgroup is not for "defending" but for 
"never attack some other guys".


> > Why it's not a problem of configuration ?
> > IIUC, you can put all logins to some cgroup by using cgroupd/libgcgroup.
> 
> Yes, but this still doesn't bring the isolation.
> 

Please explain this more.
Why don't you move all tasks under /root/default <- this has some limit ?


> > Maybe you just want "guarantee".
> > At 1st thought, this approarch has 3 problems. And memcg is desgined
> > never to prevent global vm scans,
> > 
> > 1. This cannot be used as "guarantee". Just a way for "don't steal from me!!!"
> >    This just implements a "first come, first served" system.
> >    I guess this can be used for server desgines.....only with very very careful play.
> >    If an application exits and lose its memory, there is no guarantee anymore.
> 
> Yes, but once it got the memory and it needs to have it or benefits from
> having it resindent what-ever happens around then there is no other
> solution than mlocking the memory which is not ideal solution all the
> time as I have described already.
> 

Yes, then, almost all mm guys answer has been "please use mlock".



> > 
> > 2. Even with isolation, a task in memcg can be killed by OOM-killer at
> >    global memory shortage.
> 
> Yes it can but I think this is a different problem. Once you are that
> short of memory you can hardly ask from any guarantees.
> There is no 100% guarantee about anything in the system.
> 

I think you should put tasks in root cgroup to somewhere. It works perfect
against OOM. And if memory are hidden by isolation, OOM will happen easier.


> > 
> > 3. it seems this will add more page fragmentation if implemented poorly, IOW,
> >    can this be work with compaction ?
> 
> Why would it add any fragmentation. We are compacting memory based on
> the pfn range scanning rather than walking global LRU list, aren't we?
> 

Please forget, I misunderstood.




> > I think of other approaches.
> > 
> > 1. cpuset+nodehotplug enhances.
> >    At boot, hide most of memory from the system by boot option.
> >    You can rename node-id of "all unused memory" and create arbitrary nodes
> >    if the kernel has an interface. You can add a virtual nodes and move
> >    pages between nodes by renaming it.
> > 
> >    This will allow you to create a safe box dynamically. 
> 
> This sounds as it requires a completely new infrastructure for many
> parts of VM code. 
> 

Not so many parts, I guess. I think I can write a prototype in a week,
if I have time.


> >    If you move pages in
> >    the order of MAX_ORDER, you don't add any fragmentation.
> >    (But with this way, you need to avoid tasks in root cgrou, too.)
> > 
> > 
> > 2. allow a mount option to link ROOT cgroup's LRU and add limit for
> >    root cgroup. Then, softlimit will work well.
> >    (If softlimit doesn't work, it's bug. That will be an enhancement point.)
> 
> So you mean that the root cgroup would be a normal group like any other?
> 

If necessary. Root cgroup has no limit/LRU/etc...just for gaining performance.
If admin can adimit the cost (2-5% now?), I think we can add knobs as boot
option or some.

Anyway, to work softlimit etc..in ideal way, admin should put all tasks into
some memcg which has limits.

Thanks,
-Kame






