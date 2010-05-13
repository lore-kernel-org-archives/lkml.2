Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0EMTDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:03:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56860 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab0EMTDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IwX/W0T7SN0oLPN0/q/VOn5oYQTAeXIwsaMHKiuqIDJ3KvGMk0cf4M0LtEcLUiTdQh
         Op4glLla9RzKmJfr48BLTZ/1bNRQqtV7OwfqnrAwaaW7aBke0uIlhpSvePApea3wNFR0
         qVM9ZmpONFM9w7L5xyusRK5xEzPjPLORcPoEs=
Date: Thu, 13 May 2010 21:03:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100513190325.GB5377@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513182556.GA14326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:25:56AM -0700, Paul E. McKenney wrote:
> This commit guesses at the perf_cpu_context locking design and deploys
> an rcu_dereference_check() accordingly.  The design appears to require
> that a given CPU be accessing its own per_cpu_context or that it be
> traversing under RCU protection.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> 
>  perf_event.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a4fa381..002791c 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4074,7 +4074,9 @@ find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
>  
>  	hash = swevent_hash(type, event_id);
>  
> -	hlist = rcu_dereference(ctx->swevent_hlist);
> +	hlist = rcu_dereference_check(ctx->swevent_hlist,
> +				      rcu_read_lock_held() ||
> +				      ctx == &__get_cpu_var(perf_cpu_context));
>  	if (!hlist)
>  		return NULL;
>  


Hmm, that's not exactly that. It will always be the ctx of this cpu
but not always under rcu read lock. I mean touching the current cpu
ctx is not inherently safe.

In fact we have two paths:

perf_swevent_enable() gets the hlist and if it is called it means
that this hlist is not supposed to be NULL. If it is, it's a bug.

If we have created a software event, the hlist has been allocated
and perf_swevent_enable() is called later to activate this event.
May be I shouldn't use rcu_dereference() here but a simple dereference.
And the hlist can't be freed under us at this time so we don't need
rcu_read_lock().

OTOH, do_perf_sw_event() can be called anytime so it need this
rcu_read_lock().


On the perf_swevent_enable() path, what prevents the hlist to be
freed under us is the ctx->lock. Because we won't ever remove
an event from its context list outside this lock, and we might only
release the hlist after a software event gets removed from its
context list.

So either we do this:

hlist = rcu_dereference_check(ctx->swevent_hlist,
                              rcu_read_lock_held() ||
                              raw_spin_lock_is_held(&ctx->lock));

or:


hlist = ctx->swevent_hlist;

