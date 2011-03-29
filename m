Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1C2H5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:57:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59754 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1C2H5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:57:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 16:51:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329165117.179d87f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110329073232.GB30671@tiehlicka.suse.cz>
References: <20110328093957.089007035@suse.cz>
	<20110328200332.17fb4b78.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328114430.GE5693@tiehlicka.suse.cz>
	<20110329090924.6a565ef3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110329073232.GB30671@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 09:32:32 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 29-03-11 09:09:24, KAMEZAWA Hiroyuki wrote:
> > On Mon, 28 Mar 2011 13:44:30 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Mon 28-03-11 20:03:32, KAMEZAWA Hiroyuki wrote:
> > > > On Mon, 28 Mar 2011 11:39:57 +0200
> > > > Michal Hocko <mhocko@suse.cz> wrote:
> > > [...]
> > > > 
> > > > Isn't it the same result with the case where no cgroup is used ?
> > > 
> > > Yes and that is the point of the patchset. Memory cgroups will not give
> > > you anything else but the top limit wrt. to the global memory activity.
> > > 
> > > > What is the problem ?
> > > 
> > > That we cannot prevent from paging out memory of process(es), even though
> > > we have intentionaly isolated them in a group (read as we do not have
> > > any other possibility for the isolation), because of unrelated memory
> > > activity.
> > > 
> > Because the design of memory cgroup is not for "defending" but for 
> > "never attack some other guys".
> 
> Yes, I am aware of the current state of implementation. But as the
> patchset show there is not quite trivial to implement also the other
> (defending) part.
> 

My opinions is to enhance softlimit is better.


> > 
> > 
> > > > Why it's not a problem of configuration ?
> > > > IIUC, you can put all logins to some cgroup by using cgroupd/libgcgroup.
> > > 
> > > Yes, but this still doesn't bring the isolation.
> > > 
> > 
> > Please explain this more.
> > Why don't you move all tasks under /root/default <- this has some limit ?
> 
> OK, I have tried to explain that in one of the (2nd) patch description.
> If I move all task from the root group to other group(s) and keep the
> primary application in the root group I would achieve some isolation as
> well. That is very much true. 

Okay, then, current works well.

> But then there is only one such a group.

I can't catch what you mean. you can create limitless cgroup, anywhere.
Can't you ?

> What if we need more such groups? I see this solution more as a misuse
> of the current implementation of the (special) root cgroup.
> 

make a limitless cgroup and set softlimit properly, if necessary.
But as said in other e-mail, softlimit should be improved.


> > > > Maybe you just want "guarantee".
> > > > At 1st thought, this approarch has 3 problems. And memcg is desgined
> > > > never to prevent global vm scans,
> > > > 
> > > > 1. This cannot be used as "guarantee". Just a way for "don't steal from me!!!"
> > > >    This just implements a "first come, first served" system.
> > > >    I guess this can be used for server desgines.....only with very very careful play.
> > > >    If an application exits and lose its memory, there is no guarantee anymore.
> > > 
> > > Yes, but once it got the memory and it needs to have it or benefits from
> > > having it resindent what-ever happens around then there is no other
> > > solution than mlocking the memory which is not ideal solution all the
> > > time as I have described already.
> > > 
> > 
> > Yes, then, almost all mm guys answer has been "please use mlock".
> 
> Yes. As I already tried to explain, mlock is not the remedy all the
> time. It gets very tricky when you balance on the edge of the limit of
> the available memory resp. cgroup limit. Sometimes you rather want to
> have something swapped out than being killed (or fail due to ENOMEM).
> The important thing about swapped out above is that with the isolation
> it is only per-cgroup.
> 

IMHO, doing isolation by hiding is not good idea. Because we're kernel
engineer, we should do isolation by scheduling. The kernel is art of
shceduling, not separation. I think we should start from some scheduling 
as softlimit. Then, as an extreme case of scheduling, 'complete isolation' 
should be archived. If it seems impossible after trial of making softlimit
better, okay, we should consider some.

BTW, if you want, please post a patch to enable limit/softlimit on ROOT
cgroup with performance measurements.
I myself has no requirements...


> > > > 2. Even with isolation, a task in memcg can be killed by OOM-killer at
> > > >    global memory shortage.
> > > 
> > > Yes it can but I think this is a different problem. Once you are that
> > > short of memory you can hardly ask from any guarantees.
> > > There is no 100% guarantee about anything in the system.
> > > 
> > 
> > I think you should put tasks in root cgroup to somewhere. It works perfect
> > against OOM. And if memory are hidden by isolation, OOM will happen easier.
> 
> Why do you think that it would happen easier? Isn't it similar (from OOM
> POV) as if somebody mlocked that memory?
> 

if global lru scan cannot find victim memory, oom happens.

Thanks,
-Kame




