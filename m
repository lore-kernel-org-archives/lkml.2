Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2DQJgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:36:33 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:21942
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab2DQJgc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:36:32 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz936eKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2MAOP-01-D5A-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: A quick view of the performance benchmark for semaphore-like and
 mutex
Thread-Topic: A quick view of the performance benchmark for semaphore-like
 and mutex
Thread-Index: Ac0bq8MflXUZwOd4SI6p7+Nhh3anqAALxinAACf1RvA=
Date: Tue, 17 Apr 2012 09:36:09 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as a quick & rough test, with below changes based on mutex (almost the same as semaphore):

--- /home/dennis/Linux/linux-3.3.2-sem/kernel/mutex.c   2012-04-17 14:59:49.823177615 +0800
+++ ./mutex.c   2012-04-17 17:00:12.963059284 +0800
@@ -140,6 +140,7 @@ __mutex_lock_common(struct mutex *lock,
        preempt_disable();
        mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
+#if 0
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
        /*
         * Optimistic spinning.
@@ -195,6 +196,7 @@ __mutex_lock_common(struct mutex *lock,
                arch_mutex_cpu_relax();
        }
 #endif
+#endif
        spin_lock_mutex(&lock->wait_lock, flags);
 
        debug_mutex_lock_common(lock, &waiter);


#perf record -a perf bench locking mutex -p 8 -t 3000

The benchmark result BEFORE (mutex)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
round 1:
Total duration     39868 s   536095 us

real: 15.89   s
user: 0.00   
sys:  0.31  

Events: 64K cycles
 20.18%           perf  [kernel.kallsyms]                  [k] __mutex_lock_slowpath                                                      
  8.41%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                              
  8.00%           perf  [kernel.kallsyms]                  [k] mutex_unlock                                                               
  5.29%           perf  [kernel.kallsyms]                  [k] mutex_lock                                                                  
  2.88%           perf  [kernel.kallsyms]                  [k] link_path_walk                                                              
  2.56%           perf  [kernel.kallsyms]                  [k] __mutex_unlock_slowpath                                                     
  2.31%           perf  [kernel.kallsyms]                  [k] mutex_spin_on_owner                                                         
  2.29%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                      
  1.68%           perf  [kernel.kallsyms]                  [k] __d_lookup                                                                  
  1.33%           perf  [kernel.kallsyms]                  [k] dput                                                                        
  1.33%           perf  [kernel.kallsyms]                  [k] clear_page_c                                                               
  1.06%           perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                         
  1.04%           perf  [kernel.kallsyms]                  [k] do_lookup                        
  ...
-------------------------------------------------------------------------------------
round 2:
Total duration     39748 s   176410 us

real: 15.92   s
user: 0.00   
sys:  0.32

Events: 63K cycles
 19.68%           perf  [kernel.kallsyms]                  [k] __mutex_lock_slowpath                                                      
  8.53%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                              
  7.74%           perf  [kernel.kallsyms]                  [k] mutex_unlock                                                               
  5.09%           perf  [kernel.kallsyms]                  [k] mutex_lock                                                                  
  3.06%           perf  [kernel.kallsyms]                  [k] link_path_walk                                                              
  2.54%           perf  [kernel.kallsyms]                  [k] __mutex_unlock_slowpath                                                     
  2.31%           perf  [kernel.kallsyms]                  [k] mutex_spin_on_owner                                                         
  2.30%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                      
  1.76%           perf  [kernel.kallsyms]                  [k] __d_lookup                                                                  
  1.46%           perf  [kernel.kallsyms]                  [k] clear_page_c                                                               
  1.31%           perf  [kernel.kallsyms]                  [k] dput                                                                        
  1.10%           perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                         
  1.08%           perf  [kernel.kallsyms]                  [k] do_lookup  
  ...
-------------------------------------------------------------------------------------
round 3:
Total duration     40047 s   394364 us

real: 15.59   s
user: 0.00   
sys:  0.30   

Events: 58K cycles
 19.18%           perf  [kernel.kallsyms]                  [k] __mutex_lock_slowpath                                                      
  8.68%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                              
  7.80%           perf  [kernel.kallsyms]                  [k] mutex_unlock                                                               
  5.24%           perf  [kernel.kallsyms]                  [k] mutex_lock                                                                  
  3.22%           perf  [kernel.kallsyms]                  [k] link_path_walk                                                              
  2.57%           perf  [kernel.kallsyms]                  [k] __mutex_unlock_slowpath                                                     
  2.38%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                      
  2.13%           perf  [kernel.kallsyms]                  [k] mutex_spin_on_owner                                                         
  1.79%           perf  [kernel.kallsyms]                  [k] __d_lookup                                                                  
  1.54%           perf  [kernel.kallsyms]                  [k] clear_page_c                                                               
  1.34%           perf  [kernel.kallsyms]                  [k] dput                                                                        
  1.12%           perf  [kernel.kallsyms]                  [k] do_lookup                                                                  
  1.04%           perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                         
  1.02%           perf  [kernel.kallsyms]                  [k] system_call                                                                 
  1.02%           perf  [kernel.kallsyms]                  [k] get_page_from_freelist
  ...

The benchmark result AFTER (remove the optimization part of mutex)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
round 1:
Total duration     66319 s   868892 us

 real: 23.16   s
 user: 0.00   
 sys:  0.29  

Events: 81K cycles
  6.30%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                              
  3.13%           perf  [kernel.kallsyms]                  [k] mutex_unlock                                                                
  3.09%           perf  [kernel.kallsyms]                  [k] mutex_lock                                                                  
  3.07%           perf  [kernel.kallsyms]                  [k] link_path_walk                                                              
  2.66%        swapper  [kernel.kallsyms]                  [k] intel_idle                                                                  
  2.21%           perf  [kernel.kallsyms]                  [k] __d_lookup                                                                  
  1.80%           perf  [kernel.kallsyms]                  [k] clear_page_c                                                                
  1.58%           perf  [kernel.kallsyms]                  [k] system_call                                                                 
  1.56%           perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                         
  1.53%           perf  [kernel.kallsyms]                  [k] do_lookup                                                                   
  1.47%           perf  [kernel.kallsyms]                  [k] dput                                                                        
  1.43%           perf  [kernel.kallsyms]                  [k] get_page_from_freelist                                                      
  1.28%           perf  libc-2.13.so                       [.] 0xa99f6                                                                     
  1.19%        swapper  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                      
  1.15%           perf  [kernel.kallsyms]                  [k] vfsmount_lock_local_lock                                                    
  1.12%           perf  [kernel.kallsyms]                  [k] kfree        
  ...   
-------------------------------------------------------------------------------------
round 2:
Total duration     67448 s   392232 us

 real: 23.21   s
 user: 0.00   
 sys:  0.29

Events: 82K cycles
  6.23%             perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                            
  3.23%             perf  [kernel.kallsyms]                  [k] mutex_unlock                                                              
  3.10%             perf  [kernel.kallsyms]                  [k] mutex_lock                                                                
  3.10%             perf  [kernel.kallsyms]                  [k] link_path_walk                                                            
  2.59%          swapper  [kernel.kallsyms]                  [k] intel_idle                                                                
  2.18%             perf  [kernel.kallsyms]                  [k] __d_lookup                                                                
  1.88%             perf  [kernel.kallsyms]                  [k] clear_page_c                                                              
  1.60%             perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                       
  1.50%             perf  [kernel.kallsyms]                  [k] system_call                                                               
  1.48%             perf  [kernel.kallsyms]                  [k] dput                                                                      
  1.44%             perf  [kernel.kallsyms]                  [k] do_lookup                                                                 
  1.33%             perf  [kernel.kallsyms]                  [k] get_page_from_freelist                                                    
  1.29%             perf  libc-2.13.so                       [.] 0x82715                                                                   
  1.19%          swapper  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                    
  1.11%             perf  [kernel.kallsyms]                  [k] kfree                                                                     
  1.10%             perf  [kernel.kallsyms]                  [k] vfsmount_lock_local_lock                                                  
  1.01%             perf  [kernel.kallsyms]                  [k] __alloc_pages_nodemask
  ...
-------------------------------------------------------------------------------------
round 3:
Total duration     66468 s   532417 us

 real: 23.35   s
 user: 0.00   
 sys:  0.28
Events: 87K cycles
  6.30%             perf  [kernel.kallsyms]                  [k] _raw_spin_lock                                                            
  3.09%             perf  [kernel.kallsyms]                  [k] mutex_unlock                                                              
  2.98%             perf  [kernel.kallsyms]                  [k] link_path_walk                                                            
  2.98%             perf  [kernel.kallsyms]                  [k] mutex_lock                                                                
  2.70%          swapper  [kernel.kallsyms]                  [k] intel_idle                                                                
  2.25%             perf  [kernel.kallsyms]                  [k] __d_lookup                                                                
  1.92%             perf  [kernel.kallsyms]                  [k] clear_page_c                                                              
  1.56%             perf  [kernel.kallsyms]                  [k] __strncpy_from_user                                                       
  1.47%             perf  [kernel.kallsyms]                  [k] dput                                                                      
  1.47%             perf  [kernel.kallsyms]                  [k] system_call                                                               
  1.42%             perf  [kernel.kallsyms]                  [k] do_lookup                                                                 
  1.35%             perf  [kernel.kallsyms]                  [k] get_page_from_freelist                                                    
  1.32%             perf  libc-2.13.so                       [.] 0x12902e                                                                  
  1.32%          swapper  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave                                                    
  1.10%             perf  [kernel.kallsyms]                  [k] vfsmount_lock_local_lock                                                  
  1.02%             perf  [kernel.kallsyms]                  [k] kfree                                                                     
  1.00%             perf  [kernel.kallsyms]                  [k] __alloc_pages_nodemask

Interesting!! Semaphore-like is almost 8s slower than mutex... Also, the Events sycles of perf
reported is different



 


                                                                

