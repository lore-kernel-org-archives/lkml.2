Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2ECRDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:03:10 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:65035 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2ECRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:03:08 -0400
Message-ID: <4FA2BA49.3070902@molgaard.org>
Date: Thu, 03 May 2012 19:03:05 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Firefox/15.0a1 SeaMonkey/2.12a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Boot failure since 3.3-rc?
References: <4F931C6D.8040407@molgaard.org>
In-Reply-To: <4F931C6D.8040407@molgaard.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incidentally, I had to swap a wifi card, and bisecting now leads to a 
different bad commit(?)

This is what it says is the culprit now (I wonder if I should bisect 
again, and attempt booting maybe 3 or 4 times each time):

f94edacf998516ac9d849f7bc6949a703977a7f3 is the first bad commit
commit f94edacf998516ac9d849f7bc6949a703977a7f3
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Feb 17 21:48:54 2012 -0800

     i387: move TS_USEDFPU flag from thread_info to task_struct

     This moves the bit that indicates whether a thread has ownership of the
     FPU from the TS_USEDFPU bit in thread_info->status to a word of its own
     (called 'has_fpu') in task_struct->thread.has_fpu.

     This fixes two independent bugs at the same time:

      - changing 'thread_info->status' from the scheduler causes nasty
        problems for the other users of that variable, since it is 
defined to
        be thread-synchronous (that's what the "TS_" part of the naming was
        supposed to indicate).

        So perfectly valid code could (and did) do

     	ti->status |= TS_RESTORE_SIGMASK;

        and the compiler was free to do that as separate load, or and store
        instructions.  Which can cause problems with preemption, since a 
task
        switch could happen in between, and change the TS_USEDFPU bit. The
        change to TS_USEDFPU would be overwritten by the final store.

        In practice, this seldom happened, though, because the 'status' 
field
        was seldom used more than once, so gcc would generally tend to
        generate code that used a read-modify-write instruction and thus
        happened to avoid this problem - RMW instructions are naturally low
        fat and preemption-safe.

      - On x86-32, the current_thread_info() pointer would, during 
interrupts
        and softirqs, point to a *copy* of the real thread_info, because
        x86-32 uses %esp to calculate the thread_info address, and thus the
        separate irq (and softirq) stacks would cause these kinds of odd
        thread_info copy aliases.

        This is normally not a problem, since interrupts aren't supposed to
        look at thread information anyway (what thread is running at
        interrupt time really isn't very well-defined), but it confused the
        heck out of irq_fpu_usable() and the code that tried to squirrel
        away the FPU state.

        (It also caused untold confusion for us poor kernel developers).

     It also turns out that using 'task_struct' is actually much more 
natural
     for most of the call sites that care about the FPU state, since they
     tend to work with the task struct for other reasons anyway (ie
     scheduling).  And the FPU data that we are going to save/restore is
     found there too.

     Thanks to Arjan Van De Ven <arjan@linux.intel.com> for pointing us to
     the %esp issue.

     Cc: Arjan van de Ven <arjan@linux.intel.com>
     Reported-and-tested-by: Raphael Prevost <raphael@buro.asia>
     Acked-and-tested-by: Suresh Siddha <suresh.b.siddha@intel.com>
     Tested-by: Peter Anvin <hpa@zytor.com>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 19548f49884c9745ecb3970321ff41b244d79b97 
ec8b1a02dd7ef354f1be4c68767e4353819dd5fa M	arch

For obvious reasons, this commit cannot be easily reverted, but help is 
much appreciated!

/sune

-- 
Unix is not an 'a-ha' experience, it is more of a 'holy-shit' experience.
- Colin McFadyen


