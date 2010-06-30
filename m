Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0F3DvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 23:51:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37833 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab0F3DvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 23:51:12 -0400
Date: Tue, 29 Jun 2010 20:51:09 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630035109.GK4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
 <20100630004027.GG4837@outflux.net>
 <201006300109.o5U19s1N043912@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006300109.o5U19s1N043912@www262.sakura.ne.jp>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

On Wed, Jun 30, 2010 at 10:09:54AM +0900, Tetsuo Handa wrote:
> Kees Cook wrote:
> > +static spinlock_t ptracer_relations_lock;
> static DEFINE_SPINLOCK(ptracer_relations_lock);

Ah, very cool, I missed that while reading through spinlock code. :)

> > +	relation = kzalloc(sizeof(*relation), GFP_KERNEL);
> You can use kmalloc() since all fields are initialized within this function.

I wasn't sure if list_add needed a zeroed ->node, so I opted for safety
here.  Is list_add safe to use on an uninitialized ->node?  (Looks like it
is on code review, I'll just use regular kmalloc.)

> > +static int ptracer_exception_found(struct task_struct *tracer,
> > +				   struct task_struct *tracee)
> > +{
> > +	int rc = 0;
> > +	struct ptrace_relation *relation;
> > +	struct task_struct *parent = NULL;
> > +
> > +	spin_lock(&ptracer_relations_lock);
> > +	list_for_each_entry(relation, &ptracer_relations, node)
> > +		if (relation->tracee == tracee) {
> > +			parent = relation->tracer;
> > +			break;
> > +		}
> > +	if (task_is_descendant(parent, tracer))
> > +		rc = 1;
> > +	spin_unlock(&ptracer_relations_lock);
> 
> Can't we release ptracer_relations_lock before calling
> task_is_descendant() since task_is_descendant() won't
> access "struct ptrace_relation" on ptracer_relations list.

This is where it gets a little funny.  I need to keep that lock so that
task_is_descendant isn't racing yama_task_free.  I don't want to be in
the position where I've left the lock only to have another CPU free the
task_struct that was just located, so I have to keep the lock until I've
finished using "parent".  (And I can't take the task with get_task since
it's already too late, and if I take it during _add, the task will never
be freed.)

> > @@ -32,27 +204,20 @@ static int yama_ptrace_access_check(struct task_struct *child,
> >  {
> >  	int rc;
> >  
> > +	/* If standard caps disallows it, so does Yama.  We should
> > +	 * should only tighten restrictions further.
> s/should should/should/

Agh, thanks.

-Kees

-- 
Kees Cook
Ubuntu Security Team
