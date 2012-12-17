Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2LQSkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:40:00 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40276 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2LQSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:39:59 -0500
Date: Mon, 17 Dec 2012 13:39:25 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 core_pattern-set-core-helpers-root-and-namespace-to-crashing-process .patch
 added to -mm tree
Message-ID: <20121217183925.GE25322@hmsreliant.think-freely.org>
References: <20121217123428.GA1957@redhat.com>
 <20121217150559.GD25322@hmsreliant.think-freely.org>
 <20121217160408.GA20166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217160408.GA20166@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 05:04:08PM +0100, Oleg Nesterov wrote:
> On 12/17, Neil Horman wrote:
> >
> > On Mon, Dec 17, 2012 at 01:34:28PM +0100, Oleg Nesterov wrote:
> > > @@ -455,6 +468,14 @@ static int umh_pipe_setup(struct subproc
> > >  	/* and disallow core files too */
> > >  	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
> > >
> > > +
> > > +	if (cp->switch_ns) {
> > > +		get_fs_root(cp->cprocess->fs, &root);
> > > +		set_fs_root(current->fs, &root);
> > > +		switch_task_namespaces(current, cp->cprocess->nsproxy);
> > >
> > > How? You can't simply change ->nsproxy this way.
> > >
> > Why not?  This is exactly how fork, exit, and setns use this call.
> 
> No. exit() does switch_task_namespaces(NULL), this is different.
> fork() doesn't do this, and unshare/setns carefully creates the new ns.
> 
> > > If nothing else this breaks sys_getpid(), no?
> > >
> > hmm, I think you're inferring here that there is a chance that a pid allocated
> > in the init namespace might conflict with another process who holds the same pid
> > in another namespace?
> 
> No, I meant that sys_getpid() should always return 0 after this
> switch_task_namespaces() if the coredumping task is not from the root
> namespace.
> 
> > Is there a way to switch all namespaces, except for the pid
> > namespace?
> 
> Which exactly namespaces you want to change?
> 
Ideally, I want the pipe reader process to execute in the same namespaces that
the crashing process executed in (i.e. the pipe reader should execute as though
the crashing process forked it).

> To be honest, I do not understand this patch at all. It seems that
> you need to do something like sys_setns(). But if we do this, then
> why we can't make core_pattern per-namespace?
> 
That actually would make sense, although we can't really use setns directly, as
I don't think we want to open file descriptors to do this manipulation in the
kernel.


The origional goal of this patch was to allow for the core_pattern pipe reader
to execute using the same root fs point that the crashing process did (the idea
being that, if a process crashed, the pipe reader should execute in the same
environment.  E.g. if a container was running a process that crashed, and the
pipe reader was going to save the core to /tmp, it should be in the chrooted
/tmp, not the global /tmp.  But it occured to me that switching all the
namespaces is really whats needed here.  Although after this conversation, that
seems far more difficult than I origionally thought.

Perhaps its best just to restrict this patch to adjusting the root fs location
for the chroot case.  Or would it be better to iterate over the setns-able
namespaces and migrate the pipe helper to each of them from umh_pipe_setup.

Thaoughts?
Neil


