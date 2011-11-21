Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1KUWu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:50:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47218 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1KUWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:50:25 -0500
Date: Mon, 21 Nov 2011 14:50:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111121225019.GQ25776@google.com>
References: <4EC4F2FB.408@parallels.com>
 <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com>
 <20111118233055.GA29378@google.com>
 <4ECA1696.5060500@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECA1696.5060500@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

On Mon, Nov 21, 2011 at 01:15:02PM +0400, Pavel Emelyanov wrote:
> Then I introduce the kernel.ns_last_pid sysctl that is allows for MAY_OPEN | MAP_WRITE for
> the namespace's init only and allows for MAY_WRITE for anyone else. Thus, if we want to
> write to this file from non-init task it must have the respective fd inherited from the init
> on fork. It works OK for checkpoint/restore.
> 
> The patch is:
> 
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index e9c9adc..3686a07 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -15,6 +15,7 @@
>  #include <linux/acct.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
> +#include <linux/sysctl.h>
>  
>  #define BITS_PER_PAGE		(PAGE_SIZE*8)
>  
> @@ -191,9 +192,54 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	return;
>  }
>  
> +static int pid_ns_ctl_permissions(struct nsproxy *namespaces,
> +			struct ctl_table *table, int op)
> +{
> +	int mode = 0644;
> +
> +	if ((op & MAY_OPEN) &&
> +			current != namespaces->pid_ns->child_reaper)
> +		/*
> +		 * Writing to this sysctl is allowed only for init
> +		 * and to whoever it grands the open file
> +		 */
> +		mode &= ~0222;
> +
> +	return sysctl_test_perm(mode, op);
> +}
> +
> +static struct ctl_table_root pid_ns_root = {
> +	.permissions = pid_ns_ctl_permissions,
> +};

Hmmm... I hope this could be prettier.  I'm having trouble following
where the MAY_OPEN comes from.  Can you please explain?  Can't we for
now allow this for root and then later allow CAP_CHECKPOINT that
Cyrill suggested?  Or do we want to allow setting pids even w/o CR for
NS creator?

> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> +		     void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table tmp = *table;
> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
> +}

Probably better to call set_last_pid() on write path instead?

> Well, after a bit more thinking I found one more pros for this
> sysctl - when restoring a container we'll have the possibility to
> set the last_pid to what we want to prevent the pids reuse after the
> restore.

Hmmm... I personally like this one better.  Restoring multilevel pids
would be more tedious but should still be possible and I really like
that it's staying out of clone path and all modifications are to ns
and pid code.  Oleg, what do you think?

Thank you.

-- 
tejun
