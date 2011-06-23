Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab1FWJOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:14:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53826 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab1FWJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EkwjsRR1NmrApOWTnuQlNeJfu5r5+nsly61MjuRiwyk8AXmw3Yg+nd651VIOsaoimm
         58c4uGne3eGnh3cthXs6u//VFVQSRnYPlclyVeRBD7Sw0rXL3XCyPO+BD2ww9kG3F4Uz
         m/buyVE8HfYMez5+CXJ2FQOv43AeuMTOmaz+8=
Date: Thu, 23 Jun 2011 11:14:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org,
        John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/7] ptrace: s/tracehook_tracer_task()/ptrace_parent()/
Message-ID: <20110623091400.GH30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-8-git-send-email-tj@kernel.org>
 <20110620201603.GA17157@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620201603.GA17157@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 20, 2011 at 10:16:03PM +0200, Oleg Nesterov wrote:
> On 06/17, Tejun Heo wrote:
> >
> > tracehook.h is on the way out.  Rename tracehook_tracer_task() to
> > ptrace_parent() and move it from tracehook.h to ptrace.h.
> 
> I am a bit surpised you decided to keep this helper. Can't we simply
> kill it?

I was being a bit lazy.  If it can be killed, it would be great.

> OK, we will see. I guess this change is mostly needed to remove yet
> another function from tracehook.h.
> 
> > @@ -216,7 +216,7 @@ static struct mm_struct *__check_mem_permission(struct task_struct *task)
> >  	if (task_is_stopped_or_traced(task)) {
> >  		int match;
> >  		rcu_read_lock();
> > -		match = (tracehook_tracer_task(task) == current);
> > +		match = (ptrace_parent(task) == current);
> >  		rcu_read_unlock();
> >  		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
> 
> All we need
> 
> 	if (task_is_traced(task) && task->parent == current) {
> 		if (ptrace_may_access()
> 			return mm;
> 	}
> 
> Of course I do not blame this patch, my only point is that this helper
> only adds more confusion imho.

Yeah, it didn't seem like all the users actually required rcu
dereferencing and both the tracehook and ptrace function names are
confusing and not consistent in their use.  We can convert the ones
which don't require rcu dereferencing to use ->parent directly and if
the left ones are few enough, maybe kill the helper altogether.

Thanks.

-- 
tejun
