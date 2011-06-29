Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1F2AsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:48:00 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49675 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1F2Arx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:47:53 -0400
From: greearb@candelatech.com
To: penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: =?UTF-8?q?=5BPATCH=20v2=200/2=5D=20=20SLUB=20memory=20debugging=20improvements=2E?=
Date: Tue, 28 Jun 2011 17:47:40 -0700
Message-Id: <1309308462-20124-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

The idea is to grab a useful sized stack trace for creation/deletion
points instead of just a single method.

A second patch adds a command to check if memory should be
in use.  This logic could be placed in a location that is
suspected of accessing freed data.

Example output from debugging some funky nfs/rpc behaviour:

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
 Redzone 0xffff8800be783118:  bb bb bb bb bb bb bb bb                         �������������
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

Ben Greear (2):
  slub: Enable backtrace for create/delete points.
  slub:  Add method to verify memory is not freed.

 include/linux/slab.h |   13 ++++++++
 mm/slub.c            |   80 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 86 insertions(+), 7 deletions(-)

-- 
1.7.3.4

