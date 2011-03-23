Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1CWUGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab1CWUGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:06:37 -0400
Date: Wed, 23 Mar 2011 16:06:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH v2 0/8] Provide cgroup isolation for buffered
 writes.
Message-ID: <20110323200621.GJ13315@redhat.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
 <20110323012755.GA10325@redhat.com>
 <AANLkTi=YyY0dCVP+JAJsyiYYqWMwf1XBROf_h_eG0yEL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=YyY0dCVP+JAJsyiYYqWMwf1XBROf_h_eG0yEL@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:27:47AM -0700, Justin TerAvest wrote:
> On Tue, Mar 22, 2011 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Mar 22, 2011 at 04:08:47PM -0700, Justin TerAvest wrote:
> >
> > [..]
> >> ===================================== Isolation experiment results
> >>
> >> For isolation testing, we run a test that's available at:
> >>   git://google3-2.osuosl.org/tests/blkcgroup.git
> >>
> >> It creates containers, runs workloads, and checks to see how well we meet
> >> isolation targets. For the purposes of this patchset, I only ran
> >> tests among buffered writers.
> >>
> >> Before patches
> >> ==============
> >> 10:32:06 INFO experiment 0 achieved DTFs: 666, 333
> >> 10:32:06 INFO experiment 0 FAILED: max observed error is 167, allowed is 150
> >> 10:32:51 INFO experiment 1 achieved DTFs: 647, 352
> >> 10:32:51 INFO experiment 1 FAILED: max observed error is 253, allowed is 150
> >> 10:33:35 INFO experiment 2 achieved DTFs: 298, 701
> >> 10:33:35 INFO experiment 2 FAILED: max observed error is 199, allowed is 150
> >> 10:34:19 INFO experiment 3 achieved DTFs: 445, 277, 277
> >> 10:34:19 INFO experiment 3 FAILED: max observed error is 155, allowed is 150
> >> 10:35:05 INFO experiment 4 achieved DTFs: 418, 104, 261, 215
> >> 10:35:05 INFO experiment 4 FAILED: max observed error is 232, allowed is 150
> >> 10:35:53 INFO experiment 5 achieved DTFs: 213, 136, 68, 102, 170, 136, 170
> >> 10:35:53 INFO experiment 5 PASSED: max observed error is 73, allowed is 150
> >> 10:36:04 INFO -----ran 6 experiments, 1 passed, 5 failed
> >>
> >> After patches
> >> =============
> >> 11:05:22 INFO experiment 0 achieved DTFs: 501, 498
> >> 11:05:22 INFO experiment 0 PASSED: max observed error is 2, allowed is 150
> >> 11:06:07 INFO experiment 1 achieved DTFs: 874, 125
> >> 11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150
> >> 11:06:53 INFO experiment 2 achieved DTFs: 121, 878
> >> 11:06:53 INFO experiment 2 PASSED: max observed error is 22, allowed is 150
> >> 11:07:46 INFO experiment 3 achieved DTFs: 589, 205, 204
> >> 11:07:46 INFO experiment 3 PASSED: max observed error is 11, allowed is 150
> >> 11:08:34 INFO experiment 4 achieved DTFs: 616, 109, 109, 163
> >> 11:08:34 INFO experiment 4 PASSED: max observed error is 34, allowed is 150
> >> 11:09:29 INFO experiment 5 achieved DTFs: 139, 139, 139, 139, 140, 141, 160
> >> 11:09:29 INFO experiment 5 PASSED: max observed error is 1, allowed is 150
> >> 11:09:46 INFO -----ran 6 experiments, 6 passed, 0 failed
> >>
> >> Summary
> >> =======
> >> Isolation between buffered writers is clearly better with this patch.
> >
> > Can you pleae explain what is this test doing. All I am seeing is passed
> > and failed and really don't understand what the test is doing.
> 
> I should have brought in more context; I was trying to keep the email
> from becoming so long that nobody would read it.
> 
> We create cgroups, and set blkio.weight_device in the cgroups so that
> they are assigned different weights for a given device. To give a
> concrete example, in this case:
> 11:05:23 INFO ----- Running experiment 1: 900 wrseq.buf*2, 100 wrseq.buf*2
> 11:06:07 INFO experiment 1 achieved DTFs: 874, 125
> 11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150
> 
> We create two cgroups, one with weight 900 for device, the other with
> weight 100.
> Then in each cgroup we run "/bin/dd if=/dev/zero of=$outputfile bs=64K ...".
> 
> After those complete, we measure blkio.time, and compare their ratios
> to all of to all of the time taken, to see how closely the time
> reported in the cgroup matches the requested weight for the device.
> 
> For simplicity, we only did dd WRITER tasks in the testing, though
> isolation is also improved when we have a writer and a reader in
> separate containers.
> 
> >
> > Can you run say simple 4 dd buffered writers in 4 cgroups with weights
> > 100, 200, 300 and 400 and see if you get better isolation.
> 
> Absolutely. :) This is pretty close to what I ran above, I should have
> just provided a better description.
> 
> Baseline (Jens' tree):
> 08:43:02 INFO ----- Running experiment 0: 100 wrseq.buf, 200
> wrseq.buf, 300 wrseq.buf, 400 wrseq.buf
> 08:43:46 INFO experiment 0 achieved DTFs: 144, 192, 463, 198
> 08:43:46 INFO experiment 0 FAILED: max observed error is 202, allowed is 150
> 08:43:50 INFO -----ran 1 experiments, 0 passed, 1 failed
> 
> 
> With patches:
> 08:36:08 INFO ----- Running experiment 0: 100 wrseq.buf, 200
> wrseq.buf, 300 wrseq.buf, 400 wrseq.buf
> 08:36:55 INFO experiment 0 achieved DTFs: 113, 211, 289, 385
> 08:36:55 INFO experiment 0 PASSED: max observed error is 15, allowed is 150
> 08:36:56 INFO -----ran 1 experiments, 1 passed, 0 failed
> 

Is it possible to actually paste blkio.time and blkio.sectors numbers for
all the 4 cgroups.

> >
> > Secondly can you also please explain that how does it work. Without
> > making writeback cgroup aware, there are no gurantees that higher
> > weight cgroup will get more IO done.
> 
> It is dependent on writeback sending enough requests to the I/O
> scheduler that touch multiple groups so that they can be scheduled
> properly. We are not guaranteed that writeback will appropriately
> choose pages from different cgroups, you are correct.
> 
> However, from experiments, we can see that writeback can send enough
> I/O to the scheduler (and from enough cgroups) to allow us to get
> isolation between cgroups for writes. As writeback more predictably
> can pick I/Os from multiple cgroups to issue, I would expect this to
> improve.

Ok, In the past I had tried it with 2 cgroups (running dd inside these
cgroups) and I had no success. I am wondering what has changed.

In the past a high priority throttled process can very well try to
pick up a inode from low prio cgroup and start writting it and get
blocked. I believe similar thing should happen now. 

Also, with IO-less throttling the situation will become worse. Right
now a throttled process tries to do IO in its own context but with
IO less throttling everything will be through flusher threads and
completions will be equally divided among throttled processes. So 
it might happen that high weight process is not woken up enough to
do more IO and no service differentiation. So I suspect that after
IO less throttling goes in, situation might become worse until and
unless we make writeback aware of cgroups.

Anyway, I tried booting with your patches applied and it crashes.

Thanks
Vivek

mdadm: ARRAY line /dev/md0 has no identity information.
Setting up Logical Volume Management:   3 logical volume(s) in volume group "vg_chilli" now active
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext4 (1) -- /] fsck.ext4 -a /dev/mapper/vg_chilli-lv_root 
/dev/mapper/vg_chilli-lv_root: clean, 367720/2313808 files, 5932252/9252864 blocks
[/sbin/fsck.[   10.531127] BUG: unable to handle kernel ext4 (1) -- /booNULL pointer dereferencet] fsck.ext4 -a  at 000000000000001f
/dev/sda1 
[/sb[   10.534662] IP:in/fsck.ext4 (2) [<ffffffff8123e67e>] cfq_put_request+0x40/0x83
[   10.534662] PGD 135191067  -- /mnt/ssd-intPUD 135dad067 el] fsck.ext4 -aPMD 0  /dev/sdb 
/dev
[   10.534662] Oops: 0000 [#1] /sdb: clean, 507SMP 918/4890624 file
s, 10566022/1953[   10.534662] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/block/sdb/dev
[   10.534662] CPU 3 7686 blocks

[   10.534662] Modules linked in: floppy [last unloaded: scsi_wait_scan]
[   10.534662] 
[   10.534662] Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc6-justin-cfq-io-tracking+ #38 Hewlett-Packard HP xw6600 Workstation/0A9Ch
[   10.534662] RIP: 0010:[<ffffffff8123e67e>]  [<ffffffff8123e67e>] cfq_put_request+0x40/0x83
[   10.534662] RSP: 0018:ffff8800bfcc3c10  EFLAGS: 00010086
[   10.534662] RAX: 0000000000000007 RBX: ffff880135a7b4a0 RCX: 0000000000000001
[   10.534662] RDX: 00000000ffff8800 RSI: ffff880135a7b4a0 RDI: ffff880135a7b4a0
[   10.534662] RBP: ffff8800bfcc3c20 R08: 0000000000000000 R09: 0000000000000000
[   10.534662] R10: ffffffff81a19400 R11: 0000000000000001 R12: ffff880135a7b540
[   10.534662] R13: 0000000000020000 R14: 0000000000000011 R15: 0000000000000001
[   10.534662] FS:  0000000000000000(0000) GS:ffff8800bfcc0000(0000) knlGS:0000000000000000
[   10.534662] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   10.534662] CR2: 000000000000001f CR3: 000000013613b000 CR4: 00000000000006e0
[   10.534662] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   10.534662] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   10.534662] Process kworker/0:1 (pid: 0, threadinfo ffff880137756000, task ffff8801377441c0)
[   10.534662] Stack:
[   10.534662]  ffff880135a7b4a0 ffff880135168000 ffff8800bfcc3c30 ffffffff81229617
[   10.534662]  ffff8800bfcc3c60 ffffffff8122f22d ffff880135a7b4a0 0000000000000000
[   10.534662]  ffff880135757048 0000000000000001 ffff8800bfcc3ca0 ffffffff8122f45b
[   10.534662] Call Trace:
[   10.534662]  <IRQ> 
[   10.534662]  [<ffffffff81229617>] elv_put_request+0x1e/0x20
[   10.534662]  [<ffffffff8122f22d>] __blk_put_request+0xea/0x103
[   10.534662]  [<ffffffff8122f45b>] blk_finish_request+0x215/0x222
[   10.534662]  [<ffffffff8122f4a8>] __blk_end_request_all+0x40/0x49
[   10.534662]  [<ffffffff81231ec6>] blk_flush_complete_seq+0x18b/0x256
[   10.534662]  [<ffffffff81232132>] flush_end_io+0xad/0xeb
[   10.534662]  [<ffffffff8122f438>] blk_finish_request+0x1f2/0x222
[   10.534662]  [<ffffffff8122f74a>] blk_end_bidi_request+0x42/0x5d
[   10.534662]  [<ffffffff8122f7a1>] blk_end_request+0x10/0x12
[   10.534662]  [<ffffffff8134292c>] scsi_io_completion+0x182/0x3f6
[   10.534662]  [<ffffffff8133c80b>] scsi_finish_command+0xb5/0xbe
[   10.534662]  [<ffffffff81342c97>] scsi_softirq_done+0xe2/0xeb
[   10.534662]  [<ffffffff81233ea2>] blk_done_softirq+0x72/0x82
[   10.534662]  [<ffffffff81045544>] __do_softirq+0xde/0x1c7
[   10.534662]  [<ffffffff81003a0c>] call_softirq+0x1c/0x28
[   10.534662]  [<ffffffff81004ec1>] do_softirq+0x3d/0x85
[   10.534662]  [<ffffffff810452bd>] irq_exit+0x4a/0x8c
[   10.534662]  [<ffffffff815ed1a5>] do_IRQ+0x9d/0xb4
[   10.534662]  [<ffffffff815e6d53>] ret_from_intr+0x0/0x13
[   10.534662]  <EOI> 
[   10.534662]  [<ffffffff8100a494>] ? mwait_idle+0xac/0xdd
[   10.534662]  [<ffffffff8100a48b>] ? mwait_idle+0xa3/0xdd
[   10.534662]  [<ffffffff81001ceb>] cpu_idle+0x64/0x9b
[   10.534662]  [<ffffffff815e023e>] start_secondary+0x173/0x177
[   10.534662] Code: fb 4d 85 e4 74 63 8b 47 40 83 e0 01 48 83 c0 18 41 8b 54 84 08 85 d2 75 04 0f 0b eb fe ff ca 41 89 54 84 08 48 8b 87 98 00 00 00 <48> 8b 78 18 e8 30 45 ff ff 48 8b bb a8 00 00 00 48 c7 83 98 00 
[   10.534662] RIP  [<ffffffff8123e67e>] cfq_put_request+0x40/0x83
[   10.534662]  RSP <ffff8800bfcc3c10>
[   10.534662] CR2: 000000000000001f
[   10.534662] ---[ end trace 9b1d20dc7519f482 ]---
[   10.534662] Kernel panic - not syncing: Fatal exception in interrupt
[   10.534662] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.38-rc6-justin-cfq-io-tracking+ #38
[   10.534662] Call Trace:
[   10.534662]  <IRQ>  [<ffffffff815e3c5f>] ? panic+0x91/0x199
[   10.534662]  [<ffffffff8103f753>] ? kmsg_dump+0x106/0x12d
[   10.534662]  [<ffffffff815e7bcb>] ? oops_end+0xae/0xbe
[   10.534662]  [<ffffffff81027b2b>] ? no_context+0x1fc/0x20b
[   10.534662]  [<ffffffff81027ccf>] ? __bad_area_nosemaphore+0x195/0x1b8
[   10.534662]  [<ffffffff8100de02>] ? save_stack_trace+0x2d/0x4a
[   10.534662]  [<ffffffff81027d05>] ? bad_area_nosemaphore+0x13/0x15
[   10.534662]  [<ffffffff815e9b74>] ? do_page_fault+0x1b9/0x38c
[   10.534662]  [<ffffffff8106a055>] ? trace_hardirqs_off+0xd/0xf
[   10.534662]  [<ffffffff8106b436>] ? mark_lock+0x2d/0x22c
[   10.534662]  [<ffffffff815e610b>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   10.534662]  [<ffffffff815e6fef>] ? page_fault+0x1f/0x30
[   10.534662]  [<ffffffff8123e67e>] ? cfq_put_request+0x40/0x83
[   10.534662]  [<ffffffff81229617>] ? elv_put_request+0x1e/0x20
[   10.534662]  [<ffffffff8122f22d>] ? __blk_put_request+0xea/0x103
[   10.534662]  [<ffffffff8122f45b>] ? blk_finish_request+0x215/0x222
[   10.534662]  [<ffffffff8122f4a8>] ? __blk_end_request_all+0x40/0x49
[   10.534662]  [<ffffffff81231ec6>] ? blk_flush_complete_seq+0x18b/0x256
[   10.534662]  [<ffffffff81232132>] ? flush_end_io+0xad/0xeb
[   10.534662]  [<ffffffff8122f438>] ? blk_finish_request+0x1f2/0x222
[   10.534662]  [<ffffffff8122f74a>] ? blk_end_bidi_request+0x42/0x5d
[   10.534662]  [<ffffffff8122f7a1>] ? blk_end_request+0x10/0x12
[   10.534662]  [<ffffffff8134292c>] ? scsi_io_completion+0x182/0x3f6
[   10.534662]  [<ffffffff8133c80b>] ? scsi_finish_command+0xb5/0xbe
[   10.534662]  [<ffffffff81342c97>] ? scsi_softirq_done+0xe2/0xeb
[   10.534662]  [<ffffffff81233ea2>] ? blk_done_softirq+0x72/0x82
[   10.534662]  [<ffffffff81045544>] ? __do_softirq+0xde/0x1c7
[   10.534662]  [<ffffffff81003a0c>] ? call_softirq+0x1c/0x28
[   10.534662]  [<ffffffff81004ec1>] ? do_softirq+0x3d/0x85
[   10.534662]  [<ffffffff810452bd>] ? irq_exit+0x4a/0x8c
[   10.534662]  [<ffffffff815ed1a5>] ? do_IRQ+0x9d/0xb4
[   10.534662]  [<ffffffff815e6d53>] ? ret_from_intr+0x0/0x13
[   10.534662]  <EOI>  [<ffffffff8100a494>] ? mwait_idle+0xac/0xdd
[   10.534662]  [<ffffffff8100a48b>] ? mwait_idle+0xa3/0xdd
[   10.534662]  [<ffffffff81001ceb>] ? cpu_idle+0x64/0x9b
[   10.534662]  [<ffffffff815e023e>] ? start_secondary+0x173/0x177

