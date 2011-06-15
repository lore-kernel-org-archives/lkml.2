Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1FOB1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:27:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:61099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1FOB07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:26:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,368,1304319600"; 
   d="scan'208";a="14770057"
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Shaohua Li <shaohua.li@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1308097798.17300.142.camel@schen9-DESK>
References: <1308097798.17300.142.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 09:26:54 +0800
Message-ID: <1308101214.15392.151.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 08:29 +0800, Tim Chen wrote:
> It seems like that the recent changes to make the anon_vma->lock into a
> mutex (commit 2b575eb6) causes a 52% regression in throughput (2.6.39 vs
> 3.0-rc2) on exim mail server workload in the MOSBENCH test suite.
> 
> Our test setup is on a 4 socket Westmere EX system, with 10 cores per
> socket.  40 clients are created on the test machine which send email
> to the exim server residing on the sam test machine.
> 
> Exim forks off child processes to handle the incoming mail, and the
> process exits after the mail delivery completes. We see quite a bit of
> acquisition of the anon_vma->lock as a result.  
> 
> On 2.6.39, the contention of anon_vma->lock occupies 3.25% of cpu.
> However, after the switch of the lock to mutex on 3.0-rc2, the mutex
> acquisition jumps to 18.6% of cpu.  This seems to be the main cause of
> the 52% throughput regression.
> 
> Other workloads which have a lot of forks/exits may be similarly
> affected by this regression.  Workloads which are vm lock intensive
> could be affected too.
> 
> I've listed the profile of 3.0-rc2 and 2.6.39 below for comparison.
> 
> Thanks.
> 
> Tim
> 
> 
> ---------------------------
> 3.0-rc2 profile:
> 
> -     18.60%          exim  [kernel.kallsyms]        [k] __mutex_lock_common.clone.5 
>    - __mutex_lock_common.clone.5                                                     
>       - 99.99% __mutex_lock_slowpath                                                 
>          - mutex_lock                                                                
>             - 99.54% anon_vma_lock.clone.10                                          
>                + 38.99% anon_vma_clone                                               
>                + 37.56% unlink_anon_vmas                                             
>                + 11.92% anon_vma_fork                                                
>                + 11.53% anon_vma_free                                                
> +      4.03%          exim  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave      
> -      3.00%          exim  [kernel.kallsyms]        [k] do_raw_spin_lock            
>    - do_raw_spin_lock                                                                
>       - 94.11% _raw_spin_lock                                                        
>          + 47.32% __mutex_lock_common.clone.5                                        
>          + 14.23% __mutex_unlock_slowpath                                            
>          + 4.06% handle_pte_fault                                                    
>          + 3.81% __do_fault                                                          
>          + 3.16% unmap_vmas                                                          
>          + 2.46% lock_flocks                                                         
>          + 2.43% copy_pte_range                                                      
>          + 2.28% __task_rq_lock                                                      
>          + 1.30% __percpu_counter_add                                                
>          + 1.30% dput                                                                
>          + 1.27% add_partial                                                         
>          + 1.24% free_pcppages_bulk                                                  
>          + 1.07% d_alloc                                                             
>          + 1.07% get_page_from_freelist                                              
>          + 1.02% complete_walk                                                       
>          + 0.89% dget                                                                
>          + 0.71% new_inode                                                           
>          + 0.61% __mod_timer                                                         
>          + 0.58% dup_fd                                                              
>          + 0.50% double_rq_lock                                                      
>       + 3.66% _raw_spin_lock_irq                                                     
>       + 0.87% _raw_spin_lock_bh                                                      
> +      2.90%          exim  [kernel.kallsyms]        [k] page_fault                  
> +      2.25%          exim  [kernel.kallsyms]        [k] mutex_unlock     
> 
> 
> -----------------------------------
> 
> 2.6.39 profile:
> +      4.84%          exim  [kernel.kallsyms]        [k] page_fault
> +      3.83%          exim  [kernel.kallsyms]        [k] clear_page_c
> -      3.25%          exim  [kernel.kallsyms]        [k] do_raw_spin_lock
>    - do_raw_spin_lock
>       - 91.86% _raw_spin_lock
>          + 14.16% unlink_anon_vmas
>          + 12.54% unlink_file_vma
>          + 7.30% anon_vma_clone_batch
what are you testing? I didn't see Andi's batch anon->lock for fork
patches are merged in 2.6.39.

Thanks,
Shaohua

