Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1IBOQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:16:38 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:34893 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1IBOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:16:35 -0400
Date: Fri, 2 Sep 2011 10:15:50 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bblum@andrew.cmu.edu, fweisbec@gmail.com, neilb@suse.de,
        paul@paulmenage.org, paulmck@linux.vnet.ibm.com
Subject: Re: +
 cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch added to
 -mm tree
Message-ID: <20110902141550.GA24012@unix33.andrew.cmu.edu>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org>
 <20110902123706.GB26764@redhat.com>
 <20110902140015.GA31530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902140015.GA31530@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1500_1599 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 04:00:15PM +0200, Oleg Nesterov wrote:
> Forgot to mention, sorry...
> 
> That said, I believe the patch is correct and should fix the problem.

Thanks!

But I don't think the check becomes pointless? If a sub-thread execs
right before read_lock(&tasklist_lock) (but after the find_task_by_vpid
in attach_task_by_pid), that causes the case that the comment refers to.

-- Ben

> 
> On 09/02, Oleg Nesterov wrote:
> >
> > > From: Ben Blum <bblum@andrew.cmu.edu>
> > >
> > > Fix unstable tasklist locking in cgroup_attach_proc.
> > >
> > > According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
> > > not sufficient to guarantee the tasklist is stable w.r.t.  de_thread and
> > > exit.  Taking tasklist_lock for reading, instead of rcu_read_lock, ensures
> > > proper exclusion.
> >
> > I still think we should avoid the global lock.
> >
> > In any case, with tasklist or siglock,
> >
> > > -	rcu_read_lock();
> > > +	read_lock(&tasklist_lock);
> > >  	if (!thread_group_leader(leader)) {
> > >  		/*
> > >  		 * a race with de_thread from another thread's exec() may strip
> > > @@ -2036,7 +2036,7 @@ int cgroup_attach_proc(struct cgroup *cg
> > >  		 * throw this task away and try again (from cgroup_procs_write);
> > >  		 * this is "double-double-toil-and-trouble-check locking".
> > >  		 */
> > > -		rcu_read_unlock();
> > > +		read_unlock(&tasklist_lock);
> > >  		retval = -EAGAIN;
> >
> > this check+comment becomes completely pointless and imho very confusing.
> >
> > Oleg.
> 
> 
