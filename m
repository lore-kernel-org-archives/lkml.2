Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0DWDxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:53:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab0DWDx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:53:29 -0400
Message-ID: <4BD11A24.2070500@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 11:55:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix in swap code (Was Re: [BUG]
 an RCU warning in memcg
References: <4BD10D59.9090504@cn.fujitsu.com> <20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com> <4BD118E2.7080307@cn.fujitsu.com>
In-Reply-To: <4BD118E2.7080307@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> KAMEZAWA Hiroyuki wrote:
>> On Fri, 23 Apr 2010 11:00:41 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
>>> css_id() is not under rcu_read_lock().
>>>
>> Ok. Thank you for reporting.
>> This is ok ? 
> 
> Yes, and I did some more simple tests on memcg, no more warning
> showed up.
> 

oops, after trigging oom, I saw 2 more warnings:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/cgroup.c:4459 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks held by firefox/2258:            
 #0:  (&mm->mmap_sem){++++++}, at: [<c0843090>] do_page_fault+0x100/0x500
 #1:  (tasklist_lock){.?.?.-}, at: [<c04df1ac>] mem_cgroup_out_of_memory+0x2c/0x90

stack backtrace:
Pid: 2258, comm: firefox Not tainted 2.6.34-rc5-tip+ #14
Call Trace:                                             
 [<c083c636>] ? printk+0x1d/0x1f                        
 [<c0480744>] lockdep_rcu_dereference+0x94/0xb0         
 [<c049d61e>] css_is_ancestor+0xce/0xe0                 
 [<c0517c41>] task_in_mem_cgroup+0xd1/0xf0              
 [<c0517b70>] ? task_in_mem_cgroup+0x0/0xf0             
 [<c04def10>] select_bad_process+0x70/0xe0              
 [<c04df1c1>] mem_cgroup_out_of_memory+0x41/0x90        
 [<c04826db>] ? trace_hardirqs_on+0xb/0x10              
 [<c05159e3>] mem_cgroup_handle_oom+0xf3/0x130          
 [<c046bae0>] ? autoremove_wake_function+0x0/0x50       
 [<c0516e01>] __mem_cgroup_try_charge+0x391/0x3d0       
 [<c047eadb>] ? trace_hardirqs_off+0xb/0x10             
 [<c05174c0>] mem_cgroup_charge_common+0x40/0x70        
 [<c0517620>] mem_cgroup_cache_charge+0x130/0x150       
 [<c04db6e7>] add_to_page_cache_locked+0x37/0x130       
 [<c04e5719>] ? __lru_cache_add+0x69/0xb0               
 [<c04db811>] add_to_page_cache_lru+0x31/0x80           
 [<c0549084>] mpage_readpages+0x84/0xf0                 
 [<c057e4d0>] ? ext3_get_block+0x0/0x110                
 [<c057c760>] ? ext3_readpages+0x0/0x20                 
 [<c057c77e>] ext3_readpages+0x1e/0x20                  
 [<c057e4d0>] ? ext3_get_block+0x0/0x110                
 [<c04e4889>] __do_page_cache_readahead+0x219/0x2b0     
 [<c04e4748>] ? __do_page_cache_readahead+0xd8/0x2b0    
 [<c04e4946>] ra_submit+0x26/0x30                       
 [<c04dcf86>] filemap_fault+0x436/0x470                 
 [<c04f6a95>] __do_fault+0x55/0x550                     
 [<c04f7afb>] handle_mm_fault+0x17b/0xad0               
 [<c0843090>] ? do_page_fault+0x100/0x500               
 [<c0842f90>] ? do_page_fault+0x0/0x500                 
 [<c0843109>] do_page_fault+0x179/0x500                 
 [<c04532b1>] ? __do_softirq+0x111/0x260                
 [<c045344f>] ? do_softirq+0x4f/0x70                    
 [<c047ea65>] ? trace_hardirqs_off_caller+0xc5/0x130    
 [<c0840b0f>] ? error_code+0x67/0x70                    
 [<c047ea14>] ? trace_hardirqs_off_caller+0x74/0x130    
 [<c0842f90>] ? do_page_fault+0x0/0x500                 
 [<c0840b13>] error_code+0x6b/0x70                      
 [<c0840000>] ? _raw_read_trylock+0x40/0x90             
 [<c0842f90>] ? do_page_fault+0x0/0x500                 

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/cgroup.c:4460 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks held by firefox/2258:            
 #0:  (&mm->mmap_sem){++++++}, at: [<c0843090>] do_page_fault+0x100/0x500
 #1:  (tasklist_lock){.?.?.-}, at: [<c04df1ac>] mem_cgroup_out_of_memory+0x2c/0x90

stack backtrace:
Pid: 2258, comm: firefox Not tainted 2.6.34-rc5-tip+ #14
Call Trace:                                             
 [<c083c636>] ? printk+0x1d/0x1f                        
 [<c0480744>] lockdep_rcu_dereference+0x94/0xb0         
 [<c049d5e6>] css_is_ancestor+0x96/0xe0                 
 [<c0517c41>] task_in_mem_cgroup+0xd1/0xf0              
 [<c0517b70>] ? task_in_mem_cgroup+0x0/0xf0             
 [<c04def10>] select_bad_process+0x70/0xe0              
 [<c04df1c1>] mem_cgroup_out_of_memory+0x41/0x90        
 [<c04826db>] ? trace_hardirqs_on+0xb/0x10              
 [<c05159e3>] mem_cgroup_handle_oom+0xf3/0x130          
 [<c046bae0>] ? autoremove_wake_function+0x0/0x50       
 [<c0516e01>] __mem_cgroup_try_charge+0x391/0x3d0       
 [<c047eadb>] ? trace_hardirqs_off+0xb/0x10             
 [<c05174c0>] mem_cgroup_charge_common+0x40/0x70        
 [<c0517620>] mem_cgroup_cache_charge+0x130/0x150       
 [<c04db6e7>] add_to_page_cache_locked+0x37/0x130       
 [<c04e5719>] ? __lru_cache_add+0x69/0xb0               
 [<c04db811>] add_to_page_cache_lru+0x31/0x80           
 [<c0549084>] mpage_readpages+0x84/0xf0                 
 [<c057e4d0>] ? ext3_get_block+0x0/0x110                
 [<c057c760>] ? ext3_readpages+0x0/0x20                 
 [<c057c77e>] ext3_readpages+0x1e/0x20                  
 [<c057e4d0>] ? ext3_get_block+0x0/0x110                
 [<c04e4889>] __do_page_cache_readahead+0x219/0x2b0     
 [<c04e4748>] ? __do_page_cache_readahead+0xd8/0x2b0    
 [<c04e4946>] ra_submit+0x26/0x30                       
 [<c04dcf86>] filemap_fault+0x436/0x470                 
 [<c04f6a95>] __do_fault+0x55/0x550                     
 [<c04f7afb>] handle_mm_fault+0x17b/0xad0               
 [<c0843090>] ? do_page_fault+0x100/0x500               
 [<c0842f90>] ? do_page_fault+0x0/0x500                 
 [<c0843109>] do_page_fault+0x179/0x500                 
 [<c04532b1>] ? __do_softirq+0x111/0x260                
 [<c045344f>] ? do_softirq+0x4f/0x70                    
 [<c047ea65>] ? trace_hardirqs_off_caller+0xc5/0x130    
 [<c0840b0f>] ? error_code+0x67/0x70                    
 [<c047ea14>] ? trace_hardirqs_off_caller+0x74/0x130    
 [<c0842f90>] ? do_page_fault+0x0/0x500                 
 [<c0840b13>] error_code+0x6b/0x70                      
 [<c0840000>] ? _raw_read_trylock+0x40/0x90             
 [<c0842f90>] ? do_page_fault+0x0/0x500                 

