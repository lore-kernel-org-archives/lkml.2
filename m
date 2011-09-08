Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1IHCMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:12:12 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:48640 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab1IHCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:12:09 -0400
Date: Wed, 7 Sep 2011 22:11:42 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: more safe tasklist locking in
 cgroup_attach_proc
Message-ID: <20110908021141.GB22545@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20110901214643.GD10401@unix33.andrew.cmu.edu>
 <20110902123251.GA26764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902123251.GA26764@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.18.170322
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 02:32:51PM +0200, Oleg Nesterov wrote:
> On 09/01, Ben Blum wrote:
> >
> > On Mon, Aug 15, 2011 at 08:49:57PM +0200, Oleg Nesterov wrote:
> > >
> > > But can't we avoid the global list? thread_group_leader() or not, we do
> > > not really care. We only need to ensure we can safely find all threads.
> > >
> > > How about the patch below?
> >
> > I was content with the tasklist_lock because cgroup_attach_proc is
> > already a pretty heavyweight operation, and probably pretty rare that a
> > user would want to do multiple of them at once quickly.
> 
> Perhaps. But this is the global lock, no matter what. Why do you prefer
> to take it instead of per-process ->siglock?

Basically just because I wanted to find the simplest race-free
implementation - at that point I was just shooting to have a complete
set of patches, and didn't judge the global lock to be bad enough to
think about replacing. I could yet be convinced that siglock is better.

> 
> > I asked Andrew
> > to take the simple tasklist_lock patch just now, since it does fix the
> > bug at least.
> 
> I disagree.
> 
> > Anyway, looking at this, hmm. I am not sure if this protects adequately?
> > In de_thread, the sighand lock is held only around the first half
> > (around zap_other_threads),
> 
> We only need this lock to find all threads,
> 
> > and not around the following section where
> > leadership is transferred (esp. around the list_replace calls).
> > tasklist_lock is held here, though, so it seems like the right lock to
> > hold.
> 
> This doesn't matter at all, I think. The code under while_each_thread()
> doesn't need the stable ->group_leader, and it can be changed right after
> you drop tasklist. list_replace() calls do not play with ->thread_group
> list.
> 
> How can tasklist make any difference?

Oops. I misread the list_replace calls as being on ->thread_group,
instead of on ->tasks as they actually are. Hm, and I see __exit_signal
takes the sighand lock around the call to __unhash_process.

OK, I believe it will work. Oh, and I guess the sighand lock also
subsumes the group_leader check that you were objecting to in the other
thread.

Sorry for the delay. Any way this change goes through, though, the
commenting should be clear on how de_thread interacts with it. Something
like:

/* If the leader exits, its links on the thread_group list become
 * invalid. One way this can happen is if a sub-thread does exec() when
 * de_thread() calls release_task(leader) (and leader->sighand gets set
 * to NULL, in which case lock_task_sighand will fail). Since in that
 * case the threadgroup is still around, cgroup_procs_write should try
 * again (finding the new leader), which EAGAIN indicates here. This is
 * "double-double-toil-and-trouble-check locking". */

(I rather like the phrase "double-double-..." to describe the overall
approach, and would prefer if it stayed in the comment.)

> 
> > > With or without this/your patch this leader can die right after we
> > > drop the lock. ss->can_attach(leader) and ss->attach(leader) look
> > > suspicious. If a sub-thread execs, this task_struct has nothing to
> > > do with the threadgroup.
> >
> > hmm. I thought I had this case covered, but it's been so long since I
> > actually wrote the code that if I did I can't remember how.
> 
> This all doesn't look right... Hopefully addressed by Tejun patches.
> 

Will look into those separately.

Thanks,
Ben

> 
> Oleg.
> 
> 
