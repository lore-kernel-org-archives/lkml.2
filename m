Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1IBMga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1IBMg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:36:29 -0400
Date: Fri, 2 Sep 2011 14:32:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: more safe tasklist locking in
	cgroup_attach_proc
Message-ID: <20110902123251.GA26764@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu> <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown> <20110728062616.GC15204@unix33.andrew.cmu.edu> <20110728171345.67d3797d@notabene.brown> <20110729142842.GA8462@unix33.andrew.cmu.edu> <20110815184957.GA16588@redhat.com> <20110901214643.GD10401@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901214643.GD10401@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Ben Blum wrote:
>
> On Mon, Aug 15, 2011 at 08:49:57PM +0200, Oleg Nesterov wrote:
> >
> > But can't we avoid the global list? thread_group_leader() or not, we do
> > not really care. We only need to ensure we can safely find all threads.
> >
> > How about the patch below?
>
> I was content with the tasklist_lock because cgroup_attach_proc is
> already a pretty heavyweight operation, and probably pretty rare that a
> user would want to do multiple of them at once quickly.

Perhaps. But this is the global lock, no matter what. Why do you prefer
to take it instead of per-process ->siglock?

> I asked Andrew
> to take the simple tasklist_lock patch just now, since it does fix the
> bug at least.

I disagree.

> Anyway, looking at this, hmm. I am not sure if this protects adequately?
> In de_thread, the sighand lock is held only around the first half
> (around zap_other_threads),

We only need this lock to find all threads,

> and not around the following section where
> leadership is transferred (esp. around the list_replace calls).
> tasklist_lock is held here, though, so it seems like the right lock to
> hold.

This doesn't matter at all, I think. The code under while_each_thread()
doesn't need the stable ->group_leader, and it can be changed right after
you drop tasklist. list_replace() calls do not play with ->thread_group
list.

How can tasklist make any difference?

> > With or without this/your patch this leader can die right after we
> > drop the lock. ss->can_attach(leader) and ss->attach(leader) look
> > suspicious. If a sub-thread execs, this task_struct has nothing to
> > do with the threadgroup.
>
> hmm. I thought I had this case covered, but it's been so long since I
> actually wrote the code that if I did I can't remember how.

This all doesn't look right... Hopefully addressed by Tejun patches.

Oleg.

