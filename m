Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2IHPIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:08:47 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:43681 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IHPIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:08:46 -0400
Date: Sat, 8 Sep 2012 08:08:39 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET RESEND 0/5] perf tools: Cleanup hist printing code (v4)
Message-ID: <20120908150839.GH20401@ghostprotocols.net>
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
 <20120908004854.GD20401@ghostprotocols.net>
 <87ipboaa2j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipboaa2j.fsf@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 08, 2012 at 11:00:36PM +0900, Namhyung Kim escreveu:
> On Fri, 7 Sep 2012 17:48:54 -0700, Arnaldo Carvalho de Melo wrote:
> > Please try with:

> >   perf record -a usleep 1
> >   perf record -a usleep 1
> >   perf diff

> > it will use perf.data.old and perf.data and will segfault in that branch.

> I see the problem.  I overlooked he->pair can be NULL when perf diff is
> running.  So the fix will be adding a NULL check before the line.  In
> case of NULL, it will default to 0, so no problem.

Ok, now it doesn't segfaults, but the diff results seems bogus:

Withour this patch + your fix:

[root@sandy ~]# perf diff
# Event 'cycles'
#
# Baseline  Delta          Shared Object                                  Symbol
# ........ ..........  .................  ......................................
#
     0.00%    +39.61%  [kernel.kallsyms]  [k] __alloc_pages_nodemask            
    19.82%     +6.10%  [kernel.kallsyms]  [k] intel_idle                        
     0.00%     +8.61%  [kernel.kallsyms]  [k] generic_exec_single               
     0.00%     +6.39%  [kernel.kallsyms]  [k] list_del                          
     0.00%     +6.15%  [kernel.kallsyms]  [k] nr_iowait_cpu                     
     0.00%     +5.98%  [kernel.kallsyms]  [k] selinux_inode_permission          
     0.00%     +5.23%  libc-2.12.so       [.] _dl_addr                          
     0.00%     +0.76%  [kernel.kallsyms]  [k] group_sched_in                    
     0.10%     +0.32%  [kernel.kallsyms]  [k] native_write_msr_safe             
     0.00%     +0.40%  [kernel.kallsyms]  [k] smp_call_function_single_interrupt
     0.14%     +0.19%  [kernel.kallsyms]  [k] csd_unlock                        
     0.00%     +0.20%  [kernel.kallsyms]  [k] perf_pmu_enable                   

With your patch:

[root@sandy ~]# perf diff
# Event 'cycles'
#
# Baseline   Delta       Shared Object                                  Symbol
# ........  .......  .................  ......................................
#
    39.61%  +39.61%  [kernel.kallsyms]  [k] __alloc_pages_nodemask            
    25.92%   +6.10%  [kernel.kallsyms]  [k] intel_idle                        
     8.61%   +8.61%  [kernel.kallsyms]  [k] generic_exec_single               
     6.39%   +6.39%  [kernel.kallsyms]  [k] list_del                          
     6.15%   +6.15%  [kernel.kallsyms]  [k] nr_iowait_cpu                     
     5.98%   +5.98%  [kernel.kallsyms]  [k] selinux_inode_permission          
     5.23%   +5.23%  libc-2.12.so       [.] _dl_addr                          
     0.76%   +0.76%  [kernel.kallsyms]  [k] group_sched_in                    
     0.42%   +0.32%  [kernel.kallsyms]  [k] native_write_msr_safe             
     0.40%   +0.40%  [kernel.kallsyms]  [k] smp_call_function_single_interrupt
     0.33%   +0.19%  [kernel.kallsyms]  [k] csd_unlock                        
     0.20%   +0.20%  [kernel.kallsyms]  [k] perf_pmu_enable                   
[root@sandy ~]#

The deltas are the same, but the baseline completely changed and are bogus.

So please try again and make sure that the results are kept.

- Arnaldo
