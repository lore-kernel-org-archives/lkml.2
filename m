Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1KRXt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:49:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56254 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1KRXt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:49:26 -0500
Date: Fri, 18 Nov 2011 15:49:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
In-Reply-To: <4EC62AEA.2030602@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com> <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com> <4EC62AEA.2030602@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Miao Xie wrote:

> >> I find these is another problem, please take account of the following case:
> >>
> >>   2-3 -> 1-2 -> 0-1
> >>
> >> the user change mems_allowed twice continuously, the task may see the empty
> >> mems_allowed.
> >>
> >> So, it is still dangerous.
> >>
> > 
> > With this patch, we're protected by task_lock(tsk) to determine whether we 
> > want to take the exception, i.e. whether need_loop is false, and the 
> > setting of tsk->mems_allowed.  So this would see the nodemask change at 
> > the individual steps from 2-3 -> 1-2 -> 0-1, not some inconsistent state 
> > in between or directly from 2-3 -> 0-1.  The only time we don't hold 
> > task_lock(tsk) to change tsk->mems_allowed is when tsk == current and in 
> > that case we're not concerned about intermediate reads to its own nodemask 
> > while storing to a mask where MAX_NUMNODES > BITS_PER_LONG.
> > 
> > Thus, there's no problem here with regard to such behavior if we exclude 
> > mempolicies, which this patch does.
> > 
> 
> No.
> When the task does memory allocation, it access its mems_allowed without
> task_lock(tsk), and it may be blocked after it check 0-1 bits. And then, the
> user changes mems_allowed twice continuously(2-3(initial state) -> 1-2 -> 0-1),
> After that, the task is woke up and it see the empty mems_allowed.
> 

I'm confused, you're concerned on a kernel where 
MAX_NUMNODES > BITS_PER_LONG about thread A reading a partial 
tsk->mems_allowed, being preempted, meanwhile thread B changes 
tsk->mems_allowed by taking cgroup_mutex, taking task_lock(tsk), setting 
the intersecting nodemask, releasing both, taking them again, changing the 
nodemask again to be disjoint, then the thread A waking up and finishing 
its read and seeing an intersecting nodemask because it is now disjoint 
from the first read?
