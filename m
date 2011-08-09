Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1HIPx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab1HIPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:53:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] block: properly handle flush/fua requests in blk_insert_cloned_request
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
	<20110809153826.GB23842@htj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 09 Aug 2011 11:53:51 -0400
In-Reply-To: <20110809153826.GB23842@htj.dyndns.org> (Tejun Heo's message of
	"Tue, 9 Aug 2011 17:38:26 +0200")
Message-ID: <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Aug 09, 2011 at 11:05:34AM -0400, Jeff Moyer wrote:
>> @@ -1708,6 +1710,21 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>>  		return -EIO;
>>  
>> +	/*
>> +	 * Check the cmd_flags against the flush flags of the underlying
>> +	 * request_queue and resolve any differences.
>> +	 */
>> +	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
>> +		if (!(q->flush_flags & REQ_FLUSH))
>> +			rq->cmd_flags &= ~REQ_FLUSH;
>> +		if (!(q->flush_flags & REQ_FUA))
>> +			rq->cmd_flags &= ~REQ_FUA;
>> +		if (!(rq->cmd_flags & REQ_FLUSH) && !blk_rq_sectors(rq)) {
>> +			blk_end_bidi_request(rq, 0, 0, 0);
>> +			return 0;
>> +		}
>> +	}
>> +
>
> I'm a bit confused.  We still need ELEVATOR_INSERT_FLUSH fix for
> insertion paths, right?  Or is blk_insert_cloned_request() supposed to
> used only by request based dm which lives under the elevator?  If so,
> it would be great to make that explicit in the comment.  Maybe just
> renaming it to blk_insert_dm_cloned_request() would be better as it
> wouldn't be safe for other cases anyway.

request-based dm is the only caller at present.  I'm not a fan of
renaming the function, but I'm more than willing to comment it.

>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 6395692..4fe753f 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -168,7 +168,7 @@ enum rq_flag_bits {
>>  #define REQ_COMMON_MASK \
>>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
>>  	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
>> -#define REQ_CLONE_MASK		REQ_COMMON_MASK
>> +#define REQ_CLONE_MASK		(REQ_COMMON_MASK | REQ_FLUSH_SEQ)
>
> Given the weirdness, I think it deserves fat comment on why
> REQ_FLUSH_SEQ is necessary.

OK, the next version will have better comments.  ;-)  To answer the
question, without REQ_FLUSH_SEQ, empty flush requests would simply be
completed in blk_insert_cloned_request.  The completion path would then
try to do I/O accounting on the flush request (since REQ_FLUSH_SEQ was
stripped) and would end up dereferencing a null pointer (see below).

Cheers,
Jeff

BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
IP: [<ffffffff81222871>] blk_account_io_done+0x71/0x170
PGD 1122d6067 PUD 11f069067 PMD 0 
Oops: 0000 [#1] SMP 
CPU 1 
Modules linked in: autofs4 sunrpc p4_clockmod freq_table speedstep_lib ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_mod ipmi_si ipmi_msghandler hpilo hpwdt tg3 pcspkr serio_raw iTCO_wdt iTCO_vendor_support shpchp sg i3200_edac edac_core ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix qla2xxx scsi_transport_fc scsi_tgt radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: mperf]

Pid: 2150, comm: mkfs.ext4 Tainted: G        W   3.0.0+ #2 HP ProLiant DL320 G5p
RIP: 0010:[<ffffffff81222871>]  [<ffffffff81222871>] blk_account_io_done+0x71/0x170
RSP: 0018:ffff88011feb3b98  EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8800ca89e338 RSI: 0000000000000001 RDI: 0000000000000003
RBP: ffff88011feb3ba8 R08: ffff8800ca89e338 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000057 R12: 0000000000000001
R13: ffff88011f2d9838 R14: 0000000000000046 R15: 000000000fd00002
FS:  00007fbb9c207760(0000) GS:ffff880127c40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000002b0 CR3: 000000011f0ef000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mkfs.ext4 (pid: 2150, threadinfo ffff88011feb2000, task ffff88011e736100)
Stack:
 ffff8800ca89e200 0000000000000000 ffff88011feb3bc8 ffffffff81224e3c
 ffff8800ca89e200 0000000000000000 ffff88011feb3bf8 ffffffff812252e4
 ffff8800ca89e200 ffff88011f2d9838 ffff88011f2d9838 ffffffffffffffff
Call Trace:
 [<ffffffff81224e3c>] blk_finish_request+0x4c/0xe0
 [<ffffffff812252e4>] blk_end_bidi_request+0x54/0x80
 [<ffffffff812254fe>] blk_insert_cloned_request+0xde/0xf0
 [<ffffffffa02f9f4e>] dm_dispatch_request+0x3e/0x70 [dm_mod]
 [<ffffffffa02fab40>] map_request+0xd0/0x130 [dm_mod]
 [<ffffffffa02fac64>] dm_request_fn+0xc4/0x160 [dm_mod]
 [<ffffffff8121ff0b>] __blk_run_queue+0x1b/0x20
 [<ffffffff81225d42>] __make_request+0x2c2/0x300
 [<ffffffffa02fba46>] dm_request+0x36/0x40 [dm_mod]
 [<ffffffff81224660>] generic_make_request+0x2f0/0x5e0
 [<ffffffff81108e03>] ? mempool_alloc+0x63/0x150
 [<ffffffff8112f355>] ? handle_mm_fault+0x1d5/0x350
 [<ffffffff812249d6>] submit_bio+0x86/0x110
 [<ffffffff81198b6b>] ? bio_alloc_bioset+0x5b/0xf0
 [<ffffffff81228472>] blkdev_issue_flush+0xa2/0xe0
 [<ffffffff8119a626>] blkdev_fsync+0x26/0x40
 [<ffffffff81190eab>] vfs_fsync_range+0x2b/0x30
 [<ffffffff81190ecc>] vfs_fsync+0x1c/0x20
 [<ffffffff8119110a>] do_fsync+0x3a/0x60
 [<ffffffff81191160>] sys_fsync+0x10/0x20
 [<ffffffff814ed942>] system_call_fastpath+0x16/0x1b
Code: 00 00 48 8b 9f b8 00 00 00 41 83 e4 01 48 8b 0d a6 e7 9e 00 65 8b 04 25 70 d3 00 00 48 63 f0 48 2b 8f c0 00 00 00 49 8d 7c 24 02 
 8b 93 b0 02 00 00 48 03 14 f5 60 d9 bf 81 48 83 04 fa 01 44 
RIP  [<ffffffff81222871>] blk_account_io_done+0x71/0x170
 RSP <ffff88011feb3b98>
CR2: 00000000000002b0
---[ end trace f8f7146ad3f363dc ]---
