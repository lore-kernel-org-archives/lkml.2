Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2AEPat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:30:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2AEPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:30:48 -0500
Date: Thu, 5 Jan 2012 10:30:42 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gleb@redhat.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: close race in jump_label_inc() vs.
 jump_label_dec()
Message-ID: <20120105153041.GA10850@redhat.com>
References: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
 <1325774396.12696.49.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325774396.12696.49.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 09:39:56AM -0500, Steven Rostedt wrote:
> On Wed, 2012-01-04 at 10:32 -0500, Jason Baron wrote:
> > The previous fix to ensure that jump_label_inc() does not return until the jump
> > is completely patched, opened up a race in the inc/dec path. The scenario is:
> 
> You forgot something:
> 
> 
> > 
> > key->enabled = 0;
> > 
> > 	CPU 0					CPU 1
> >         ----- 					-----
> 
>   jump_label_lock();
> 
> > 
> > jump_label_inc():			jump_label_dec():
> > 
> > 1) if (atomic_read(&key->enabled) == 0)
> > 	jump_label_update(key, JUMP_LABEL_ENABLE);
> > 
> > 					 2) if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
> > 					 	return;
> > 
> > 3) atomic_inc(&key->enabled);
> 
>   jump_label_unlock();
> 
> 
> 
> > 
> > So now, key->enabled = 0, but the jump has been enabled, which is an invalid
> > state.
> 
> How does key->enabled end up == 0?
> 
> As Gleb said, it's a higher level bug if we do a jump_label_dec() when
> key->enabled already is zero.
> 

I was worried about exactly that case. Part of my thinking is based on
'static_branch_def_true()' that I am looking to introduce, see:
https://lkml.org/lkml/2011/12/21/359. In that case, key->enabled starts
at 1, and we need to do a jump_label_dec(key), in order to make the
branch false and change the branch from its initial state. So, if we don't allow
negative 'enabled' values, the api doesn't feel symmetrical.

That said, until we have a use-case that would excercise this race,
I'm ok with having it be a higher level bug as Gleb pointed out. So how about a
WARN() for this case. I'll send as a separate patch, if people are ok
with it.

Thanks,

-Jason

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -75,8 +75,11 @@ void jump_label_inc(struct jump_label_key *key)
 static void __jump_label_dec(struct jump_label_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
-	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
+	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
+		WARN(atomic_read(&key->enabled) < 0,
+		     "jump label: negative count!\n");
 		return;
+	}
 
 	if (rate_limit) {
 		atomic_inc(&key->enabled);




> Thus, in this scenario, we enter jump_label_inc() with key->enabled=1,
> and 1) will not be true. When we hit 2), it will have to grab the
> jump_label_mutex, which will be held, thus it will block until CPU 0 is
> finished, in which case, key->enabled=1 and the
> atomic_dec_and_mutex_lock() will fail and return.
> 
> The end result is key->enabled=1 and we have jump labels enabled.
> 
> What's the invalid state?
> 
> -- Steve
> 
> 
