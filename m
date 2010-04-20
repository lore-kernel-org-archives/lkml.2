Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0DTOdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:33:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35267 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754817Ab0DTOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:33:53 -0400
Date: Tue, 20 Apr 2010 10:33:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH] lockdep fix incorrect percpu usage
Message-ID: <20100420143350.GA14622@Krystal>
References: <20100330033425.GD7683@Krystal> <1269938876.5109.510.camel@twins> <20100330134555.GA20673@Krystal> <1269959111.5258.142.camel@laptop> <20100330150551.GA22312@Krystal> <4BB2B6C4.8090803@kernel.org> <20100419182936.GI32347@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419182936.GI32347@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:25:10 up 87 days, 17:02,  7 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Wed, Mar 31, 2010 at 11:43:16AM +0900, Tejun Heo wrote:
> > On 03/31/2010 12:05 AM, Mathieu Desnoyers wrote:
> > > I see. These patches are "on their way" to mainline, so it's better not to
> > > create conflicts. So the lockdep patch should only be applied to -stable, but
> > > separate module.c patch should apply to both -stable and mainline. Am I
> > > correct ?
> > 
> > I'll push proper fixes to mainline in a few days.  For -stable, yeah,
> > probably.
> 
> Ok, did a patch ever end up in Linus's tree for this that I can pull
> into the -stable releases?
> 
> thanks,
> 
> greg k-h

Hi Greg,

Here is the updated patch, stating which mainline commit from Tejun fixes it by
refactoring the code. I'll leave the decision to pick this targeted fix or Tejun
refactoring into -stable up to you.


lockdep fix incorrect percpu usage

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
for per cpu pointers).

git blame points to commit:

lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d

But it's really just moving the code around. But it's enough to say that the
problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.

It should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
stable branches are still maintained).

The mainline kernel as of 2.6.34-rc5 is not affected by this problem because
commit 10fad5e46f6c7bdfb01b1a012380a38e3c6ab346 fixed it by refactoring.

(tested on 2.6.33.1 x86_64)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable <stable@kernel.org>
---
 kernel/lockdep.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux.trees.git/kernel/lockdep.c
===================================================================
--- linux.trees.git.orig/kernel/lockdep.c	2010-03-19 16:18:34.000000000 -0400
+++ linux.trees.git/kernel/lockdep.c	2010-03-30 09:48:43.000000000 -0400
@@ -600,9 +600,9 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
-					+ per_cpu_offset(i);
+		start = (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
+		end   = (unsigned long) per_cpu_ptr(&__per_cpu_start
+						    + PERCPU_ENOUGH_ROOM, i);
 
 		if ((addr >= start) && (addr < end))
 			return 1;


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
