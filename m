Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101Ab0J2WWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:22:34 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53265 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761716Ab0J2WWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:22:32 -0400
Date: Fri, 29 Oct 2010 17:22:28 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [BUG] intr_remap: Simplify the code further
Message-ID: <20101029222227.GJ32456@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a regression that is causing a NULL pointer dereference
in free_irte when shutting down xpc.  git bisect narrowed it down
to git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139, which 
changed free_irte().  Reverse applying the patch fixes the problem.



git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139
---------------------------------------------------------
commit d585d060b42bd36f6f0b23ff327d3b91f80c7139
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Oct 10 12:34:27 2010 +0200

    intr_remap: Simplify the code further

    Having irq_2_iommu in struct irq_cfg allows further simplifications.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Reviewed-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---------------------------------------------------------




The failing output on real hardware:
----------------------------------------------------------------------------                               
Sending all processes the TERM signal...                              done
Sending all processes the KILL signal...
Please stand by while rebooting the system...
[ 4020.514342] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[ 4020.523091] IP: [<ffffffff8121a791>] free_irte+0x46/0xe4
[ 4020.529024] PGD 3f5ac5067 PUD 3f6487067 PMD 0
[ 4020.534007] Oops: 0000 [#1] SMP
[ 4020.537626] last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/vendor
[ 4020.551197] xpc : all partitions have deactivated
[ 4020.556437] CPU 25
[ 4020.558580] Modules linked in:
[ 4020.562199] 
[ 4020.563858] Pid: 13489, comm: reboot Not tainted 2.6.36-tip+ #5 /Stoutland Platform
[ 4020.572390] RIP: 0010:[<ffffffff8121a791>]  [<ffffffff8121a791>] free_irte+0x46/0xe4
[ 4020.581030] RSP: 0018:ffff88047cdb1c38  EFLAGS: 00010046 
[ 4020.586948] RAX: 0000000000000246 RBX: ffff8803f6b50b60 RCX: 0000000000000000
[ 4020.594900] RDX: 0000000000000113 RSI: 0000000000000000 RDI: 0000000000000000
[ 4020.602851] RBP: ffff88047cdb1c68 R08: ffff8803f6b50ac0 R09: 00000000ffffffff
[ 4020.610802] R10: ffff8803f78a2200 R11: 00000084f04c73c1 R12: 0000000000000000
[ 4020.618754] R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000
[ 4020.626705] FS:  00007fec1bfd1700(0000) GS:ffff8803ffd20000(0000) knlGS:0000000000000000 
[ 4020.635722] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4020.642123] CR2: 0000000000000080 CR3: 00000003f5704000 CR4: 00000000000006e0
[ 4020.650074] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4020.658026] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4020.665976] Process reboot (pid: 13489, threadinfo ffff88047cdb0000, task ffff88047a2058e0)
[ 4020.675282] Stack:
aster Resource Control: runlevel 6 has been                         reached
[ 4020.677520]  ffff88047cdb1c68
ffffffff8109172d ffff8803f6b50b80 ffff8803f6b50b80                                                         
INIT: no more processes left in this runlevel
[ 4020.685807]  0000000000000065 ffff8803f6b50b40             ffff88047cdb1c98 ffffffff8101cd32
[ 4020.694093]  ffff88047cdb1ca8 ffff8803f6b50b80 0000000000000065 0000000000000292
[ 4020.702379] Call Trace:
[ 4020.705109]  [<ffffffff8109172d>] ? irq_modify_status+0x55/0x5e 
[ 4020.711709]  [<ffffffff8101cd32>] destroy_irq+0x41/0x7e        
[ 4020.717534]  [<ffffffff81031fe2>] uv_teardown_irq+0xb6/0xc1  
[ 4020.723743]  [<ffffffff81090f92>] ? free_irq+0x50/0x59                                                  
[ 4020.729470]  [<ffffffff812e0da3>] ? xp_restrict_memprotect_uv+0x0/0x30
[ 4020.736744]  [<ffffffff812e3a12>] xpc_destroy_gru_mq_uv+0x54/0x98 
[ 4020.743533]  [<ffffffff812e3a66>] xpc_exit_uv+0x10/0x1e 
[ 4020.749355]  [<ffffffff812e1299>] xpc_do_exit+0x1e3/0x1f2
[ 4020.755371]  [<ffffffff812e12d3>] xpc_system_reboot+0x2b/0x2f
[ 4020.761778]  [<ffffffff815c0b19>] notifier_call_chain+0x33/0x5b
[ 4020.768378]  [<ffffffff810612a4>] __blocking_notifier_call_chain+0x4d/0x6a 
[ 4020.776038]  [<ffffffff810612d0>] blocking_notifier_call_chain+0xf/0x11   
[ 4020.783411]  [<ffffffff81055c1e>] kernel_restart_prepare+0x18/0x2e       
[ 4020.790289]  [<ffffffff81055c6d>] kernel_restart+0x11/0x43              
[ 4020.796401]  [<ffffffff81055de5>] sys_reboot+0x139/0x174               
[ 4020.802322]  [<ffffffff810ef23b>] ? fput+0x20d/0x21c                  
[ 4020.807853]  [<ffffffff810ec3a0>] ? filp_close+0x67/0x72             
[ 4020.813772]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b    
[ 4020.820464] Code: c3 0f 84 b4 00 00 00 48 c7 c7 d4 d8 e5 81 45 31 e4 e8 95 2e 3a 00 66 83 7b 0a 00 49 89
c5 75 75 48 8b 33 0f b7 7b 08 0f b6 4b 0c <48> 8b 86 80 00 00 00 48 89 fa 48 c1 e2 04 48 03 10 b8 01 00 00
[ 4020.842190] RIP  [<ffffffff8121a791>] free_irte+0x46/0xe4
[ 4020.848217]  RSP <ffff88047cdb1c38>
[ 4020.852101] CR2: 0000000000000080 
[ 4021.091896] ---[ end trace 113a8c342207f0d1 ]---
/etc/init.d/rc: line 317: 13489 Killed                  $link start      
----------------------------------------------------------------------------


Output from on the simulator:
----------------------------------------------------------------------------
[    0.205968] xpc : can't setup our reserved page

Breakpoint reached at <0xffffffff811fdeb8> on cpu 0

All cpus stopped because one or more cpus hit breakpoint(s); the "stat"
cmd will show which cpu(s) hit breakpoints and which were still running.
 <199934998>  <bust_spinlocks>  55                      push    %rbp
mdb:/> lastct 100
199933847: ret  <__phys_addr+0x33> -> <virt_to_head_page+0x9>
199933857: ret  <virt_to_head_page+0x2f> -> <kfree+0x4d>
199933885: ret  <kfree+0xb3> -> <pde_put+0x68>
199933889: ret  <pde_put+0x6c> -> <remove_proc_entry+0x230>
199933897: ret  <remove_proc_entry+0x23e> -> <unregister_handler_proc+0x2c>
199933901: ret  <unregister_handler_proc+0x30> -> <__free_irq+0x134>
199933903: call <__free_irq+0x137> -> <synchronize_irq>
199933910: call <synchronize_irq+0xd> -> <irq_to_desc>
199933915: call <irq_to_desc+0xd> -> <radix_tree_lookup>
199933943: ret  <radix_tree_lookup+0x5a> -> <irq_to_desc+0x12>
199933945: ret  <irq_to_desc+0x13> -> <synchronize_irq+0x12>
199933953: call <synchronize_irq+0x30> -> <_raw_spin_lock_irqsave>
199933966: ret  <_raw_spin_lock_irqsave+0x22> -> <synchronize_irq+0x35>
199933970: call <synchronize_irq+0x40> -> <_raw_spin_unlock_irqrestore>
199933977: ret  <_raw_spin_unlock_irqrestore+0xa> -> <synchronize_irq+0x45>
199933990: ret  <synchronize_irq+0xd4> -> <__free_irq+0x13c>
199934002: ret  <__free_irq+0x178> -> <free_irq+0x40>
199934004: call <free_irq+0x43> -> <kfree>
199934018: call <kfree+0x48> -> <virt_to_head_page>
199934021: call <virt_to_head_page+0x4> -> <__phys_addr>
199934030: ret  <__phys_addr+0x33> -> <virt_to_head_page+0x9>
199934040: ret  <virt_to_head_page+0x2f> -> <kfree+0x4d>
199934068: ret  <kfree+0xb3> -> <free_irq+0x48>
199934070: call <free_irq+0x4b> -> <chip_bus_sync_unlock>
199934078: ret  <chip_bus_sync_unlock+0x17> -> <free_irq+0x50>
199934084: ret  <free_irq+0x58> -> <xpc_destroy_gru_mq_uv+0x4a>
199934086: call <xpc_destroy_gru_mq_uv+0x4f> -> <uv_teardown_irq>
199934095: call <uv_teardown_irq+0x17> -> <_raw_spin_lock_irqsave>
199934108: ret  <_raw_spin_lock_irqsave+0x22> -> <uv_teardown_irq+0x1c>
199934148: call <uv_teardown_irq+0x7c> -> <rb_erase>
199934180: ret  <rb_erase+0x27f> -> <uv_teardown_irq+0x81>
199934182: call <uv_teardown_irq+0x84> -> <kfree>
199934196: call <kfree+0x48> -> <virt_to_head_page>
199934199: call <virt_to_head_page+0x4> -> <__phys_addr>
199934208: ret  <__phys_addr+0x33> -> <virt_to_head_page+0x9>
199934218: ret  <virt_to_head_page+0x2f> -> <kfree+0x4d>
199934246: ret  <kfree+0xb3> -> <uv_teardown_irq+0x89>
199934250: call <uv_teardown_irq+0xa9> -> <_raw_spin_unlock_irqrestore>
199934257: ret  <_raw_spin_unlock_irqrestore+0xa> -> <uv_teardown_irq+0xae>
199934259: call <uv_teardown_irq+0xb1> -> <destroy_irq>
199934268: call <destroy_irq+0x13> -> <irq_get_irq_data>
199934271: call <irq_get_irq_data+0x4> -> <irq_to_desc>
199934276: call <irq_to_desc+0xd> -> <radix_tree_lookup>
199934304: ret  <radix_tree_lookup+0x5a> -> <irq_to_desc+0x12>
199934306: ret  <irq_to_desc+0x13> -> <irq_get_irq_data+0x9>
199934308: ret  <irq_get_irq_data+0xa> -> <destroy_irq+0x18>
199934315: call <destroy_irq+0x2b> -> <irq_modify_status>
199934324: call <irq_modify_status+0x11> -> <irq_to_desc>
199934329: call <irq_to_desc+0xd> -> <radix_tree_lookup>
199934357: ret  <radix_tree_lookup+0x5a> -> <irq_to_desc+0x12>
199934359: ret  <irq_to_desc+0x13> -> <irq_modify_status+0x16>
199934367: call <irq_modify_status+0x33> -> <_raw_spin_lock_irqsave>
199934380: ret  <_raw_spin_lock_irqsave+0x22> -> <irq_modify_status+0x38>
199934388: call <irq_modify_status+0x50> -> <_raw_spin_unlock_irqrestore>
199934395: ret  <_raw_spin_unlock_irqrestore+0xa> -> <irq_modify_status+0x55>
199934401: ret  <irq_modify_status+0x5d> -> <destroy_irq+0x30>
199934405: call <destroy_irq+0x3c> -> <free_irte>
199934413: call <free_irte+0x11> -> <irq_2_iommu>
199934416: call <irq_2_iommu+0x4> -> <irq_get_irq_data>
199934419: call <irq_get_irq_data+0x4> -> <irq_to_desc>
199934424: call <irq_to_desc+0xd> -> <radix_tree_lookup>
199934452: ret  <radix_tree_lookup+0x5a> -> <irq_to_desc+0x12>
199934454: ret  <irq_to_desc+0x13> -> <irq_get_irq_data+0x9>
199934456: ret  <irq_get_irq_data+0xa> -> <irq_2_iommu+0x9>
199934464: ret  <irq_2_iommu+0x20> -> <free_irte+0x16>
199934470: call <free_irte+0x2c> -> <_raw_spin_lock_irqsave>
199934483: ret  <_raw_spin_lock_irqsave+0x22> -> <free_irte+0x31>
199934490: int  <free_irte+0x46> -> <page_fault>
199934492: call <page_fault+0x4> -> <error_entry>

----------------------------------------------------------------------------

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
