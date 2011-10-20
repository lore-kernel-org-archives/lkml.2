Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1JTVgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:36:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35327 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1JTVgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:36:50 -0400
Date: Thu, 20 Oct 2011 14:36:44 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111020213644.GB25124@google.com>
References: <20111015201239.GA3475@swordfish>
 <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
 <20111015222324.GA16432@liondog.tnic>
 <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
 <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com>
 <20111020190701.GB3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
 <20111020212353.GZ25124@google.com>
 <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 02:31:39PM -0700, David Rientjes wrote:
> > So, according to this thread, the problem is that the memset() clears
> > lock->name field, right?
> 
> Right, and reverting f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
> initialization") seems to fix the lockdep warning.
> 
> > But how can that be a problem?  lock->name
> > is always set to either "NULL" or @name.  Why would clearing it before
> > setting make any difference?  What am I missing?
> > 
> 
> The scheduler (in sched_fair and sched_rt) calls lock_set_subclass() which 
> sets the name in double_unlock_balance() to set the name but there's a 
> race between when that is cleared with the memset() and setting of 
> lock->name where lockdep can find them to match.

Hmmm... so lock_set_subclass() is racing against lockdep_init()?  That
sounds very fishy and probably needs better fix.  Anyways, if someone
can't come up with proper solution, please feel free to revert the
commit.

Thanks.

-- 
tejun
