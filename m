Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1KBPVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:21:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab1KBPVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:21:43 -0400
Date: Wed, 2 Nov 2011 17:21:23 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu
Subject: Re: [PATCH] jump_label_inc may return before the code is patched
Message-ID: <20111102152123.GF14726@redhat.com>
References: <20111018175551.GH17571@redhat.com>
 <1318971986.3712.18.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318971986.3712.18.camel@frodo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 05:06:25PM -0400, Steven Rostedt wrote:
> On Tue, 2011-10-18 at 19:55 +0200, Gleb Natapov wrote:
> > If cpu A calls jump_label_inc() just after atomic_add_return() is
> > called by cpu B, atomic_inc_not_zero() will return value greater then
> > zero and jump_label_inc() will return to a caller before jump_label_update()
> > finishes its job on cpu B.
> 
> OK, I see what you are saying. There's a race here that jump_label_inc
> may return before jump labels are actually activated. I have no issue
> with this change. This guarantees that jump labels will be active on
> return of jump_label_inc().
> 
> I'm assuming that jump_label_update() does memory barries, as it does
> modify code, and would be itself a synchronization point.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
So through what tree this should go to Linus' git?

> -- Steve
> 
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index a8ce450..e6f1f24 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
> >  		return;
> >  
> >  	jump_label_lock();
> > -	if (atomic_add_return(1, &key->enabled) == 1)
> > +	if (atomic_read(&key->enabled) == 0)
> >  		jump_label_update(key, JUMP_LABEL_ENABLE);
> > +	atomic_inc(&key->enabled);
> >  	jump_label_unlock();
> >  }
> >  
> > --
> > 			Gleb.
> 

--
			Gleb.
