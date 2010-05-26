Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0EZCjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:39:47 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:46157 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384Ab0EZCjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:39:45 -0400
X-AuditID: 83cfa826-b7cc7ae000001453-65-4bfc89ef0fd7
From: Yang Ruirui <ruirui.r.yang@tieto.com>
Organization: Tieto China
To: <linux-kernel@vger.kernel.org>
Subject: sysrq+s lockdep warning
Date: Wed, 26 May 2010 10:40:22 +0800
User-Agent: KMail/1.11.4 (Linux/2.6.34-07097-gf4b87de-dirty; KDE/4.2.4; x86_64; ; )
CC: <hidave.darkstar@gmail.com>, <fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201005261040.23498.ruirui.r.yang@tieto.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sysrq emergency sync triggered following lockdep warning, how to deal with it?
The emergency sync is in a work queue now, but consider it's "emergency", how about directly call sync functions instead of put them into work queue?

[19985.379671] SysRq : Emergency Sync                                                            
[19987.539673] SysRq : Emergency Sync                                                            
[19994.937853]                                                                                   
[19994.937854] =======================================================                           
[19994.937857] [ INFO: possible circular locking dependency detected ]                           
[19994.937859] 2.6.34-07097-gf4b87de-dirty #32                                                   
[19994.937861] -------------------------------------------------------                           
[19994.937862] events/0/7 is trying to acquire lock:                                             
[19994.937864]  (&type->s_umount_key#19){++++..}, at: [<ffffffff810e729e>] iterate_supers+0x5d/0xb2                                                                                               
[19994.937872]                                                                                   
[19994.937873] but task is already holding lock:                                                 
[19994.937874]  ((work)#3){+.+...}, at: [<ffffffff8104b5d0>] worker_thread+0x1d5/0x332           
[19994.937880]                                                                                   
[19994.937881] which lock already depends on the new lock.                                       
[19994.937881]                                                                                   
[19994.937883]                                                                                   
[19994.937883] the existing dependency chain (in reverse order) is:                              
[19994.937885]                                                                                   
[19994.937885] -> #3 ((work)#3){+.+...}:                                                         
[19994.937889]        [<ffffffff81061bff>] lock_acquire+0xd2/0xfe                                
[19994.937892]        [<ffffffff8104b61e>] worker_thread+0x223/0x332                             
[19994.937895]        [<ffffffff8104f0ee>] kthread+0x7d/0x85                                     
[19994.937898]        [<ffffffff81003844>] kernel_thread_helper+0x4/0x10                         
[19994.937902]                                                                                   
[19994.937903] -> #2 (events){+.+.+.}:                                                           
[19994.937906]        [<ffffffff81061bff>] lock_acquire+0xd2/0xfe                                
[19994.937909]        [<ffffffff8104c1e3>] flush_work+0x67/0xf2                                  
[19994.937911]        [<ffffffff8104c39c>] schedule_on_each_cpu+0x12e/0x16d                      
[19994.937914]        [<ffffffff810b8c9f>] lru_add_drain_all+0x10/0x12                           
[19994.937918]        [<ffffffff811079c2>] invalidate_bdev+0x36/0x49                             
[19994.937922]        [<ffffffff8116a5a9>] ext4_put_super+0x28a/0x317                            
[19994.937926]        [<ffffffff810e80e5>] generic_shutdown_super+0x51/0xd2                      
[19994.937929]        [<ffffffff810e8188>] kill_block_super+0x22/0x3a                            
[19994.937932]        [<ffffffff810e752f>] deactivate_locked_super+0x3d/0x5d                     
[19994.937934]        [<ffffffff810e798e>] deactivate_super+0x40/0x44                            
[19994.937937]        [<ffffffff810fbed4>] mntput_no_expire+0xbb/0xf0                            
[19994.937941]        [<ffffffff810fc48f>] sys_umount+0x2cf/0x2fa                                
[19994.937943]        [<ffffffff810029c2>] system_call_fastpath+0x16/0x1b                        
[19994.937947]                                                                                   
[19994.937947] -> #1 (&type->s_lock_key){+.+...}:                                                
[19994.937950]        [<ffffffff81061bff>] lock_acquire+0xd2/0xfe                                
[19994.937953]        [<ffffffff81528ebf>] __mutex_lock_common+0x48/0x34d                        
[19994.937957]        [<ffffffff81529273>] mutex_lock_nested+0x37/0x3c                           
[19994.937960]        [<ffffffff810e6c70>] lock_super+0x22/0x24                                  
[19994.937964]        [<ffffffff81169f06>] ext4_remount+0x50/0x469                               
[19994.937967]        [<ffffffff810e6f43>] do_remount_sb+0xfb/0x158                              
[19994.937969]        [<ffffffff810fd36b>] do_mount+0x283/0x7e3                                  
[19994.937972]        [<ffffffff810fd94a>] sys_mount+0x7f/0xb9                                   
[19994.937975]        [<ffffffff810029c2>] system_call_fastpath+0x16/0x1b                        
[19994.937978]                                                                                   
[19994.937978] -> #0 (&type->s_umount_key#19){++++..}:                                           
[19994.937982]        [<ffffffff81061807>] __lock_acquire+0xaf9/0xe1f                            
[19994.937985]        [<ffffffff81061bff>] lock_acquire+0xd2/0xfe                                
[19994.937987]        [<ffffffff8152954d>] down_read+0x47/0x5a                                   
[19994.937990]        [<ffffffff810e729e>] iterate_supers+0x5d/0xb2                              
[19994.937993]        [<ffffffff811052a4>] do_sync_work+0x28/0x5b                                
[19994.937995]        [<ffffffff8104b627>] worker_thread+0x22c/0x332                             
[19994.937998]        [<ffffffff8104f0ee>] kthread+0x7d/0x85                                     
[19994.938001]        [<ffffffff81003844>] kernel_thread_helper+0x4/0x10                         
[19994.938004]                                                                                   
[19994.938005] other info that might help us debug this:                                         
[19994.938005]                                                                                   
[19994.938005] 2 locks held by events/0/7:                                                       
[19994.938005]  #0:  (events){+.+.+.}, at: [<ffffffff8104b5d0>] worker_thread+0x1d5/0x332        
[19994.938005]  #1:  ((work)#3){+.+...}, at: [<ffffffff8104b5d0>] worker_thread+0x1d5/0x332      
[19994.938005]                                                                                   
[19994.938005] stack backtrace:
[19994.938005] Pid: 7, comm: events/0 Not tainted 2.6.34-07097-gf4b87de-dirty #32
[19994.938005] Call Trace:
[19994.938005]  [<ffffffff810608da>] print_circular_bug+0xc0/0xd1
[19994.938005]  [<ffffffff81061807>] __lock_acquire+0xaf9/0xe1f
[19994.938005]  [<ffffffff8152a9d0>] ? restore_args+0x0/0x30
[19994.938005]  [<ffffffff81529dd4>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[19994.938005]  [<ffffffff81090418>] ? handle_edge_irq+0x101/0x12d
[19994.938005]  [<ffffffff81061bff>] lock_acquire+0xd2/0xfe
[19994.938005]  [<ffffffff810e729e>] ? iterate_supers+0x5d/0xb2
[19994.938005]  [<ffffffff81105355>] ? sync_one_sb+0x0/0x1d
[19994.938005]  [<ffffffff8152954d>] down_read+0x47/0x5a
[19994.938005]  [<ffffffff810e729e>] ? iterate_supers+0x5d/0xb2
[19994.938005]  [<ffffffff810e729e>] iterate_supers+0x5d/0xb2
[19994.938005]  [<ffffffff811052a4>] do_sync_work+0x28/0x5b
[19994.938005]  [<ffffffff8104b627>] worker_thread+0x22c/0x332
[19994.938005]  [<ffffffff8104b5d0>] ? worker_thread+0x1d5/0x332
[19994.938005]  [<ffffffff8102f911>] ? finish_task_switch+0x69/0xd9
[19994.938005]  [<ffffffff8102f8a8>] ? finish_task_switch+0x0/0xd9
[19994.938005]  [<ffffffff8110527c>] ? do_sync_work+0x0/0x5b
[19994.938005]  [<ffffffff8104f54e>] ? autoremove_wake_function+0x0/0x38
[19994.938005]  [<ffffffff8104b3fb>] ? worker_thread+0x0/0x332
[19994.938005]  [<ffffffff8104f0ee>] kthread+0x7d/0x85
[19994.938005]  [<ffffffff81003844>] kernel_thread_helper+0x4/0x10
[19994.938005]  [<ffffffff8152a9d0>] ? restore_args+0x0/0x30
[19994.938005]  [<ffffffff8104f071>] ? kthread+0x0/0x85
[19994.938005]  [<ffffffff81003840>] ? kernel_thread_helper+0x0/0x10
[19994.938731] Emergency Sync complete
[19994.938768] Emergency Sync complete


--
Thanks
Yang Ruirui
