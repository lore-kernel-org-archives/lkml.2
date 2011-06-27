Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1F0XUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:20:20 -0400
Received: from mail.candelatech.com ([208.74.158.172]:43775 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1F0XRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:17:18 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 0/2] SLUB memory debugging improvements.
Date: Mon, 27 Jun 2011 16:17:09 -0700
Message-Id: <1309216631-31493-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

The idea is to grab a useful sized stack trace for creation/deletion
points instead of just a single method.

A second patch adds a command to check if memory should be
in use.  This is in an attempt to track down some use-after-free
bugs I'm seeing in nfs/rpc.

However, I did not exactly hit the bug I was expecting, but got
this output instead.  I'm not sure if my debug patches are not
working right, or if this warning is just another symptom of the
problem:

=============================================================================
BUG kmalloc-64: Wrong object count. Counter is 2 but counted were 1
-----------------------------------------------------------------------------

INFO: Slab 0xffffea0001e19fd0 objects=20 used=20 fp=0x          (null) flags=0x20000000004080
Pid: 2349, comm: kworker/1:2 Not tainted 3.0.0-rc4+ #4
Call Trace:
 [<ffffffff81105484>] slab_err+0x8a/0x98
 [<ffffffff81077c0b>] ? register_lock_class+0x1e/0x336
 [<ffffffff81078c91>] ? mark_lock+0x2d/0x22d
 [<ffffffff81105783>] on_freelist+0x179/0x1ad
 [<ffffffffa0290601>] ? __rpc_execute+0x1ce/0x24b [sunrpc]
 [<ffffffff81106849>] verify_mem_not_deleted+0x5f/0xb3
 [<ffffffffa02906c0>] ? rpc_execute+0x42/0x42 [sunrpc]
 [<ffffffffa02981b5>] rpcb_getport_done+0x23/0x126 [sunrpc]
 [<ffffffffa02900ba>] rpc_exit_task+0x3f/0x6d [sunrpc]
 [<ffffffffa02904ab>] __rpc_execute+0x78/0x24b [sunrpc]
 [<ffffffffa02906c0>] ? rpc_execute+0x42/0x42 [sunrpc]
 [<ffffffffa02906d0>] rpc_async_schedule+0x10/0x12 [sunrpc]
 [<ffffffff810611b7>] process_one_work+0x230/0x41d
 [<ffffffff81061102>] ? process_one_work+0x17b/0x41d
 [<ffffffff81063613>] worker_thread+0x133/0x217
 [<ffffffff810634e0>] ? manage_workers+0x191/0x191
 [<ffffffff81066e10>] kthread+0x7d/0x85
 [<ffffffff81485924>] kernel_thread_helper+0x4/0x10
 [<ffffffff8147eb18>] ? retint_restore_args+0x13/0x13
 [<ffffffff81066d93>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff81485920>] ? gs_change+0x13/0x13
FIX kmalloc-64: Object count adjusted.
=============================================================================
BUG kmalloc-64: Wrong object count. Counter is 1 but counted were 20
-----------------------------------------------------------------------------

INFO: Slab 0xffffea0001e19fd0 objects=20 used=1 fp=0x          (null) flags=0x20000000004081
Pid: 2349, comm: kworker/1:2 Not tainted 3.0.0-rc4+ #4
Call Trace:
 [<ffffffff81105484>] slab_err+0x8a/0x98
 [<ffffffff81078c91>] ? mark_lock+0x2d/0x22d
 [<ffffffff8147e4c2>] ? _raw_spin_unlock_irqrestore+0x42/0x79
 [<ffffffff81041b91>] ? get_parent_ip+0x11/0x41
 [<ffffffff81105783>] on_freelist+0x179/0x1ad
 [<ffffffffa029889c>] ? rpcb_map_release+0x3f/0x44 [sunrpc]
 [<ffffffffa02906c0>] ? rpc_execute+0x42/0x42 [sunrpc]
 [<ffffffff81106d4b>] free_debug_processing+0x5c/0x18e
 [<ffffffffa02906c0>] ? rpc_execute+0x42/0x42 [sunrpc]
 [<ffffffff811073b0>] __slab_free+0x57/0x150
 [<ffffffffa029889c>] ? rpcb_map_release+0x3f/0x44 [sunrpc]
 [<ffffffffa029889c>] ? rpcb_map_release+0x3f/0x44 [sunrpc]
 [<ffffffff81107e9c>] kfree+0x107/0x13a
 [<ffffffffa029889c>] rpcb_map_release+0x3f/0x44 [sunrpc]
 [<ffffffffa028fa5a>] rpc_release_calldata+0x12/0x14 [sunrpc]
 [<ffffffffa028fc41>] rpc_free_task+0x59/0x61 [sunrpc]
 [<ffffffffa028fccb>] rpc_final_put_task+0x82/0x8a [sunrpc]
 [<ffffffffa029066f>] __rpc_execute+0x23c/0x24b [sunrpc]
 [<ffffffffa02906c0>] ? rpc_execute+0x42/0x42 [sunrpc]
 [<ffffffffa02906d0>] rpc_async_schedule+0x10/0x12 [sunrpc]
 [<ffffffff810611b7>] process_one_work+0x230/0x41d
 [<ffffffff81061102>] ? process_one_work+0x17b/0x41d
 [<ffffffff81063613>] worker_thread+0x133/0x217
 [<ffffffff810634e0>] ? manage_workers+0x191/0x191
 [<ffffffff81066e10>] kthread+0x7d/0x85
 [<ffffffff81485924>] kernel_thread_helper+0x4/0x10
 [<ffffffff8147eb18>] ? retint_restore_args+0x13/0x13
 [<ffffffff81066d93>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff81485920>] ? gs_change+0x13/0x13
FIX kmalloc-64: Object count adjusted.


Ben Greear (2):
  slub: Enable backtrace for create/delete points.
  slub:  Add method to verify memory is not deleted.

 include/linux/slab.h |    9 ++++++
 mm/slub.c            |   73 +++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 7 deletions(-)

-- 
1.7.3.4

