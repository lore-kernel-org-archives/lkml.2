Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab1KVVVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:21:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1KVVVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:21:51 -0500
Date: Tue, 22 Nov 2011 22:16:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111122211645.GA21608@redhat.com>
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com> <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121225019.GQ25776@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21, Tejun Heo wrote:
>
> > +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> > +		     void __user *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	struct ctl_table tmp = *table;
> > +	tmp.data = &current->nsproxy->pid_ns->last_pid;
> > +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
> > +}
>
> Probably better to call set_last_pid() on write path instead?

I am not sure... set_last_pid() is "special", it tries to avoid the
races with itself to prevent the pid-reuse. It doesn't hurt, but
perhaps

	set_last_pid(pid_ns, pid_ns->last_pid, new_pid);

looks a bit confusing.

Hmm. On the second thought, perhaps this makes sense anyway. Just
to keep the "only set_last_pid() can change ->last_pid" property.

But this is almost cosmetic.

> > Well, after a bit more thinking I found one more pros for this
> > sysctl - when restoring a container we'll have the possibility to
> > set the last_pid to what we want to prevent the pids reuse after the
> > restore.
>
> Hmmm... I personally like this one better.  Restoring multilevel pid
> would be more tedious but should still be possible and I really like
> that it's staying out of clone path and all modifications are to ns
> and pid code.  Oleg, what do you think?

Obviously, I'd prefer this one too ;)

But. Personally I do not like the fact that only init can open this
file for writing... (I guess Pavel already hates me ;)

If we add this sysctl, then I think there should be some way to use
outside of "checkpoint-restore" world. For example, see the comment
from Pedro. This use-case looks unexpected (to me), but reasonable.
Or. Say, set_last_pid can be useful to test the pid-reuse races.

In any case. To me, it is not really good to have /proc/*/set_last_pid
without the ability to use it somehow on the running system.

Oleg.

