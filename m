Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1LUAMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:12:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51151 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1LUAMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:12:18 -0500
Date: Tue, 20 Dec 2011 16:02:31 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 5/5] cgroup: separate out cgroup_attach_proc error
 handling code
Message-ID: <20111221000231.GX13529@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-6-git-send-email-msb@chromium.org>
 <20111220233502.GN10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220233502.GN10752@google.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> Hello,
> 
> On Tue, Dec 20, 2011 at 03:14:33PM -0800, Mandeep Singh Baines wrote:
> > @@ -2067,9 +2067,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	read_unlock(&tasklist_lock);
> >  
> >  	/* methods shouldn't be called if no task is actually migrating */
> > -	retval = 0;
> > -	if (!group_size)
> > +	if (!group_size) {
> > +		retval = 0;
> >  		goto out_free_group_list;
> > +	}
> 
> Eh... I don't think this is an improvement.  It's just different.
> 

The main benefit is that the comment is directly above the code its
describing but I can drop this part of the change.

> > @@ -2126,20 +2127,20 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	 */
> >  	synchronize_rcu();
> >  	cgroup_wakeup_rmdir_waiter(cgrp);
> > -	retval = 0;
> > +	flex_array_free(group);
> > +	return 0;
> 
> Hmm... maybe goto out_free_group_list?  Duplicating cleanup on success
> and failure paths can lead future updaters forget one of them.  The
> exit path in this function isn't pretty but I don't think the proposed
> patch improves it either.
> 

Should I drop the patch or add the goto? Its 5/5 so easy enough to drop
since nothing else depends on it.

> Thanks.
> 
> -- 
> tejun
