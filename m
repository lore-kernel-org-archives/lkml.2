Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1F1DrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 23:47:12 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38206 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab1F1Dpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 23:45:35 -0400
Message-ID: <4E094E56.20003@candelatech.com>
Date: Mon, 27 Jun 2011 20:45:26 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com> <4E091670.9040405@candelatech.com> <alpine.DEB.2.00.1106271718340.29910@chino.kir.corp.google.com> <4E091F2B.4060607@candelatech.com>
In-Reply-To: <4E091F2B.4060607@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 05:24 PM, Ben Greear wrote:
> On 06/27/2011 05:19 PM, David Rientjes wrote:
>> On Mon, 27 Jun 2011, Ben Greear wrote:
>>
>>> I saw a case where xprt was 0x6b6b6b6b. I'm trying to figure out
>>> what freed it.
>>
>> And echo 1> /sys/kernel/slab/<cache>/store_user doesn't help?
>
> That gives one method, right? The rpc stuff is freed at the bottom of a
> complicated callback chain, and the interesting stuff is what caused the memory
> to be freed, not the actually free method.
>
> In previous network (ath9k) hacking I had the same trouble..I think for most
> cases you need a full or mostly full stack to make use of the slub
> debug logic.

Hit my bug after a while...here's some example output with the
slub patches applied:

=============================================================================
BUG kmalloc-64: Object is on free-list
-----------------------------------------------------------------------------

INFO: Allocated in rpcb_getport_async+0x39c/0x5a5 [sunrpc] age=381 cpu=3 pid=3750
	__slab_alloc+0x348/0x3ba
	kmem_cache_alloc_trace+0x67/0xe7
	rpcb_getport_async+0x39c/0x5a5 [sunrpc]
	call_bind+0x70/0x75 [sunrpc]
	__rpc_execute+0x78/0x24b [sunrpc]
	rpc_execute+0x3d/0x42 [sunrpc]
	rpc_run_task+0x79/0x81 [sunrpc]
	rpc_call_sync+0x3f/0x60 [sunrpc]
	rpc_ping+0x42/0x58 [sunrpc]
	rpc_create+0x4aa/0x527 [sunrpc]
	nfs_create_rpc_client+0xb1/0xf6 [nfs]
	nfs_init_client+0x3b/0x7d [nfs]
	nfs_get_client+0x453/0x5ab [nfs]
	nfs_create_server+0x10b/0x437 [nfs]
	nfs_fs_mount+0x4ca/0x708 [nfs]
	mount_fs+0x6b/0x152
INFO: Freed in rpcb_map_release+0x3f/0x44 [sunrpc] age=30 cpu=2 pid=29049
	__slab_free+0x57/0x150
	kfree+0x107/0x13a
	rpcb_map_release+0x3f/0x44 [sunrpc]
	rpc_release_calldata+0x12/0x14 [sunrpc]
	rpc_free_task+0x59/0x61 [sunrpc]
	rpc_final_put_task+0x82/0x8a [sunrpc]
	__rpc_execute+0x23c/0x24b [sunrpc]
	rpc_async_schedule+0x10/0x12 [sunrpc]
	process_one_work+0x230/0x41d
	worker_thread+0x133/0x217
	kthread+0x7d/0x85
	kernel_thread_helper+0x4/0x10
INFO: Slab 0xffffea00029aa470 objects=20 used=9 fp=0xffff8800be7830d8 flags=0x20000000004081
INFO: Object 0xffff8800be7830d8 @offset=4312 fp=0xffff8800be7827a8

Bytes b4 0xffff8800be7830c8:  87 a8 96 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .�......ZZZZZZZZ
   Object 0xffff8800be7830d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xffff8800be7830e8:  6b 6b 6b 6b 01 08 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkk..kkkkkkkkkk
   Object 0xffff8800be7830f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xffff8800be783108:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
  Redzone 0xffff8800be783118:  bb bb bb bb bb bb bb bb                         ��������
  Padding 0xffff8800be783258:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
Pid: 29049, comm: kworker/2:2 Not tainted 3.0.0-rc4+ #8
Call Trace:
  [<ffffffff811055c3>] print_trailer+0x131/0x13a
  [<ffffffff81105601>] object_err+0x35/0x3e
  [<ffffffff8110746f>] verify_mem_not_deleted+0x7a/0xb7
  [<ffffffffa02851b5>] rpcb_getport_done+0x23/0x126 [sunrpc]
  [<ffffffffa027d0ba>] rpc_exit_task+0x3f/0x6d [sunrpc]
  [<ffffffffa027d4ab>] __rpc_execute+0x78/0x24b [sunrpc]
  [<ffffffffa027d6c0>] ? rpc_execute+0x42/0x42 [sunrpc]
  [<ffffffffa027d6d0>] rpc_async_schedule+0x10/0x12 [sunrpc]
  [<ffffffff810611b7>] process_one_work+0x230/0x41d
  [<ffffffff81061102>] ? process_one_work+0x17b/0x41d
  [<ffffffff81063613>] worker_thread+0x133/0x217
  [<ffffffff810634e0>] ? manage_workers+0x191/0x191
  [<ffffffff81066e10>] kthread+0x7d/0x85
  [<ffffffff81485924>] kernel_thread_helper+0x4/0x10
  [<ffffffff8147eb18>] ? retint_restore_args+0x13/0x13
  [<ffffffff81066d93>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff81485920>] ? gs_change+0x13/0x13
general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 2
Modules linked in: xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit 8021q garp ip6table_filter ip6_tables 
macvlan ebtable_nat ebtables fuse pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac edac_core iTCO_wdt e1000e iTCO_vendor_support ioatdma microcode pcspkr i2c_i801 shpchp dca floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 29049, comm: kworker/2:2 Not tainted 3.0.0-rc4+ #8 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81105eae>]  [<ffffffff81105eae>] virt_to_head_page+0x1e/0x2c
RSP: 0000:ffff8801021d3ce0  EFLAGS: 00010003
RAX: 0177e39bf7f7f7d0 RBX: ffff8800be7830d8 RCX: ffff8800be7830d8
RDX: ffffea0000000000 RSI: ffff8801021d3f58 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff8801021d3ce0 R08: ffff8800be7830d8 R09: ffff8801021d3990
R10: 0000000000000001 R11: 0000000000000078 R12: 6b6b6b6b6b6b6b6b
R13: 0000000000000202 R14: 0000000000000001 R15: ffffffffa027d6c0
FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000311421b080 CR3: 0000000001a03000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/2:2 (pid: 29049, threadinfo ffff8801021d2000, task ffff8801288ab3f0)
Stack:
  ffff8801021d3d10 ffffffff81107431 ffff8800be7830d8 0000000000000000
  ffff8800c7635d40 6b6b6b6b6b6b6b6b ffff8801021d3d40 ffffffffa02851bd
  ffff8800c7635d40 ffff8800c7635db0 0000000000000001 0000000000000000
Call Trace:
  [<ffffffff81107431>] verify_mem_not_deleted+0x3c/0xb7
  [<ffffffffa02851bd>] rpcb_getport_done+0x2b/0x126 [sunrpc]
  [<ffffffffa027d0ba>] rpc_exit_task+0x3f/0x6d [sunrpc]
  [<ffffffffa027d4ab>] __rpc_execute+0x78/0x24b [sunrpc]
  [<ffffffffa027d6c0>] ? rpc_execute+0x42/0x42 [sunrpc]
  [<ffffffffa027d6d0>] rpc_async_schedule+0x10/0x12 [sunrpc]
  [<ffffffff810611b7>] process_one_work+0x230/0x41d
  [<ffffffff81061102>] ? process_one_work+0x17b/0x41d
  [<ffffffff81063613>] worker_thread+0x133/0x217
  [<ffffffff810634e0>] ? manage_workers+0x191/0x191
  [<ffffffff81066e10>] kthread+0x7d/0x85
  [<ffffffff81485924>] kernel_thread_helper+0x4/0x10
  [<ffffffff8147eb18>] ? retint_restore_args+0x13/0x13
  [<ffffffff81066d93>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff81485920>] ? gs_change+0x13/0x13
Code: 02 00 00 3d 00 02 00 00 0f 4f c2 c9 c3 55 48 89 e5 e8 eb e9 f2 ff 48 c1 e8 0c 48 ba 00 00 00 00 00 ea ff ff 48 6b c0 38 48 01 d0
  8b 10 66 85 d2 79 04 48 8b 40 10 c9 c3 55 48 89 e5 41 57 41
RIP  [<ffffffff81105eae>] virt_to_head_page+0x1e/0x2c
  RSP <ffff8801021d3ce0>
---[ end trace 4cb7eac5b28823fd ]---

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
