Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0CWNx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:53:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0CWNxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:53:54 -0400
X-Authority-Analysis: v=1.0 c=1 a=dfNPtqvK-AsA:10 a=kj9zAlcOel0A:10 a=Dl0CFYAjAAAA:8 a=5Pwo27rYcfm_W28bVK4A:9 a=4vXiPOF3qCv9ZaqaICcA:7 a=KbFpPstBzlzXWF0GtC14lxmqjfoA:4 a=CjuIK1q_8ugA:10 a=HfSKAa7qCvcA:10 a=P76tJB029keue6Pm:21 a=CzMwtLUrjNNH-hAc:21
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Tue, 23 Mar 2010 08:52:44 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux-cr: nested pid namespaces (v3)
Message-ID: <20100323135244.GA20910@hallyn.com>
References: <20100323051839.GA16123@us.ibm.com>
 <20100323071431.GC4242@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323071431.GC4242@localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Louis Rilling (Louis.Rilling@kerlabs.com):

Hi Louis, thanks again for reviewing.

> To me the real reason is to anticipate pid namespace unsharing. And this
> together with setns() will need to re-consider much of the namespace C/R
> logic imho. For instance, checkpoint could be done from a foreign task
> having entered the container, leak detection should take such foreign
> tasks into account (see example below), etc.

...

> >  
> > @@ -293,10 +295,15 @@ static int may_checkpoint_task(struct ckpt_ctx *ctx, struct task_struct *t)
> >  		_ckpt_err(ctx, -EPERM, "%(T)Nested net_ns unsupported\n");
> >  		ret = -EPERM;
> >  	}
> > -	/* no support for >1 private pidns */
> > -	if (nsproxy->pid_ns != ctx->root_nsproxy->pid_ns) {
> > -		_ckpt_err(ctx, -EPERM, "%(T)Nested pid_ns unsupported\n");
> > -		ret = -EPERM;
> > +	/* pidns must be descendent of root_nsproxy */
> > +	pidns = nsproxy->pid_ns;
> 
> In case of unshared pid namespace, task_active_pid_ns(t) should be checked
> instead of t->nsproxy->pid_ns: we can't checkpoint a foreign task.

Unsharing can only be done to a child ns, so it wouldn't be foreign.
Though of course that depends on which one ends up being the original
pid_ns (see below).

Now, regarding supporting unshared pid_ns, I think that (1) it will
be a simple matter of separately doing
	pid_pidns = checkpoint_obj(task_active_pid_ns(task));
	nsp_pidns = checkpoint_obj(task->nsproxy->pid_ns);
since we will need to record both.  In addition, (2) the most
recent emails I see on the topics are still unsure about whether
we want to have the unshared pid_ns be reflected in 
ns_of_pid(task_pid(task)) or task->nsproxy->pid_ns, so I think
we'll just have to handle them when they are implemented.

-serge
