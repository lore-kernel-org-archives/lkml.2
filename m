Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0CZXdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:33:02 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36909 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0CZXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FcZSEEcUw7p4r6x/QFb3qa9ARYiRfrSeWnEpXF2Oh/vgYZ//gqQ9KllJfZU1Iub8CT
         9h9YYEsJ+x8x9gl1DVnn/zyU4zXsM6DVAh58BUyk/JdKvioHNrT0knpNjhYNwU17TKVv
         UflXhGTK0eaauUshXLslA1fTpBwQvj1jL2MkA=
Date: Sat, 27 Mar 2010 00:33:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, paulus@samba.org, tglx@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] Separate lock events with types
Message-ID: <20100326233259.GI7166@nowhere>
References: <20100129221252.GA5052@nowhere> <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 06:02:46PM +0900, Hitoshi Mitake wrote:
> Sorry for my long silence...
> 
> Thanks for Frederic's great work like trace_lock_class_init(),
> overhead of perf lock was reduced a lot.
> But still there is overhead which cannot be disregarded.
> 
> So I'd like to suggest that separating lock trace events into each types of lock.
> e.g.
> 	trace_lock_acquire() -> spin_trace_lock_acquire(), rwlock_trace_lock_acquire()
> I think that mutex and spinlock are completely different things.
> And as I describe below, filtering at recording phase can reduce overhead of tracing.
> 
> CAUTION:
> This patch is the proof of concept. The way this patch employes
> is different from one I described above. This patch adds if statement
> before trace_lock_*(). Implementation of separating events per types will be
> a big one, so this is an only trial edition for performance improvements.


Instead of having one different event for each type of locks,
I would rather suggest to add a "lock type" field in the (future)
lock_init_class class. This requires we implement event injection
properly before.

So if we store the lock type in the lockdep_map, we can just dump
the type on lock class initialization:

- on register_lock_class
- on event injection to catchup with lock that have already registered

That's what does my tree perf/inject (minus the lock type), but this
all require a redesign, in both ftrace and perf sides.

Thanks.

