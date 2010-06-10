Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab0FJRDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:03:45 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:41559 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0FJRDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xu6ideUXR15aFPlRkhGQHxM+uL/6mBxUYPx8JMLAPWOLkMt0ZIZAJZajILOXYoGlgw
         Tf2KTX3DkSe/xXat5+RkG9dQw+gn8Ojn27LSP13ePgp1vm5BKE5Sau39Oca7pKawWs+8
         LPbpWKwYgcsHgV6HobUC9vcbXfnYmOKasnQHI=
Date: Thu, 10 Jun 2010 19:03:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] perf events finer grained context instrumentation
	/ context exclusion
Message-ID: <20100610170340.GF5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <20100610062618.GA20062@elte.hu> <20100610073140.GE12752@nowhere> <20100610101637.GA10406@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610101637.GA10406@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:16:37PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> >  Performance counter stats for './hackbench 5' (10 runs):
> > 
> >          1313640764  instructions             #      0,241 IPC     ( +-   1,393% )  (scaled from 100,05%)
> >           214737441  branches                   ( +-   0,948% )
> > 
> >          1293802776  instructions             #      0,245 IPC     ( +-   0,343% )
> >           209495435  branches                   ( +-   0,392% )
> 
> Indeed it's about 4 times less noise, not bad.
> 
> Cycles is fundamentally random.
> 
> > So yeah, the results look a bit better. Still not perfects:
> > 
> > - we are still instrumenting the tiny parts between the true interrupt
> >   and irq_enter() (same for irq_exit() and the end). Same for softirqs.
> > 
> > - random randomnesses...
> 
> Random randomness shouldnt occur for something like instructions or branches.
> 
> Could you try some 'must not be variable' workload, like:
> 
>     taskset 1 ./hackbench 1
> 
> If the workload is pinned to a single CPU then it ought to not be variable at 
> all. (modulo things like hash chain lengths and slab caching details, but 
> those should not cause 0.4% kind of noise IMO)



Good idea, with that we have at least less variations between profiles.

Now the results:

$ sudo ./perf stat -e instructions -e cycles -e branches -e branch-misses -v -r 10 taskset 1 ./hackbench 1

 Performance counter stats for 'taskset 1 ./hackbench 1' (10 runs):

          318090069  instructions             #      0,371 IPC     ( +-   2,238% )
          856426449  cycles                     ( +-   2,207% )
           51704292  branches                   ( +-   2,264% )
            2321798  branch-misses            #      4,491 %       ( +-   2,815% )

        0,541982879  seconds time elapsed   ( +-   2,185% )

$ sudo ./perf stat -e instructions:t -e cycles:t -e branches:t -e branch-misses:t -v -r 10 taskset 1 ./hackbench 1

 Performance counter stats for 'taskset 1 ./hackbench 1' (10 runs):

          305852952  instructions             #      0,371 IPC     ( +-   1,775% )
          823521707  cycles                     ( +-   1,753% )
           49712722  branches                   ( +-   1,801% )
            2210546  branch-misses            #      4,447 %       ( +-   2,219% )

        0,538258337  seconds time elapsed   ( +-   1,737% )


I did the same tests by deactivating my secondary cpu (to deactivate SMT)
but there the result were about the same between :t and non :t


> 
> Btw., we could try to record all branches of an execution (using BTS, of a 
> relatively short but static-length run), and see where the variance comes 
> from. I doubt the current BTS code is ready for that, but it would be 'the' 
> magic trace-from-hell that includes all execution of the task, recorded at the 
> hardware level.


Agreed, we could cook a nice diff graph about this.

