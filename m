Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1JTVYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:24:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63515 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:23:59 -0400
Date: Thu, 20 Oct 2011 14:23:53 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111020212353.GZ25124@google.com>
References: <20111015201239.GA3475@swordfish>
 <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
 <20111015222324.GA16432@liondog.tnic>
 <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
 <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com>
 <20111020190701.GB3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 02:17:29PM -0700, David Rientjes wrote:
> On Thu, 20 Oct 2011, Sergey Senozhatsky wrote:
> 
> > > > FWIW,
> > > > 
> > > > the box has been running here with f59de8992aa6 reverted for a couple of
> > > > days now and no sign of the warning. I'll keep watching it but it looks
> > > > ok so far, so David, you could've nailed it.
> > > > 
> > > 
> > > Hello,
> > > Well, the same with me. My laptop has been running with reverted f59de8992aa6 without any
> > > problems so far. Yet, I'm not sure I understand how memset() and loop could
> > > produce different results.
> > > 
> > 
> > Oh, well, nevermind I think I get it. 
> > 
> > Reverting opens https://bugzilla.kernel.org/show_bug.cgi?id=35532 again.  
> > 
> 
> I don't know what that is since bugzilla.kernel.org is down :)  The 
> problem is that the memset(), in addition to all the other fields in 
> lockdep_map, clears the "name" field, which is what the scheduler uses 
> via lock_set_sublcass() to prevent this lockdep warning.  My initial 
> speculation seems to be confirmed since either you or Borislav have been 
> able to reproduce the warning since removing the memset().
> 
> Tejun, would you like to revert f59de8992aa6 ("lockdep: Clear whole 
> lockdep_map on initialization") since it fixes this lockdep warning?

Hmmm... the issue was that kmemcheck noticed that memory regions in
lockdep_map are accessed before being set to any value.  I'm feeling
dim as usual and don't understand what's going on here.  The function
looks like the following.


 void lockdep_init_map(struct lockdep_map *lock, const char *name,
		       struct lock_class_key *key, int subclass)
 {
	 memset(lock, 0, sizeof(*lock));

 #ifdef CONFIG_LOCK_STAT
	 lock->cpu = raw_smp_processor_id();
 #endif
	 if (DEBUG_LOCKS_WARN_ON(!name)) {
		 lock->name = "NULL";
		 return;
	 }

	 lock->name = name;


So, according to this thread, the problem is that the memset() clears
lock->name field, right?  But how can that be a problem?  lock->name
is always set to either "NULL" or @name.  Why would clearing it before
setting make any difference?  What am I missing?

Thanks.

-- 
tejun
