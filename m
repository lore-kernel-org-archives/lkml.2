Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1HOXEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:04:37 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:45288 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1HOXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:04:36 -0400
Date: Mon, 15 Aug 2011 19:04:15 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ben Blum <bblum@andrew.cmu.edu>,
        NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: more safe tasklist locking in
 cgroup_attach_proc
Message-ID: <20110815230415.GA6867@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20110815225003.GB29942@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815225003.GB29942@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:50:06AM +0200, Frederic Weisbecker wrote:
> On Mon, Aug 15, 2011 at 08:49:57PM +0200, Oleg Nesterov wrote:
> > On 07/29, Ben Blum wrote:
> > >
> > > According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
> > > not sufficient to guarantee the tasklist is stable w.r.t. de_thread and
> > > exit. Taking tasklist_lock for reading, instead of rcu_read_lock,
> > > ensures proper exclusion.
> > 
> > Yes.
> > 
> > So far I still think we should fix while_each_thread() so that it works
> > under rcu_read_lock() "as exepected", I'll try to think more.
> > 
> > But whatever we do with while_each_thread(), this can't help
> > cgroup_attach_proc(), it needs the locking.
> > 
> > > -	rcu_read_lock();
> > > +	read_lock(&tasklist_lock);
> > >  	if (!thread_group_leader(leader)) {
> > 
> > Agreed, this should work.
> > 
> > But can't we avoid the global list? thread_group_leader() or not, we do
> > not really care. We only need to ensure we can safely find all threads.
> > 
> > How about the patch below?
> > 
> > 
> > With or without this/your patch this leader can die right after we
> > drop the lock. ss->can_attach(leader) and ss->attach(leader) look
> > suspicious. If a sub-thread execs, this task_struct has nothing to
> > do with the threadgroup.
> > 
> > 
> > 
> > Also. This is off-topic, but... Why cgroup_attach_proc() and
> > cgroup_attach_task() do ->attach_task() + cgroup_task_migrate()
> > in the different order? cgroup_attach_proc() looks wrong even
> > if currently doesn't matter.
> 
> Right. As we concluded in our off-list discussion, if there
> is no strong reason for that, I'm going to fix that in my task
> counter patchset because there it really matters. If we can't
> migrate the thread because it has already exited, we really
> don't want to call ->attach_task() but rather cancel_attach_task().
> 
> Thanks.
> 

Yes. Um, this must have been a mistake on my part. The lines of code
should be the other way around. It should be done in a separate bugfix
patch, though, so it goes through faster...

-- Ben
