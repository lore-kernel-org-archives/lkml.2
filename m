Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1KVPXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:23:21 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1KVPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:23:20 -0500
Date: Tue, 22 Nov 2011 07:23:12 -0800
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
Message-ID: <20111122152312.GB322@google.com>
References: <4EC4F2FB.408@parallels.com>
 <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com>
 <20111118233055.GA29378@google.com>
 <4ECA1696.5060500@parallels.com>
 <20111121225019.GQ25776@google.com>
 <4ECB8346.8040806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB8346.8040806@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 22, 2011 at 03:11:02PM +0400, Pavel Emelyanov wrote:
> > Hmmm... I hope this could be prettier.  I'm having trouble following
> > where the MAY_OPEN comes from.  Can you please explain?
> 
> From this calltrace:
> 
>  pid_ns_ctl_permissions
>  sysctl_perm
>  proc_sys_permission
>  inode_permission
>  do_last <<<<< MAY_OPEN appears here
>  path_openat
>  do_filp_open
>  do_sys_open
>  sys_open

Thanks a lot. :)

> > Can't we for now allow this for root and then later allow CAP_CHECKPOINT 
> > that Cyrill suggested?  Or do we want to allow setting pids even w/o CR 
> > for NS creator?
> 
> I think that systemd guys can play with it. E.g. respawning daemons with predefined
> pids sounds like an interesting thing to play with.

But wouldn't CAP_CHECKPOINT be enough for systemd?

> >> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> >> +		     void __user *buffer, size_t *lenp, loff_t *ppos)
> >> +{
> >> +	struct ctl_table tmp = *table;
> >> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
> >> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
> >> +}
> > 
> > Probably better to call set_last_pid() on write path instead?
> 
> Why? The usage of this sysctl is going to be synchronized  by external locks,
> so why should we care?

I think the question should usually be the other way around.  Why
deviate when the deviation doesn't earn any tangible benefit?  If you
think setting it explicitly is justified, explain why in the comment
of the setter and places where those explicit settings are.

Thanks.

-- 
tejun
