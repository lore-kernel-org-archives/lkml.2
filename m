Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1JTVbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:31:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1JTVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:31:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=yCkqwRA6uWncveKG9ZfwbaAtUfaA2craEHse+n4cvt40O/4Qw8XN2NDvq+Iu1uodG
	Aj6yLSZyCdFlXH5RdF8ig==
Date: Thu, 20 Oct 2011 14:31:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
In-Reply-To: <20111020212353.GZ25124@google.com>
Message-ID: <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
References: <20111015201239.GA3475@swordfish> <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com> <20111015222324.GA16432@liondog.tnic> <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com> <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com> <20111020190701.GB3586@swordfish.minsk.epam.com> <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com> <20111020212353.GZ25124@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Tejun Heo wrote:

> > Tejun, would you like to revert f59de8992aa6 ("lockdep: Clear whole 
> > lockdep_map on initialization") since it fixes this lockdep warning?
> 
> Hmmm... the issue was that kmemcheck noticed that memory regions in
> lockdep_map are accessed before being set to any value.  I'm feeling
> dim as usual and don't understand what's going on here.  The function
> looks like the following.
> 
> 
>  void lockdep_init_map(struct lockdep_map *lock, const char *name,
> 		       struct lock_class_key *key, int subclass)
>  {
> 	 memset(lock, 0, sizeof(*lock));
> 
>  #ifdef CONFIG_LOCK_STAT
> 	 lock->cpu = raw_smp_processor_id();
>  #endif
> 	 if (DEBUG_LOCKS_WARN_ON(!name)) {
> 		 lock->name = "NULL";
> 		 return;
> 	 }
> 
> 	 lock->name = name;
> 
> 
> So, according to this thread, the problem is that the memset() clears
> lock->name field, right?

Right, and reverting f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
initialization") seems to fix the lockdep warning.

> But how can that be a problem?  lock->name
> is always set to either "NULL" or @name.  Why would clearing it before
> setting make any difference?  What am I missing?
> 

The scheduler (in sched_fair and sched_rt) calls lock_set_subclass() which 
sets the name in double_unlock_balance() to set the name but there's a 
race between when that is cleared with the memset() and setting of 
lock->name where lockdep can find them to match.
