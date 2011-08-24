Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1HXVnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:43:20 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:42659 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1HXVnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:43:18 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 17:43:18 EDT
From: "Will Simoneau" <simoneau@ele.uri.edu>
Date: Wed, 24 Aug 2011 17:19:07 -0400
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com
Subject: 2.6.39.4: Oops in rcu_read_unlock_special()/_raw_spin_lock()
Message-ID: <20110824211907.GA4225@ele.uri.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 [Linux 2.6.38.4 x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this rather odd Oops and some subsequent BUGs on a rather odd
piece of hardware. I'm sending this message in hope that someone who
understands the code can decide if it's a real problem or not.

First of all, let me explain the situation: I am running Linux 2.6.39.4
on a system-on-FPGA I designed. The system has 4 CPU cores which are
essentially MIPS R4Ks as far as both kernel and userspace are concerned.
The cores are fully cache-coherent with sequential consistency. The
kernel has been modified with relatively minor patches to support the
CPUs and peripherals.

The below Oops/BUGs were captured on a serial console during a large
rsync job. I do not know of a way to reproduce the Oops, I've only seen
it once. Some recent changes have been made suspiciously close to the
exploding code, which makes me think that maybe 2.6.39-stable is lacking
some fixes? The following commits from Linus' git seem vaguely related,
although I have no idea how relevant they are to 2.6.39.4:

   ec433f0c (softirq,rcu: Inform RCU of irq_exit() activity)
   10f39bb1 (rcu: protect __rcu_read_unlock() against scheduler-using
             irq handlers)
   
--- 8< ---
[898755.190000] CPU 2 Unable to handle kernel paging request at
 virtual address 00000000, epc == 802eefd8, ra == 8006a788
[898755.190000] Oops[#1]:                                 
[898755.190000] Cpu 2    
[898755.190000] $ 0   : 00000000 10009800 00010000 00000001
[898755.190000] $ 4   : 00000000 82865450 10009800 ffff00fe
[898755.190000] $ 8   : 80843fe0 00009800 00000000 80844000
[898755.190000] $12   : 03070001 00129eaf 00000000 00000000
[898755.190000] $16   : 00000000 00000008 80843dc0 10009801
[898755.190000] $20   : 82861630 87e45900 00000008 00000001
[898755.190000] $24   : 00000000 8025c800                  
[898755.190000] $28   : 80842000 80843d10 87e46494 8006a788
[898755.190000] Hi    : 00033169                           
[898755.250000] Lo    : bfd70980
[898755.260000] epc   : 802eefd8 _raw_spin_lock+0x10/0x3c
[898755.260000]     Not tainted                          
[898755.260000] ra    : 8006a788 rcu_read_unlock_special+0x134/0x2bc
[898755.260000] Status: 10009802    KERNEL EXL                      
[898755.260000] Cause : 00000008               
[898755.260000] BadVA : 00000000
[898755.260000] PrId  : 00004800 (Z4800)
[898755.260000] Process rsync (pid: 3683, threadinfo=80842000, task=82861630, tl
s=2b6ba8b0)
[898755.260000] Stack : 10009801 00000001 87e46494 87e46300 87e46300 00000008 00
000008 80843dc0
[898755.260000]         80843de0 87e46300 87e45900 802c6bdc 80843dd0 80843dcc 00
000000 00000020
[898755.260000]         00000000 828581c0 85eda780 00000000 00000e63 00000000 00
000000 00000001
[898755.260000]         00000008 87e4637c 87e46344 00000080 87118800 80843dc0 80
843e30 80843e38
[898755.260000]         fffffdee 80843e30 80843f10 00000020 00000000 7fb57a68 7f
b57a78 802461b8
[898755.260000]         ...
[898755.260000] Call Trace:
[898755.260000] [<802eefd8>] _raw_spin_lock+0x10/0x3c
[898755.260000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898755.260000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898755.260000] [<802461b8>] sock_aio_write+0x138/0x154     
[898755.260000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898755.260000] [<800a719c>] vfs_write+0x15c/0x164   
[898755.260000] [<800a72a4>] sys_write+0x50/0xa0  
[898755.260000] [<8000aa1c>] stack_done+0x20/0x40
[898755.260000]                                  
[898755.260000] 
[898755.260000] Code: 24630001  af830014  3c020001 <c0830000> 00622821  e0850000
  10a0fffc  00032c02  3063ffff 
[898755.260000] Disabling lock debugging due to kernel taint
[898755.400000] note: rsync[3683] exited with preempt_count 1
[898755.410000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898755.410000] Call Trace:                                        
[898755.420000] [<802ec028>] dump_stack+0x8/0x34
[898755.420000] [<802ecd84>] schedule+0x61c/0x690
[898755.430000] [<802ed110>] _cond_resched+0x4c/0x60
[898755.430000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898755.440000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898755.440000] [<800293d4>] mmput+0x58/0x104     
[898755.450000] [<8002d850>] exit_mm+0x130/0x178
[898755.450000] [<8002f638>] do_exit+0x254/0x310
[898755.460000] [<800089ec>] die+0xec/0x114     
[898755.460000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898755.470000] [<800032a4>] ret_from_exception+0x0/0x10
[898755.480000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898755.480000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898755.490000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898755.500000] [<802461b8>] sock_aio_write+0x138/0x154     
[898755.500000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898755.510000] [<800a719c>] vfs_write+0x15c/0x164   
[898755.510000] [<800a72a4>] sys_write+0x50/0xa0  
[898755.520000] [<8000aa1c>] stack_done+0x20/0x40
[898755.520000]                                  
[898755.540000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898755.540000] Call Trace:                                        
[898755.550000] [<802ec028>] dump_stack+0x8/0x34
[898755.550000] [<802ecd84>] schedule+0x61c/0x690
[898755.560000] [<802ed110>] _cond_resched+0x4c/0x60
[898755.560000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898755.570000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898755.570000] [<800293d4>] mmput+0x58/0x104     
[898755.570000] [<8002d850>] exit_mm+0x130/0x178
[898755.580000] [<8002f638>] do_exit+0x254/0x310
[898755.580000] [<800089ec>] die+0xec/0x114     
[898755.590000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898755.590000] [<800032a4>] ret_from_exception+0x0/0x10
[898755.600000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898755.600000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898755.610000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898755.620000] [<802461b8>] sock_aio_write+0x138/0x154     
[898755.620000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898755.630000] [<800a719c>] vfs_write+0x15c/0x164   
[898755.630000] [<800a72a4>] sys_write+0x50/0xa0  
[898755.640000] [<8000aa1c>] stack_done+0x20/0x40
[898755.640000]                                  
[898755.700000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898755.700000] Call Trace:                                        
[898755.700000] [<802ec028>] dump_stack+0x8/0x34
[898755.710000] [<802ecd84>] schedule+0x61c/0x690
[898755.710000] [<802ed110>] _cond_resched+0x4c/0x60
[898755.720000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898755.720000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898755.730000] [<800293d4>] mmput+0x58/0x104     
[898755.730000] [<8002d850>] exit_mm+0x130/0x178
[898755.740000] [<8002f638>] do_exit+0x254/0x310
[898755.740000] [<800089ec>] die+0xec/0x114     
[898755.750000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898755.750000] [<800032a4>] ret_from_exception+0x0/0x10
[898755.760000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898755.760000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898755.770000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898755.770000] [<802461b8>] sock_aio_write+0x138/0x154     
[898755.780000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898755.780000] [<800a719c>] vfs_write+0x15c/0x164   
[898755.790000] [<800a72a4>] sys_write+0x50/0xa0  
[898755.790000] [<8000aa1c>] stack_done+0x20/0x40
[898755.800000]                                  
[898755.820000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898755.820000] Call Trace:                                        
[898755.820000] [<802ec028>] dump_stack+0x8/0x34
[898755.830000] [<802ecd84>] schedule+0x61c/0x690
[898755.830000] [<802ed110>] _cond_resched+0x4c/0x60
[898755.840000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898755.840000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898755.850000] [<800293d4>] mmput+0x58/0x104     
[898755.850000] [<8002d850>] exit_mm+0x130/0x178
[898755.860000] [<8002f638>] do_exit+0x254/0x310
[898755.860000] [<800089ec>] die+0xec/0x114     
[898755.870000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898755.870000] [<800032a4>] ret_from_exception+0x0/0x10
[898755.880000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898755.880000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898755.890000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898755.900000] [<802461b8>] sock_aio_write+0x138/0x154     
[898755.900000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898755.910000] [<800a719c>] vfs_write+0x15c/0x164   
[898755.910000] [<800a72a4>] sys_write+0x50/0xa0  
[898755.920000] [<8000aa1c>] stack_done+0x20/0x40
[898755.920000]                                  
[898755.930000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898755.930000] Call Trace:                                        
[898755.930000] [<802ec028>] dump_stack+0x8/0x34
[898755.940000] [<802ecd84>] schedule+0x61c/0x690
[898755.940000] [<802ed110>] _cond_resched+0x4c/0x60
[898755.950000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898755.950000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898755.960000] [<800293d4>] mmput+0x58/0x104     
[898755.960000] [<8002d850>] exit_mm+0x130/0x178
[898755.970000] [<8002f638>] do_exit+0x254/0x310
[898755.970000] [<800089ec>] die+0xec/0x114     
[898755.980000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898755.980000] [<800032a4>] ret_from_exception+0x0/0x10
[898755.990000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898755.990000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.000000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.000000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.010000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.010000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.020000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.020000] [<8000aa1c>] stack_done+0x20/0x40
[898756.030000]                                  
[898756.090000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898756.100000] Call Trace:                                        
[898756.100000] [<802ec028>] dump_stack+0x8/0x34
[898756.110000] [<802ecd84>] schedule+0x61c/0x690
[898756.110000] [<802ed110>] _cond_resched+0x4c/0x60
[898756.120000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898756.120000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898756.130000] [<800293d4>] mmput+0x58/0x104     
[898756.130000] [<8002d850>] exit_mm+0x130/0x178
[898756.140000] [<8002f638>] do_exit+0x254/0x310
[898756.140000] [<800089ec>] die+0xec/0x114     
[898756.150000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898756.150000] [<800032a4>] ret_from_exception+0x0/0x10
[898756.160000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898756.170000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.170000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.180000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.180000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.190000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.190000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.200000] [<8000aa1c>] stack_done+0x20/0x40
[898756.200000]                                  
[898756.230000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898756.230000] Call Trace:                                        
[898756.230000] [<802ec028>] dump_stack+0x8/0x34
[898756.240000] [<802ecd84>] schedule+0x61c/0x690
[898756.240000] [<802ed110>] _cond_resched+0x4c/0x60
[898756.250000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898756.250000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898756.260000] [<800293d4>] mmput+0x58/0x104     
[898756.270000] [<8002d850>] exit_mm+0x130/0x178
[898756.270000] [<8002f638>] do_exit+0x254/0x310
[898756.280000] [<800089ec>] die+0xec/0x114     
[898756.280000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898756.290000] [<800032a4>] ret_from_exception+0x0/0x10
[898756.290000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898756.300000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.300000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.310000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.320000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.320000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.330000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.330000] [<8000aa1c>] stack_done+0x20/0x40
[898756.340000]                                  
[898756.360000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898756.360000] Call Trace:                                        
[898756.360000] [<802ec028>] dump_stack+0x8/0x34
[898756.370000] [<802ecd84>] schedule+0x61c/0x690
[898756.370000] [<802ed110>] _cond_resched+0x4c/0x60
[898756.380000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898756.380000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898756.390000] [<800293d4>] mmput+0x58/0x104     
[898756.390000] [<8002d850>] exit_mm+0x130/0x178
[898756.400000] [<8002f638>] do_exit+0x254/0x310
[898756.400000] [<800089ec>] die+0xec/0x114     
[898756.410000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898756.410000] [<800032a4>] ret_from_exception+0x0/0x10
[898756.420000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898756.420000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.430000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.440000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.440000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.450000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.450000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.460000] [<8000aa1c>] stack_done+0x20/0x40
[898756.460000]                                  
[898756.470000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898756.470000] Call Trace:                                        
[898756.470000] [<802ec028>] dump_stack+0x8/0x34
[898756.480000] [<802ecd84>] schedule+0x61c/0x690
[898756.480000] [<802ed110>] _cond_resched+0x4c/0x60
[898756.490000] [<8008f82c>] unmap_vmas+0x1e0/0x30c 
[898756.490000] [<800922c8>] exit_mmap+0x10c/0x1dc 
[898756.500000] [<800293d4>] mmput+0x58/0x104     
[898756.500000] [<8002d850>] exit_mm+0x130/0x178
[898756.510000] [<8002f638>] do_exit+0x254/0x310
[898756.510000] [<800089ec>] die+0xec/0x114     
[898756.520000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898756.520000] [<800032a4>] ret_from_exception+0x0/0x10
[898756.530000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898756.530000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.540000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.550000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.550000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.560000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.560000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.570000] [<8000aa1c>] stack_done+0x20/0x40
[898756.570000]                                  
[898756.580000] BUG: scheduling while atomic: rsync/3683/0x10000002
[898756.580000] Call Trace:                                        
[898756.590000] [<802ec028>] dump_stack+0x8/0x34
[898756.590000] [<802ecd84>] schedule+0x61c/0x690
[898756.600000] [<802ed110>] _cond_resched+0x4c/0x60
[898756.600000] [<8002db64>] put_files_struct+0x144/0x158
[898756.610000] [<8002f640>] do_exit+0x25c/0x310         
[898756.610000] [<800089ec>] die+0xec/0x114     
[898756.620000] [<8000c2b8>] do_page_fault+0x2a8/0x330
[898756.620000] [<800032a4>] ret_from_exception+0x0/0x10
[898756.630000] [<802eefd8>] _raw_spin_lock+0x10/0x3c   
[898756.630000] [<8006a788>] rcu_read_unlock_special+0x134/0x2bc
[898756.640000] [<802c6bdc>] unix_stream_sendmsg+0x278/0x44c    
[898756.640000] [<802461b8>] sock_aio_write+0x138/0x154     
[898756.650000] [<800a6460>] do_sync_write+0xc4/0x13c  
[898756.660000] [<800a719c>] vfs_write+0x15c/0x164   
[898756.660000] [<800a72a4>] sys_write+0x50/0xa0  
[898756.670000] [<8000aa1c>] stack_done+0x20/0x40
--- 8< ---

--- 8< ---
$ grep RCU .config
# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
--- 8< ---

Any input is appreciated. I would love to be able to definitively blame
this on fixes that simply haven't been backported, instead of bringing
the hardware design into question.

I would upgrade to 3.0 or newer, but I haven't been able to get such a
kernel to boot. It dies just after going SMP - which might be my fault.
However, that's a seperate issue, and I haven't spent much time trying
to figure out what goes wrong yet.

I can provide all sorts of further info on request, let me know what you
need. Thanks for looking.
