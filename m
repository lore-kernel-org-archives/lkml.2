Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0FJHbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:31:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0FJHbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zyz+IDvg6ev1Xns5Sai9yB0jTdF2q5iEfG/eDUqmlatkeryQcXCNqETKyYAiL9iGqn
         HGtcQt35kueEm93ABjNASYkC4vsOhcRHt8WA5BVMdgASGOV0pBQYaugt7rw90rAS1fE3
         X88g7z+3aUebb6uxTwciYxZtCbkR1ol1MLsaA=
Date: Thu, 10 Jun 2010 09:31:42 +0200
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
Message-ID: <20100610073140.GE12752@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <20100610062618.GA20062@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610062618.GA20062@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 08:26:18AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Here is the new version of per context exclusion, based on hooks on 
> > irq_enter/irq_exit. I haven't observed slowdowns but I haven't actually 
> > measured the impact.
> 
> One thing that would be nice to see in this discussion is a comparison of 
> before/after perf stat --repeat runs.
> 
> Something like:
> 
>   perf stat --repeat ./hackbench 5
> 
> Done with full stat, and then also done with hardirqs/softirqs excluded. (i.e. 
> task context stats only)
> 
> I.e. does the feature really give us the expected statistical stability in 
> results? Does it really exclude hardirq/softirq workloads, etc.?
> 
> Thanks,
> 
> 	Ingo


Just got some results:

$ sudo ./perf stat -e instructions -e cycles -e branches -e branch-misses -v -r 10 ./hackbench 5

 Performance counter stats for './hackbench 5' (10 runs):

         1313640764  instructions             #      0,241 IPC     ( +-   1,393% )  (scaled from 100,05%)
         5440853130  cycles                     ( +-   0,925% )  (scaled from 100,05%)
          214737441  branches                   ( +-   0,948% )
           12332109  branch-misses            #      5,743 %       ( +-   1,239% )

        1,727051101  seconds time elapsed   ( +-   0,897% )


$ sudo ./perf stat -e instructions:t -e cycles:t -e branches:t -e branch-misses:t -v -r 10 ./hackbench 5

 Performance counter stats for './hackbench 5' (10 runs):

         1293802776  instructions             #      0,245 IPC     ( +-   0,343% )
         5280769301  cycles                     ( +-   0,471% )  (scaled from 100,02%)
          209495435  branches                   ( +-   0,392% )
           11890938  branch-misses            #      5,676 %       ( +-   0,491% )

        1,750534923  seconds time elapsed   ( +-   0,463% )


So yeah, the results look a bit better. Still not perfects:

- we are still instrumenting the tiny parts between the true interrupt
  and irq_enter() (same for irq_exit() and the end). Same for softirqs.

- random randomnesses...


Another try, this time with a kernel downloading in parallel, to generate
network interrupts:


$ sudo ./perf stat -e instructions -e cycles -e branches -e branch-misses -v -r 10 ./hackbench 5

 Performance counter stats for './hackbench 5' (10 runs):

         1324759169  instructions             #      0,244 IPC     ( +-   0,494% )  (scaled from 100,09%)
         5424824320  cycles                     ( +-   0,503% )
          214443106  branches                   ( +-   0,516% )
           12245614  branch-misses            #      5,710 %       ( +-   0,604% )

        1,723413199  seconds time elapsed   ( +-   0,483% )


$ sudo ./perf stat -e instructions:t -e cycles:t -e branches:t -e branch-misses:t -v -r 10 ./hackbench 5

 Performance counter stats for './hackbench 5' (10 runs):

         1292119132  instructions             #      0,251 IPC     ( +-   0,138% )
         5138407131  cycles                     ( +-   2,708% )
          209052068  branches                   ( +-   0,139% )
           11835090  branch-misses            #      5,661 %       ( +-   0,105% )

        1,752192124  seconds time elapsed   ( +-   0,278% )


Again, globally better, except for the cycles this time.

