Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1KXVWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:22:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1KXVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:22:39 -0500
Date: Thu, 24 Nov 2011 13:22:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111124212233.GC6735@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111113164426.GB9446@somewhere>
 <20111121215839.GL25776@google.com>
 <20111123140139.GB10669@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123140139.GB10669@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Wed, Nov 23, 2011 at 03:02:05PM +0100, Frederic Weisbecker wrote:
> This:
> 
>  static inline void threadgroup_lock(struct task_struct *tsk)                                                                
>  {                                                                                                                           
> +       /* exec uses exit for de-threading, grab cred_guard_mutex first */                                                   
> +       mutex_lock(&tsk->signal->cred_guard_mutex);                                                                          
>         down_write(&tsk->signal->group_rwsem);
> 
> is really not obvious.
> 
> Just point out we want to synchronize against the leader, pid and the sighand
> that may change concurrently.

Sure thing.  Will beef up the comments.

> > > Also note this is currently protected by the tasklist readlock. Cred
> > > guard mutex is certainly better, I just don't remember if you remove
> > > the tasklist lock in a further patch.
> > 
> > I don't remove tasklist_lock.
> 
> I believe you can do it after using the cred guard mutex. That needs to
> be double checked though. I think it was mostly there to keep while_each_thread()
> stable non-racy against leader change. cred_guard_mutex should handle that
> now.

Yes, probably, but I still don't think removing that is a good idea.
We're walking tasklist in a rather cold path, IMHO it's better to keep
the locking obvious.

> > So, to me, what seems more important is how to make it easier for each
> > cgroup client instead of what's the minimal that's necessary right
> > now.
> > 
> > Heh, did I make any sense? :)
> 
> Yep, fine for me :)
> Just wanted to ensure I (and others) understood and identified well the issues
> and the fixes.

Yeap, fair enough.  Will update the patches, repost and push them
through cgroup/for-3.3, and move onto other pending patchsets.

Thank you.

-- 
tejun
