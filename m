Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0KKSbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:31:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0KKSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=SBpIKkgjNhmZdY9/BDH6o+vdx1JwdlXayTMCsLFFXxSfA2barm/rWdeEnhKPrXTmWF
         1UJkKBGbSwBaHQvj0z7Q==
Date: Thu, 11 Nov 2010 10:30:50 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Message-ID: <20101111183050.GI7363@google.com>
References: <20101111043541.GA4588@google.com>
 <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com>
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes (rientjes@google.com) wrote:
> On Wed, 10 Nov 2010, Mandeep Singh Baines wrote:
> 
> > For ChromiumOS, we'd like to be able to oom_adj a process up/down
> > as its leaves/enters the foreground. Currently, it is not possible
> > to oom_adj down without CAP_SYS_RESOURCE. This patch creates a new
> > resource limit, RLIMIT_OOMADJ, which is works in a similar fashion
> > to RLIMIT_NICE. This allows a process's oom_adj to be lowered
> > without CAP_SYS_RESOURCE as long as the new value is greater
> > than the resource limit.
> > 
> 
> First of all, oom_adj is deprecated and scheduled for removal in a couple 
> of years (see Documentation/feature-removal-schedule.txt) so any work in 
> this area should be targeting oom_score_adj instead.
> 

Ah. Thanks for the pointer.

> What is the anticipated use case for this?  We know that you want to lower 
> oom_adj without CAP_SYS_RESOURCE, but what's the expected behavior when an 
> app moves from foreground to background?  I assume it's something like 

The focus here is the web browser's tabs. In our case, each is a process. If
OOM is going to kill a process, you'd rather it kill the tab you looked at
hours ago instead of the one you're looking at now. So you'd like to have a
policy where the LRU tab gets killed first. We'd like to use oom_score_adj
as the mechanism to implement an LRU policy like this.

> having an oom_adj of 0 in the background and +15 in the foreground.  If 
> so, does /proc/sys/vm/oom_kill_allocating_task get you most of what you're 
> looking for?
> 

As explained above, oom_kill_allocating_task won't give us what we want.

> I'm wondering if we can avoid yet another resource limit for something 
> like this.
> 
> > Alternative considered:
> > 
> > * a setuid binary
> > * a daemon with CAP_SYS_RESOURCE
> > 
> > Since you don't wan't all processes to be able to reduce their
> > oom_adj, a setuid or daemon implementation would be complex. The
> > alternatives also have much higher overhead.
> > 
> 
> What do you anticipate will be writing to oom_score_adj with this patch, 
> the app itself?
> 

A process in the browser session will do the adusting. We'd rather not give
it CAP_SYS_RESOURCE. It should only be allowed to change oom_score_adj up
and down within the bounds set by the administrator. Analagous to renice()
which we also do using a similar policy.

> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > ---
> >  fs/proc/base.c                 |   12 ++++++++++--
> >  include/asm-generic/resource.h |    5 ++++-
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index f3d02ca..4384013 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -462,6 +462,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
> >  	[RLIMIT_NICE] = {"Max nice priority", NULL},
> >  	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> >  	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> > +	[RLIMIT_OOMADJ] = {"Max OOM adjust", NULL},
> 
> s/Max/Min, right?
> 

This is a MAX value because of how resource limits work. On the other hand,
it is really controlling the minimum oom_adj. So its a toss up for me.
More than happy to change if you prefer Min.

> >  };
> >  
> >  /* Display limits for a process */
> > @@ -1057,8 +1058,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
> >  	}
> >  
> >  	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
> > -		err = -EACCES;
> > -		goto err_sighand;
> > +		/* convert oom_adj [15,-17] to rlimit style value [1,33] */
> > +		long oom_rlim = OOM_ADJUST_MAX + 1 - oom_adjust;
> > +
> 
> Ouch, that's a rather unfortunate mapping.
> 

Unfortunate but unavoidable. The resource limit code checks to see if the
new limit is greater than the limit. This code was based on the can_nice()
code in sched.c.

> > +		if (oom_rlim > task->signal->rlim[RLIMIT_OOMADJ].rlim_cur) {
> > +			unlock_task_sighand(task, &flags);
> > +			put_task_struct(task);
> > +			err = -EACCES;
> > +			goto err_sighand;
> 
> err_sighand has duplicate unlock_task_sighand() and put_task_struct(); 
> since you're missing the task_unlock(task) here, just using goto 
> err_sighand would suffice.
> 

D'oh. Forward port error. I should be more careful. Thanks for catching:)

> > +		}
> >  	}
> >  
> >  	if (oom_adjust != task->signal->oom_adj) {

Thank you for reviewing this patch.

Should I send an updated oom_score_adj patch?

Regards,
Mandeep
