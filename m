Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1BDVre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:47:34 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:52399 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1BDVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:47:33 -0500
Date: Fri, 4 Feb 2011 16:43:54 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v7 1/3] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-ID: <20110204214354.GB5916@ghc17.ghc.andrew.cmu.edu>
References: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
 <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
 <20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
 <20110124130529.903d9832.akpm@linux-foundation.org>
 <20110204212515.GA5916@ghc17.ghc.andrew.cmu.edu>
 <20110204133657.78aeebe3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204133657.78aeebe3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.4.213617
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 01:36:57PM -0800, Andrew Morton wrote:
> On Fri, 4 Feb 2011 16:25:15 -0500
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > On Mon, Jan 24, 2011 at 01:05:29PM -0800, Andrew Morton wrote:
> > > On Sun, 26 Dec 2010 07:09:51 -0500
> > > Ben Blum <bblum@andrew.cmu.edu> wrote:
> > > 
> > > > Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> > > > 
> > > > From: Ben Blum <bblum@andrew.cmu.edu>
> > > > 
> > > > This patch adds an rwsem that lives in a threadgroup's signal_struct that's
> > > > taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
> > > > the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
> > > > ifdefs should be changed to a higher-up flag that CGROUPS and the other system
> > > > would both depend on.
> > > > 
> > > > This is a pre-patch for cgroup-procs-write.patch.
> > > > 
> > > > ...
> > > >
> > > > +/* See the declaration of threadgroup_fork_lock in signal_struct. */
> > > > +#ifdef CONFIG_CGROUPS
> > > > +static inline void threadgroup_fork_read_lock(struct task_struct *tsk)
> > > > +{
> > > > +	down_read(&tsk->signal->threadgroup_fork_lock);
> > > > +}
> > > > +static inline void threadgroup_fork_read_unlock(struct task_struct *tsk)
> > > > +{
> > > > +	up_read(&tsk->signal->threadgroup_fork_lock);
> > > > +}
> > > > +static inline void threadgroup_fork_write_lock(struct task_struct *tsk)
> > > > +{
> > > > +	down_write(&tsk->signal->threadgroup_fork_lock);
> > > > +}
> > > > +static inline void threadgroup_fork_write_unlock(struct task_struct *tsk)
> > > > +{
> > > > +	up_write(&tsk->signal->threadgroup_fork_lock);
> > > > +}
> > > > +#else
> > > 
> > > Risky. sched.h doesn't include rwsem.h.
> > > 
> > > We could make it do so, but almost every compilation unit in the kernel
> > > includes sched.h.  It would be nicer to make the kernel build
> > > finer-grained, rather than blunter-grained.  Don't be afraid to add new
> > > header files if that is one way of doing this!
> > 
> > Hmm, good point. But there's also:
> > 
> > +#ifdef CONFIG_CGROUPS
> > +       struct rw_semaphore threadgroup_fork_lock;
> > +#endif
> > 
> > in the signal_struct, also in sched.h, which needs to be there. Or I
> > could change it to a struct pointer with a forward incomplete
> > declaration above, and kmalloc/kfree it? I don't like adding more
> > alloc/free calls but don't know if it's more or less important than
> > header granularity.
> 
> What about adding a new header file which includes rwsem.h and sched.h
> and then defines the new interfaces?

Er, I mean the definition of signal_struct needs rwsem.h as well, not
just the threadgroup_fork_* functions. (And I suspect moving
signal_struct somewhere else would give bigger problems...)
