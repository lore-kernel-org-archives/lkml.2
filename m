Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab1I3S54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:57:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34939 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1I3S5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:57:54 -0400
MIME-Version: 1.0
In-Reply-To: <6261.1317385734@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
Date: Fri, 30 Sep 2011 11:57:53 -0700
Message-ID: <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 5:28 AM, David Howells <dhowells@redhat.com> wrote:
>
> You'll probably need to add the attached patch also.  Turns out there were
> some bits I'd missed.
>
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] CacheFiles: Add missing retrieval completions
>
> CacheFiles is missing some calls to fscache_retrieval_complete() in the error
> handling/collision paths of its reader functions.
>
> This can be seen by the following assertion tripping in fscache_put_operation()
> whereby the operation being destroyed is still in the in-progress state and has
> not been cancelled or completed:
>
> FS-Cache: Assertion failed
> 3 == 5 is false
> ------------[ cut here ]------------
> kernel BUG at fs/fscache/operation.c:408!
> invalid opcode: 0000 [#1] SMP
> CPU 2
> Modules linked in: xfs ioatdma dca loop joydev evdev
> psmouse dcdbas pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
> pci_hotplug sg sr_mod]
>
> Pid: 8062, comm: httpd Not tainted 3.1.0-rc8 #1 Dell Inc. PowerEdge 1950/0DT097
> RIP: 0010:[<ffffffff81197b24>]  [<ffffffff81197b24>] fscache_put_operation+0x304/0x330
> RSP: 0018:ffff880062f739d8  EFLAGS: 00010296
> RAX: 0000000000000025 RBX: ffff8800c5122e84 RCX: ffffffff81ddf040
> RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81ddef30
> RBP: ffff880062f739f8 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000003 R12: ffff8800c5122e40
> R13: ffff880037a2cd20 R14: ffff880087c7a058 R15: ffff880087c7a000
> FS:  00007f63dcf636e0(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0c0a91f000 CR3: 0000000062ec2000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process httpd (pid: 8062, threadinfo ffff880062f72000, task ffff880087e58000)
> Stack:
>  ffff880062f73bf8 0000000000000000 ffff880062f73bf8 ffff880037a2cd20
>  ffff880062f73a68 ffffffff8119aa7e ffff88006540e000 ffff880062f73ad4
>  ffff88008e9a4308 ffff880037a2cd20 ffff880062f73a48 ffff8800c5122e40
> Call Trace:
>  [<ffffffff8119aa7e>] __fscache_read_or_alloc_pages+0x1fe/0x530
>  [<ffffffff81250780>] __nfs_readpages_from_fscache+0x70/0x1c0
>  [<ffffffff8123142a>] nfs_readpages+0xca/0x1e0
>  [<ffffffff815f3c06>] ? rpc_do_put_task+0x36/0x50
>  [<ffffffff8122755b>] ? alloc_nfs_open_context+0x4b/0x110
>  [<ffffffff815ecd1a>] ? rpc_call_sync+0x5a/0x70
>  [<ffffffff810e7e9a>] __do_page_cache_readahead+0x1ca/0x270
>  [<ffffffff810e7f61>] ra_submit+0x21/0x30
>  [<ffffffff810e818d>] ondemand_readahead+0x11d/0x250
>  [<ffffffff810e83b6>] page_cache_sync_readahead+0x36/0x60
>  [<ffffffff810dffa4>] generic_file_aio_read+0x454/0x770
>  [<ffffffff81224ce1>] nfs_file_read+0xe1/0x130
>  [<ffffffff81121bd9>] do_sync_read+0xd9/0x120
>  [<ffffffff8114088f>] ? mntput+0x1f/0x40
>  [<ffffffff811238cb>] ? fput+0x1cb/0x260
>  [<ffffffff81122938>] vfs_read+0xc8/0x180
>  [<ffffffff81122af5>] sys_read+0x55/0x90
>
> Reported-by: Mark Moseley <moseleymark@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/cachefiles/rdwr.c |   14 ++++++++++----
>  fs/fscache/page.c    |    2 ++
>  2 files changed, 12 insertions(+), 4 deletions(-)
>
>
> diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c


Ok, with that patch, I get this in the logs:


[ 6052.503856] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504366] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504376] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504380] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504384] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504388] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504391] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504395] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.504398] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
...
<several pages of this>
...
[ 6052.512921] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.512926] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.512930] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.641682] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.645533] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 6052.645914] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]
[ 7719.996876]
[ 7719.996883] FS-Cache: Assertion failed
[ 7719.996886] 3 == 5 is false
[ 7719.996906] ------------[ cut here ]------------
[ 7720.006139] kernel BUG at fs/fscache/operation.c:408!
[ 7720.006751] invalid opcode: 0000 [#1] SMP
[ 7720.006751] CPU 7


Console, I got this (gets a little jumbled at the end):

[ 7719.996906] ------------[ cut here ]------------
[ 7720.006139] kernel BUG at fs/fscache/operation.c:408!
[ 7720.006751] invalid opcode: 0000 [#1] SMP
[ 7720.006751] CPU 7
[ 7720.006751] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse dcdbas serio_raw pcspkr i5000_edac edac_core i5k_amb shpchp
pci_hotplug sg sr_mod]
[ 7720.060050]
[ 7720.060050] Pid: 21299, comm: kworker/u:2 Not tainted 3.1.0-rc8 #1
Dell Inc. PowerEdge 1950/0DT097
[ 7720.060050] RIP: 0010:[<ffffffff81197b24>]  [<ffffffff81197b24>]
fscache_put_operation+0x304/0x330
[ 7720.060050] RSP: 0018:ffff8800c537ddd0  EFLAGS: 00010286
[ 7720.060050] RAX: 0000000000000025 RBX: ffff8801d8e1c7c4 RCX: ffffffff81ddf040
[ 7720.060050] RDX: 00000000ffffffff RSI: 0000000000000086 RDI: ffffffff81ddef30
[ 7720.060050] RBP: ffff8800c537ddf0 R08: 0000000000000006 R09: 0000000000000000
[ 7720.060050] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8801d8e1c780
[ 7720.060050] R13: ffff8801532f5d80 R14: ffffffff81e01780 R15: ffff880226b95405
[ 7720.060050] FS:  0000000000000000(0000) GS:ffff88022fdc0000(0000)
knlGS:0000000000000000
[ 7720.060050] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7720.060050] CR2: 00007f69c48bf000 CR3: 000000010b736000 CR4: 00000000000006e0
[ 7720.060050] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7720.060050] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7720.060050] Process kworker/u:2 (pid: 21299, threadinfo
ffff8800c537c000, task ffff8801a67f8000)
[ 7720.060050] Stack:
[ 7720.060050]  ffff8801d8e1c780 ffff8801d8e1c780 ffff8801d8e1c780
ffff8801532f5d80
[ 7720.060050]  ffff8800c537de10 ffffffff81197b8b ffffffff81e01780
0000000000000000
[ 7720.060050]  ffff8800c537de60 ffffffff810660c4 0000000000000000
ffff880226b95400
[ 7720.060050] Call Trace:
[ 7720.060050]  [<ffffffff81197b8b>] fscache_op_work_func+0x3b/0xd0
[ 7720.060050]  [<ffffffff810660c4>] process_one_work+0x164/0x440
[ 7720.060050]  [<ffffffff81197b50>] ? fscache_put_operation+0x330/0x330
[ 7720.060050]  [<ffffffff8106674b>] worker_thread+0x19b/0x430
[ 7720.060050]  [<ffffffff810665b0>] ? manage_workers+0x210/0x210
[ 7720.060050]  [<ffffffff8106d11e>] kthread+0x9e/0xb0
[ 7720.060050]  [<ffffffff8162d4f4>] kernel_thread_helper+0x4/0x10
[ 7720.060050]  [<ffffffff8162ab8a>] ? retint_restore_args+0xe/0xe
[ 7720.060050]  [<ffffffff8106d080>] ? kthread_worker_fn+0x190/0x190
[ 7720.060050]  [<ffffffff8162d4f0>] ? gs_change+0xb/0xb
[ 7720.060050] Code: e8 59 fa 48 00 48 c7 c7 88 1d a1 81 31 c0 e8 4b
fa 48 00 41 8b 74 24 40 ba 05 00 00 00 48 c7 c7 0f 9c a0 81 31 c0 e8
33 fa 48 00 <0f> 0b
[ 7720.060050] RIP  [<ffffffff81197b24>] fscache_put_operation+0x304/0x330
[ 7720.060050]  RSP <ffff8800c537ddd0>
[ 7719.996906] [ 7720.512787] ---[ end trace d88afc9d74f3048c ]---
------------[ cu[ 7720.526298] Kernel panic - not syncing: Fatal exception
t here ]--------[ 7720.538799] Pid: 21299, comm: kworker/u:2 Tainted:
G      D     3.1.0-rc8 #1
----
    2011 Sep 30[ 7720.555240] Call Trace:
 14:40:56 [ 7720.562582]  [<ffffffff8162742b>] panic+0xbf/0x1eb
t2102 [ 7720.006[ 7720.575051]  [<ffffffff8104b98f>] ? kmsg_dump+0x4f/0x100
751] invalid opc[ 7720.587959]  [<ffffffff81005c08>] oops_end+0xa8/0xf0
ode: 0000 [#1] S[ 7720.600553]  [<ffffffff81005d4b>] die+0x5b/0x90
MP
   [ 7720.612527]  [<ffffffff81003386>] do_trap+0x156/0x180
[ 7720.623060]  [<ffffffff81072cea>] ? atomic_notifier_call_chain+0x1a/0x20
[ 7720.636598]  [<ffffffff81003805>] do_invalid_op+0x95/0xb0
[ 7720.647485]  [<ffffffff81197b24>] ? fscache_put_operation+0x304/0x330
[ 7720.660477]  [<ffffffff812dc58a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[ 7720.673634]  [<ffffffff8162abba>] ? restore_args+0x30/0x30
[ 7720.684682]  [<ffffffff8162d375>] invalid_op+0x15/0x20
[ 7720.695008]  [<ffffffff81197b24>] ? fscache_put_operation+0x304/0[
7720.835000] Rebooting in 120 seconds..
