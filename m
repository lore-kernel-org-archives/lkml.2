Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0HaH1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:27:55 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50251 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0HaH1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:27:54 -0400
Date: Tue, 31 Aug 2010 16:25:42 +0900
From: Minoru Usui <usui@mxm.nes.nec.co.jp>
To: Mike Galbraith <efault@gmx.de>
Cc: johunt@akamai.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 cgroup regression
Message-Id: <20100831162542.98269492.usui@mxm.nes.nec.co.jp>
In-Reply-To: <1282715761.20033.23.camel@marge.simson.net>
References: <4C74274D.9060300@akamai.com>
	<1282715761.20033.23.camel@marge.simson.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

On Wed, 25 Aug 2010 07:56:01 +0200
Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2010-08-24 at 13:10 -0700, Josh Hunt wrote:
> > This commit makes the ltp cpuctl latency test #2 hang indefinitely:
> > 
> > commit b5d9d734a53e0204aab0089079cbde2a1285a38f
> > Author: Mike Galbraith <efault@gmx.de>
> > Date:   Tue Sep 8 11:12:28 2009 +0200
> > 
> >     sched: Ensure that a child can't gain time over it's parent after fork()
> 
> Ouch.  Yeah, that commit is buggy, and never got fixed up in stable.
> Reverting it will restore a slightly less buggy, but not very good
> situation.  Getting the fork problems all fixed up took a while.
> (quick fix vs revert didn't help your testcase)

I'm interested in this problem, because I hit the same problem in RHEL6 beta2.
(It based on 2.6.32)

Are you writing a patch to solving this problem?
If you are doing, I can test it in RHEL6 beta2 (or latest).

Appendix.
I could reproduce this problem without ltp. See below.(case 1)
But if cpus are not completely busy, it couldn't occure.(case 2)

[case1]
  1) Run busy loop process (number of cpu) in same cpu cgroup.

  2) attach process to 1)'s cpu cgroup
       -> attach process unfinished

  Ex)
     # mkdir /cgroup/cpu/test/tasks 
     # echo $$ > /cgroup/cpu/test/tasks 
     # ./loop 8 &
     [1] 27202
 
     # mpstat -P ALL 1
     Linux 2.6.32-37.el6.x86_64 (StingerG.localdomain)       08/31/2010      _x86_64_        (8 CPU)
 
     03:08:45 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
     03:08:46 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    0  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    1  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    2  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    3  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    4  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    5  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    6  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:08:46 PM    7  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00

     # echo $$ > /cgroup/cpu/tasks
     # time echo $$ > /cgroup/cpu/test/tasks   <- unfinish this operation

[case2]
     # echo $$ > /cgroup/cpu/test/tasks 
     # ./loop 7 &
     [1] 27259
 
     # mpstat -P ALL 1
     Linux 2.6.32-37.el6.x86_64 (StingerG.localdomain)       08/31/2010      _x86_64_        (8 CPU)
 
     03:12:00 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
     03:12:01 PM  all   83.42    0.00    0.00    0.12    0.00    0.00    0.00    0.00   16.46
     03:12:01 PM    0   72.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   28.00
     03:12:01 PM    1   60.75    0.00    0.00    0.00    0.00    0.00    0.00    0.00   39.25
     03:12:01 PM    2   98.99    0.00    0.00    1.01    0.00    0.00    0.00    0.00    0.00
     03:12:01 PM    3  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:12:01 PM    4   67.29    0.00    0.00    0.00    0.00    0.00    0.00    0.00   32.71
     03:12:01 PM    5   72.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   28.00
     03:12:01 PM    6  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
     03:12:01 PM    7  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
 
     # echo $$ > /cgroup/cpu/tasks 
     # time echo $$ > /cgroup/cpu/test/tasks 
 
     real    0m0.006s
     user    0m0.000s
     sys     0m0.000s 

> > When I revert this commit the test progresses as it did in 2.6.31. I
> > have seen this issue on 2.6.32 and 2.6.32.19. The hang goes away in
> > 2.6.33 starting with this commit:
> > 
> > commit 88ec22d3edb72b261f8628226cd543589a6d5e1b
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Wed Dec 16 18:04:41 2009 +0100
> > 
> >     sched: Remove the cfs_rq dependency from set_task_cpu()
> 
> Excellent timing you have.  I have a tree of backports, but I wasn't
> counting this commit as a must have, merely highly desirable.  This
> testcase showed that it's a needed fix.
>   
> > Even though this appears to be resolved in 2.6.33, I am reporting it
> > because 2.6.32 is the "long-term stable release".
> 
> Yeah, there are a _lot_ of fixes that should wander back to 32-stable.
>
> > My test system is a single socket dual core amd -
> > model name	: Dual Core AMD Opteron(tm) Processor 180
> > with 4GB of RAM.
> > Kernel config file attached.
> > 
> > The issue is easily reproducible for me by downloading and building ltp,
> > then running
> > testcases/kernel/controllers/cpuctl/run_cpuctl_latency_test.sh 2
> > 
> > Please let me know if you need any other information to help reproduce
> > this issue.
> 
> No, the testcase works well.  Thanks.
> 
> 	-Mike
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Minoru Usui <usui@mxm.nes.nec.co.jp>
