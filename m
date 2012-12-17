Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab2LQPG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:06:56 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2LQPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:06:54 -0500
Date: Mon, 17 Dec 2012 10:05:59 -0500
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
Message-ID: <20121217150559.GD25322@hmsreliant.think-freely.org>
References: <20121217123428.GA1957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217123428.GA1957@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:34:28PM +0100, Oleg Nesterov wrote:
> @@ -455,6 +468,14 @@ static int umh_pipe_setup(struct subproc
>  	/* and disallow core files too */
>  	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
>  
> +
> +	if (cp->switch_ns) {
> +		get_fs_root(cp->cprocess->fs, &root);
> +		set_fs_root(current->fs, &root);
> +		switch_task_namespaces(current, cp->cprocess->nsproxy);
> 
> How? You can't simply change ->nsproxy this way.
> 
Why not?  This is exactly how fork, exit, and setns use this call.

> If nothing else this breaks sys_getpid(), no?
> 
hmm, I think you're inferring here that there is a chance that a pid allocated
in the init namespace might conflict with another process who holds the same pid
in another namespace?  Yes, hand't thought about that.  What do you propose we
do about this?  Is there a way to switch all namespaces, except for the pid
namespace?  Or do we need to modify the kthread and umh apis to allow for
namespace inheritance through the fork call?

> And a lot more problems, afaics. For example, this thread can continue
> to run after, say, this cprocess->nsproxy->pid_ns was already destroyed.
> zap_pid_ns_processes() obviously won't see this thread.
> 
Hmm, I don't think so.  The crashing process won't exit until the pipe reader is
done, so the reference on the namespace should never decrement to zero.

Actually I take that back.  switch_task_namespaces doesn't add a ref count to
the name space being switched to.  So if the pipe reader doesn't exit
immediately after closing the pipe, it may live on after the namespace is
destroyed.  It would seem a get_nsproxy call is needed here to hold an
additional reference.  Or do you think more is necessecary?

> Even ->nsproxy itself can go away. Just suppose that the coredumping
> task is the only process in this namespace (sub-init).
> 
Again, that shouldn't be a problem, should it?  As that process won't exit until
the pipe reader is done, save the condition above.

Neil

