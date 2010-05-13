Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab0EMUtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:49:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36168 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab0EMUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UM59AKkLcbp56PBPo3bFViKVdWx1glVu1hWYwJ1HD2GB1g5r7udYp6kjqlK87hGqBp
         eW4RgW+g4ZmtYPdq4Q+zmH7RDaOTrGK9RlsU54M+33ZgLJs+etn1lg9wL8e3RhxRZ5KC
         8IoK9cdgBA/C7riB8OB90N1DwBSiZnkW8GZMQ=
Date: Thu, 13 May 2010 22:48:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100513204855.GD5377@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com> <20100513190325.GB5377@nowhere> <20100513194605.GG2879@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513194605.GG2879@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:46:05PM -0700, Paul E. McKenney wrote:
> On Thu, May 13, 2010 at 09:03:28PM +0200, Frederic Weisbecker wrote:
> > On Thu, May 13, 2010 at 11:25:56AM -0700, Paul E. McKenney wrote:
> > > This commit guesses at the perf_cpu_context locking design and deploys
> > > an rcu_dereference_check() accordingly.  The design appears to require
> > > that a given CPU be accessing its own per_cpu_context or that it be
> > > traversing under RCU protection.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > >  perf_event.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > > index a4fa381..002791c 100644
> > > --- a/kernel/perf_event.c
> > > +++ b/kernel/perf_event.c
> > > @@ -4074,7 +4074,9 @@ find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
> > >  
> > >  	hash = swevent_hash(type, event_id);
> > >  
> > > -	hlist = rcu_dereference(ctx->swevent_hlist);
> > > +	hlist = rcu_dereference_check(ctx->swevent_hlist,
> > > +				      rcu_read_lock_held() ||
> > > +				      ctx == &__get_cpu_var(perf_cpu_context));
> > >  	if (!hlist)
> > >  		return NULL;
> > >  
> > 
> > 
> > Hmm, that's not exactly that. It will always be the ctx of this cpu
> > but not always under rcu read lock. I mean touching the current cpu
> > ctx is not inherently safe.
> > 
> > In fact we have two paths:
> > 
> > perf_swevent_enable() gets the hlist and if it is called it means
> > that this hlist is not supposed to be NULL. If it is, it's a bug.
> > 
> > If we have created a software event, the hlist has been allocated
> > and perf_swevent_enable() is called later to activate this event.
> > May be I shouldn't use rcu_dereference() here but a simple dereference.
> > And the hlist can't be freed under us at this time so we don't need
> > rcu_read_lock().
> > 
> > OTOH, do_perf_sw_event() can be called anytime so it need this
> > rcu_read_lock().
> > 
> > 
> > On the perf_swevent_enable() path, what prevents the hlist to be
> > freed under us is the ctx->lock. Because we won't ever remove
> > an event from its context list outside this lock, and we might only
> > release the hlist after a software event gets removed from its
> > context list.
> > 
> > So either we do this:
> > 
> > hlist = rcu_dereference_check(ctx->swevent_hlist,
> >                               rcu_read_lock_held() ||
> >                               raw_spin_lock_is_held(&ctx->lock));
> 
> Something very similar to the above was in fact my first guess, but as
> Ingo can attest, this results in build errors.  The problem is that
> perf_cpu_context does not have a ->lock field.  Hmmm...  But it does
> contain a struct perf_event_context (ctx) and a pointer to another
> (task_ctx).  So, would one of the following work?
> 
> list = rcu_dereference_check(ctx->swevent_hlist,
> 			     rcu_read_lock_held() ||
> 			     lockdep_is_held(&ctx->ctx.lock));
> 
> list = rcu_dereference_check(ctx->swevent_hlist,
> 			     rcu_read_lock_held() ||
> 			     lockdep_is_held(&ctx->task_ctx->lock));
> 
> If the latter, can ->task_ctx ever be NULL, and if so, what should
> I do then?
> 
> > or:
> > 
> > 
> > hlist = ctx->swevent_hlist;
> 
> This will be flagged as an error by Arnd's sparse-based checking.  :-(
> 
> 							Thanx, Paul


Paul, does that look good to you?
I've only compile tested. But if it's fine for you, I'll test
it for real and provide you a sane patch.

This version won't use more parameters than necessary in the
off case.


diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..d765e48 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4066,19 +4066,36 @@ static inline u64 swevent_hash(u64 type, u32 event_id)
 	return hash_64(val, SWEVENT_HLIST_BITS);
 }
 
-static struct hlist_head *
-find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+static inline struct hlist_head *
+__find_swevent_head(struct swevent_hlist *hlist, u64 type, u32 event_id)
 {
 	u64 hash;
-	struct swevent_hlist *hlist;
 
 	hash = swevent_hash(type, event_id);
 
+	return &hlist->heads[hash];
+}
+
+static inline struct hlist_head *
+find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+{
+	struct swevent_hlist *hlist;
+
 	hlist = rcu_dereference(ctx->swevent_hlist);
-	if (!hlist)
-		return NULL;
 
-	return &hlist->heads[hash];
+	return __find_swevent_head(hlist, type, event_id);
+}
+
+static inline struct hlist_head *
+find_swevent_head(struct perf_cpu_context *ctx, u64 type,
+		  u32 event_id, struct perf_event *event)
+{
+	struct swevent_hlist *hlist;
+
+	hlist = rcu_dereference_check(ctx->swevent_hlist,
+				      lockdep_is_held(&event->ctx->lock));
+
+	return __find_swevent_head(hlist, type, event_id);
 }
 
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
@@ -4095,7 +4112,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 
 	rcu_read_lock();
 
-	head = find_swevent_head(cpuctx, type, event_id);
+	head = find_swevent_head_rcu(cpuctx, type, event_id);
 
 	if (!head)
 		goto end;
@@ -4178,7 +4195,8 @@ static int perf_swevent_enable(struct perf_event *event)
 		perf_swevent_set_period(event);
 	}
 
-	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
+	head = find_swevent_head(cpuctx, event->attr.type,
+				 event->attr.config, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 


