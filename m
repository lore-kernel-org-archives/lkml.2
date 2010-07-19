Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771Ab0GSPDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:03:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61567 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935221Ab0GSPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:03:50 -0400
Date: Mon, 19 Jul 2010 11:02:16 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: 2.6.35 Regression/oops from virtio: return ENOMEM on out of memory
 patch
Message-ID: <20100719150216.GC8623@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	"Michael S. Tsirkin" <mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C446945.007C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=686d363786a53ed28ee875b84ef24e6d5126ef6f

I've been having problems with my long running stress runs and tracked
it down to the above commit.  Under load I get a couple of GFP_ATOMIC
allocation failures from virtio per day (not really surprising), and in
the past it would carry on happily.

Now I get the atomic allocation failure followed by this:

BUG: unable to handle kernel paging request at ffff88087c37e458
IP: [<ffffffff812e3752>] virtqueue_add_buf_gfp+0x305/0x353

(Full oops below).

Looking at virtqueue_add_buf_gfp, it does:

        /* If the host supports indirect descriptor tables, and we have multiple 
         * buffers, then go indirect. FIXME: tune this threshold */
        if (vq->indirect && (out + in) > 1 && vq->num_free) {
                head = vring_add_indirect(vq, sg, out, in, gfp);
                if (head != vq->vring.num)
                        goto add_head;
        }
[ ... ]

add_head:
        /* Set token. */
        vq->data[head] = data;

Since vring_add_indirect is returning -ENOMEM, head is -ENOMEM and things
go bad pretty quickly.  Full oops below, afraid I don't know the virtio
code well enough to provide the clean and obvious fix (outside of
reverting) at this late rc.

BUG: unable to handle kernel paging request at ffff88087c37e458
IP: [<ffffffff812e3752>] virtqueue_add_buf_gfp+0x305/0x353
PGD 1916063 PUD 0
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/bdi/btrfs-2/uevent
CPU 1
Modules linked in: btrfs

Pid: 273, comm: kblockd/1 Not tainted 2.6.35-rc4-josef+ #137 /
RIP: 0010:[<ffffffff812e3752>]  [<ffffffff812e3752>] virtqueue_add_buf_gfp+0x305/0x353
RSP: 0018:ffff88007c22bce0  EFLAGS: 00010046
RAX: 00000000fffffff4 RBX: ffff88007c37e448 RCX: 00000000fffffff4
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007c804100
RBP: ffff88007c22bd40 R08: ffff88007c804100 R09: ffff88007c22b810
R10: ffffffff81afccb8 R11: ffff88007c22bbc0 R12: 0000000000000050
R13: ffff88007b790050 R14: 0000000000000001 R15: ffff88000acb5878
FS:  0000000000000000(0000) GS:ffff880001c20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88087c37e458 CR3: 000000002a3c8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kblockd/1 (pid: 273, threadinfo ffff88007c22a000, task ffff88007c228690)
Stack:
 ffff880000000001 6db6db6db6db6db7 ffff88005a79fec8 ffff880000000051
<0> ffff88007b6c23b0 0000000038f19000 ffff880060463a48 ffff88000acb5878
<0> ffff88007b790000 ffff880058ae58e8 0000000000000050 ffffea0000000000
Call Trace:
 [<ffffffff8133dc6c>] do_virtblk_request+0x328/0x398
 [<ffffffff8124e64e>] __blk_run_queue+0x87/0x146
 [<ffffffff8125a510>] cfq_kick_queue+0x2f/0x40
 [<ffffffff810826ae>] worker_thread+0x1e9/0x293
 [<ffffffff8125a4e1>] ? cfq_kick_queue+0x0/0x40
 [<ffffffff810865f2>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff810824c5>] ? worker_thread+0x0/0x293
 [<ffffffff8108614d>] kthread+0x7f/0x87
 [<ffffffff810308d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810860ce>] ? kthread+0x0/0x87
 [<ffffffff810308d0>] ? kernel_thread_helper+0x0/0x10
Code: 32 08 49 83 c5 20 48 8b 53 38 0f b7 44 32 0e 45 85 f6 75 a4 8b 55 cc 48 c1 e2 04 48 03 53 38 66 83 62 0c fe 89 
43 58 89 c8 31 d2 <4c> 89 7c c3 70 8b 7b 5c 48 8b 73 40 0f b7 46 02 01 f8 ff c7 f7
RIP  [<ffffffff812e3752>] virtqueue_add_buf_gfp+0x305/0x353
 RSP <ffff88007c22bce0>
CR2: ffff88087c37e458
---[ end trace 6e26765f80efcb76 ]---

