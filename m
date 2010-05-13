Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0EMU0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:26:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43416 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0EMU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ooiPuvLFr/JbxnofqvoE96A9Cud9JoTqaluhXjT0zdE/T6OdElNPfMkkQXQmhSPS4n
         S/y5Mms8Tx75DHInwLL2cXugp1sX2CFoa1EiCy56DTgUv8wpl2qrRG6DwHkmvtNnmGio
         343imV7ZnzWdkSV9tofZFHMwQBc3bsBSJKv5g=
Date: Thu, 13 May 2010 22:26:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100513202604.GC5377@nowhere>
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



Ah right. Oh, and it depends where the current event to be enabled
come from: a task context or a cpu context, it can be one of these
two locks. The following check wouldn't be 100 % reliable:

	lockdep_is_held(&ctx->ctx.lock) || lockdep_is_held(&ctx->task_ctx->lock))

because it has a small hole: the cpu context lock can be validated while
the current event needs the task one, or opposite. But at least it narrows
down.

Yet we could get the event in the perf_swevent_enable() and do:

	event && lockdep_is_held(event->ctx->lock)

(do_perf_sw_event() can pass NULL as the event, because it doesn't have
any yet).

That has a drawback though: find_swevent_head() would require one more
parameter, for something used in a fastpath.

That's sad but the only solution I can find.

