Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2GZOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:44:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60070 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751767Ab2GZOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:44:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/WJ9MTOkHWX6f6x21TBuM23OU0+MOBvvOgSZcrzq
	9N1lBEseaq57D9
Message-ID: <1343313869.6863.93.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Thu, 26 Jul 2012 16:44:29 +0200
In-Reply-To: <20120726130222.GB9169@beaver>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net> <20120725133637.GA9169@beaver>
	 <1343224667.5745.67.camel@marge.simpson.net> <20120726130222.GB9169@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 17:02 +0400, Alexey Vlasov wrote: 
> On Wed, Jul 25, 2012 at 03:57:47PM +0200, Mike Galbraith wrote:
> > 
> > I'd profile it with perf, and expect to find a large pile of cycles.
> 
> I did it the as following:
> # perf stat cat /proc/self/cgroup 
> 
> 4:blkio:/
> 3:devices:/
> 2:memory:/
> 1:cpuacct:/
> 
>  Performance counter stats for 'cat /proc/self/cgroup':
> 
>           0.472513 task-clock                #    0.000 CPUs utilized          
>                  1 context-switches          #    0.002 M/sec                  
>                  1 CPU-migrations            #    0.002 M/sec                  
>                169 page-faults               #    0.358 M/sec                  
>            1111521 cycles                    #    2.352 GHz                    
>             784737 stalled-cycles-frontend   #   70.60% frontend cycles idle   
>             445520 stalled-cycles-backend    #   40.08% backend  cycles idle   
>             576622 instructions              #    0.52  insns per cycle        
>                                              #    1.36  stalled cycles per insn
>             120032 branches                  #  254.029 M/sec                  
>               6577 branch-misses             #    5.48% of all branches        
> 
>        9.114631804 seconds time elapsed

Sleepy box.

> # perf report --sort comm,dso

perf report --sort symbol,dso won't toss everything in one basket.

> Kernel address maps (/proc/{kallsyms,modules}) were restricted.
> 
> Check /proc/sys/kernel/kptr_restrict before running 'perf record'.
> 
> If some relocation was applied (e.g. kexec) symbols may be misresolved.
> 
> Samples in kernel modules can't be resolved as well.
> 
> # ========
> # captured on: Thu Jul 26 16:23:06 2012
> # hostname : l24
> # os release : 3.3.3-1gb-c-s-m
> # perf version : 3.2
> # arch : x86_64
> # nrcpus online : 24
> # nrcpus avail : 24
> # cpudesc : Intel(R) Xeon(R) CPU E5645 @ 2.40GHz
> # total memory : 74181032 kB
> # cmdline : /usr/sbin/perf record cat /proc/self/cgroup
>  
> # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 1758, 1759, 1760, 1761, 1762, 1763, 1764, 1765, 1766, 1767, 1768, 1769, 1770, 1771, 1772, 1773, 1774, 1775, 1776, 1777, 1778, 1779, 1780, 1781 }
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # ========
> #
> # Events: 21  cycles
> #
> # Overhead  Command      Shared Object
> # ........  .......  .................
> #
>    100.00%      cat  [kernel.kallsyms]
> 
> but I don't know what next unfortunately.

I'll have to pass.  I would just stop creating thousands of cgroups ;-)
  
They've become a lot more scalable fairly recently, but if you populate
those thousands with frequently runnable tasks, I suspect you'll still
see huge truckloads of scheduler in profiles.. maybe even nothing else. 

> I also checked the same thing on the other server with the 2.6.37 kernel,
> there' some thousands cgroups too, and it somehow works there immediately.




