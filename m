Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1JLSsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:48:09 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:47366 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab1JLSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:48:08 -0400
Date: Wed, 12 Oct 2011 14:44:43 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Tejun Heo <htejun@gmail.com>, rjw@sisk.pl,
        paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111012184443.GB21363@ghc17.ghc.andrew.cmu.edu>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-4-git-send-email-htejun@gmail.com>
 <20110918173723.GA2384@redhat.com>
 <20111010171105.GE8100@google.com>
 <20111012175104.GA6156@redhat.com>
 <20111012180521.GA20715@ghc17.ghc.andrew.cmu.edu>
 <20111012182905.GA8580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012182905.GA8580@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, NO_URI_FOUND 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:29:05PM +0200, Oleg Nesterov wrote:
> On 10/12, Ben Blum wrote:
> >
> > On Wed, Oct 12, 2011 at 07:51:04PM +0200, Oleg Nesterov wrote:
> > >
> > > > Also, it makes the mechanism unnecessarily cgroup-specific without
> > > > gaining much if anything.
> > >
> > > Yes! And _personally_ I think it should be cgroup-specific, that is
> > > why I dislike the very fact do_exit() uses it directly. To me it would
> > > be cleaner to shift it into cgroup hooks. Yes, sure, this is subjective.
> >
> > In the fork path, threadgroup_fork_read_...() is also called directly,
> > not through cgroups. Would that change too?
> 
> Well, if you ask me, I'd prefer to move lock/unlock into
> cgroup_fork/cgroup_post_fork ;) Although the error path plays with it
> too. But this is minor.
> 
> > > In fact I still hope we can kill this sem altogether, but so far I have
> > > no idea how we can do this. We do need the new per-process lock to
> > > protect (in particular) ->thread_group. It is quite possible that it
> > > should be rw_semaphore. But in this case we down_write(), not _read
> > > in exit/fork paths, and its scope should be small.
> >
> > I'm confused - taking a big rwsem for writing in the fork/exit paths?
> 
> Yes, we need the new lock to avoid tasklist_lock.

To avoid tasklist_lock in the cgroup path, or in the fork/exit path?

I'm not sure if "avoiding tasklist_lock" should be our goal. The only
real problem as I see it is that ss->attach() can still race exec *if*
it wants to iterate over the whole thread_group, since the "leader"
passed in might not be the leader anymore.

Unless this is just all about trying to avoid taking a global lock?
(which in cgroups we agreed could be done with the sighand lock instead)

As for the ss->attach problem again: Ummm, I have an idea. Why don't we
just alter the ss->attach() interface to pass in the flex_array of
task_structs that are being moved? The flex_array is how we solved the
problem of "having to check thread_group_leader() everywhere before the
commit point" nastiness. No need for the fork_lock to be in the exit
path at all; its current place in the fork path would suffice for this.

Thoughts?

-- Ben

> 
> > The point here is that even though fork/exit modify thread_group, they
> > are logical "readers"
> 
> Yes I see. And this is one of the reasons why we can't use this lock
> for above.
> 
> Oleg.
> 
> 
