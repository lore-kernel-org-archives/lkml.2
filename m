Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0IAHRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:17:32 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56021 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0IAHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:17:29 -0400
Message-ID: <4C7DFD8F.6070200@ct.jp.nec.com>
Date: Wed, 01 Sep 2010 16:15:27 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org>
In-Reply-To: <4C7BD202.4040700@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/31/2010 12:45 AM +0900, Tejun Heo wrote:
> This patch converts request-based dm to support the new REQ_FLUSH/FUA.
> 
> The original request-based flush implementation depended on
> request_queue blocking other requests while a barrier sequence is in
> progress, which is no longer true for the new REQ_FLUSH/FUA.
> 
> In general, request-based dm doesn't have infrastructure for cloning
> one source request to multiple targets, but the original flush
> implementation had a special mostly independent path which can issue
> flushes to multiple targets and sequence them.  However, the
> capability isn't currently in use and adds a lot of complexity.
> Moreoever, it's unlikely to be useful in its current form as it
> doesn't make sense to be able to send out flushes to multiple targets
> when write requests can't be.
> 
> This patch rips out special flush code path and deals handles
> REQ_FLUSH/FUA requests the same way as other requests.  The only
> special treatment is that REQ_FLUSH requests use the block address 0
> when finding target, which is enough for now.
> 
> * added BUG_ON(!dm_target_is_valid(ti)) in dm_request_fn() as
>   suggested by Mike Snitzer

Thank you for your work.

I don't see any obvious problem on this patch.
However, I hit a NULL pointer dereference below when I use a mpath
device with barrier option of ext3.  I'm investigating the cause now.
(Also I'm not sure the cause of the hang which Mike is hitting yet.)

I tried on the commit 28dd53b26d362c16234249bad61db8cbd9222d0b of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua.

    # mke2fs -j /dev/mapper/mpatha
    # mount -o barrier=1 /dev/mapper/mpatha /mnt/0
    # dd if=/dev/zero of=/mnt/0/a bs=512 count=1
    # sync

BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffffa0070ec3>] scsi_finish_command+0xa3/0x120 [scsi_mod]
PGD 29fd9a067 PUD 2a21ff067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 1 
Modules linked in: ext4 jbd2 crc16 ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables autofs4 lockd sunrpc cpufreq_ondemand acpi_cpufreq bridge stp llc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_service_time dm_multipath scsi_dh dm_mod video output sbs sbshc battery ac kvm_intel kvm e1000e sg sr_mod cdrom lpfc scsi_transport_fc piix rtc_cmos rtc_core ioatdma ata_piix button serio_raw rtc_lib libata dca megaraid_sas sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]

Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-rc2+ #1 MS-9196/Express5800/120Lj [N8100-1417]
RIP: 0010:[<ffffffffa0070ec3>]  [<ffffffffa0070ec3>] scsi_finish_command+0xa3/0x120 [scsi_mod]
RSP: 0018:ffff880002c83e50  EFLAGS: 00010297
RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000000
RDX: 0000000000007d7c RSI: ffffffff81389c55 RDI: 0000000000000286
RBP: ffff880002c83e70 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802a2acf750
R13: ffff8802a25686c8 R14: ffff8802791f7eb8 R15: 0000000000000100
FS:  0000000000000000(0000) GS:ffff880002c80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 00000002a2ab6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:0 (pid: 0, threadinfo ffff8802a4576000, task ffff8802a4574050)
Stack:
 ffff8802791f7eb8 0000000000002002 000000000000ea60 0000000000000005
<0> ffff880002c83ea0 ffffffffa0079ec8 ffff880002c83eb0 0000000000000020
<0> ffffffff815220a0 0000000000000004 ffff880002c83ed0 ffffffff811c6636
Call Trace:
 <IRQ> 
 [<ffffffffa0079ec8>] scsi_softirq_done+0x138/0x170 [scsi_mod]
 [<ffffffff811c6636>] blk_done_softirq+0x86/0xa0
 [<ffffffff81053036>] __do_softirq+0xd6/0x210
 [<ffffffff81003d9c>] call_softirq+0x1c/0x50
 [<ffffffff81005705>] do_softirq+0x95/0xd0
 [<ffffffff81052f4d>] irq_exit+0x4d/0x60
 [<ffffffff81391668>] do_IRQ+0x78/0xf0
 [<ffffffff8138a053>] ret_from_intr+0x0/0x16
 <EOI> 
 [<ffffffff8100b630>] ? mwait_idle+0x70/0xe0
 [<ffffffff8107cc8d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8100b639>] ? mwait_idle+0x79/0xe0
 [<ffffffff8100b630>] ? mwait_idle+0x70/0xe0
 [<ffffffff81001c36>] cpu_idle+0x66/0xe0
 [<ffffffff81380e81>] ? start_secondary+0x181/0x1f0
 [<ffffffff81380e8f>] start_secondary+0x18f/0x1f0
Code: 0c 83 e0 07 83 f8 04 77 6c 49 8b 86 80 00 00 00 41 8b 5e 68 83 78 44 02 74 27 48 8b 80 b0 00 00 00 48 8b 80 70 02 00 00 48 8b 00 <48> 8b 50 78 89 d8 48 85 d2 74 05 4c 89 f7 ff d2 39 c3 74 21 89 
RIP  [<ffffffffa0070ec3>] scsi_finish_command+0xa3/0x120 [scsi_mod]
 RSP <ffff880002c83e50>
CR2: 0000000000000078



Also, I have one comment below on this patch.

> @@ -2619,9 +2458,8 @@ int dm_suspend(struct mapped_device *md,
>  	up_write(&md->io_lock);
> 
>  	/*
> -	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
> -	 * can be kicked until md->queue is stopped.  So stop md->queue before
> -	 * flushing md->wq.
> +	 * Stop md->queue before flushing md->wq in case request-based
> +	 * dm defers requests to md->wq from md->queue.
>  	 */
>  	if (dm_request_based(md))
>  		stop_queue(md->queue);

Request-based dm doesn't use md->wq now, so you can just remove
the comment above.

Thanks,
Kiyoshi Ueda
