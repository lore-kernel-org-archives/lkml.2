Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2LQQEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2LQQEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:04:12 -0500
Date: Mon, 17 Dec 2012 17:04:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121217160408.GA20166@redhat.com>
References: <20121217123428.GA1957@redhat.com> <20121217150559.GD25322@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217150559.GD25322@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Neil Horman wrote:
>
> On Mon, Dec 17, 2012 at 01:34:28PM +0100, Oleg Nesterov wrote:
> > @@ -455,6 +468,14 @@ static int umh_pipe_setup(struct subproc
> >  	/* and disallow core files too */
> >  	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
> >
> > +
> > +	if (cp->switch_ns) {
> > +		get_fs_root(cp->cprocess->fs, &root);
> > +		set_fs_root(current->fs, &root);
> > +		switch_task_namespaces(current, cp->cprocess->nsproxy);
> >
> > How? You can't simply change ->nsproxy this way.
> >
> Why not?  This is exactly how fork, exit, and setns use this call.

No. exit() does switch_task_namespaces(NULL), this is different.
fork() doesn't do this, and unshare/setns carefully creates the new ns.

> > If nothing else this breaks sys_getpid(), no?
> >
> hmm, I think you're inferring here that there is a chance that a pid allocated
> in the init namespace might conflict with another process who holds the same pid
> in another namespace?

No, I meant that sys_getpid() should always return 0 after this
switch_task_namespaces() if the coredumping task is not from the root
namespace.

> Is there a way to switch all namespaces, except for the pid
> namespace?

Which exactly namespaces you want to change?

To be honest, I do not understand this patch at all. It seems that
you need to do something like sys_setns(). But if we do this, then
why we can't make core_pattern per-namespace?

Anyway, please ask Pavel and Eric, they should know better ;)

> > And a lot more problems, afaics. For example, this thread can continue
> > to run after, say, this cprocess->nsproxy->pid_ns was already destroyed.
> > zap_pid_ns_processes() obviously won't see this thread.
> >
> Hmm, I don't think so.  The crashing process won't exit until the pipe reader is
> done, so the reference on the namespace should never decrement to zero.
>
> Actually I take that back.  switch_task_namespaces doesn't add a ref count to
> the name space being switched to.  So if the pipe reader doesn't exit
> immediately after closing the pipe, it may live on after the namespace is
> destroyed.

Yes,

> It would seem a get_nsproxy call is needed here to hold an
> additional reference.  Or do you think more is necessecary?

This can only pin ->nsproxy itself, this is not enough iirc.

Note that the exiting sub-init assumes that nobody else can use
ns->proc_mnt after zap_pid_ns_processes().

Oleg.

