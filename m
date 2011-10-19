Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1JSHD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:03:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1JSHD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:03:27 -0400
Date: Wed, 19 Oct 2011 09:03:02 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] jump_label_inc may return before the code is patched
Message-ID: <20111019070302.GA6266@redhat.com>
References: <20111018175551.GH17571@redhat.com>
 <20111018205441.GC2453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018205441.GC2453@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:54:41PM -0400, Jason Baron wrote:
> On Tue, Oct 18, 2011 at 07:55:51PM +0200, Gleb Natapov wrote:
> > If cpu A calls jump_label_inc() just after atomic_add_return() is
> > called by cpu B, atomic_inc_not_zero() will return value greater then
> > zero and jump_label_inc() will return to a caller before jump_label_update()
> > finishes its job on cpu B.
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
> 
> agreed, we shouldn't return before the update happens...did this cause any
> actual problem in practice? Or just observed from code inspection?
> 
It did. I am debugging strange oopses in perf code that happen when I
create and destroy hw events on multiple cpus in parallel. At some point
I started to suspect that jump labels are not working properly and
printks confirmed that sometimes static_branch() is not taken when
->enabled is not zero. I compiled kernel without jump label support and,
as far as my testing goes, oopses disappeared. Then I found the bug by
looking at the code. Strangely enough this patch alone didn't fix oopses
yet, so some other problems are probably lurking somewhere. I am going
on vocation till next week. Will debug furtherer upon return.

> Acked-by: Jason Baron <jbaron@redhat.com>
> 
> Thanks,
> 
> -Jason

--
			Gleb.
