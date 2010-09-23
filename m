Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0IWV30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0IWV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:29:24 -0400
Date: Thu, 23 Sep 2010 17:27:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: pata_it821x driver reports many FLUSH CACHE command failures
Message-ID: <20100923172724.0da07fb1@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like pata_it821x has never supported FLUSH_CACHE, but now
we're seeing repeated failures. They happen over and over again and
prevent installation. I stuck a dump_stack() in the failure path and
got this:

it821x: can't process command 0xE7
Pid: 863, comm: fsck.ext3 Not tainted 2.6.35.5-30.fc14.x86_64 #1
Call Trace:
 [<ffffffffa001c491>] it821x_smart_qc_issue+0x9d/0xac [pata_it821x]
 [<ffffffff8132f60d>] ata_qc_issue+0x246/0x284
 [<ffffffff8107c3a0>] ? lock_acquired+0x1fd/0x20c
 [<ffffffff81311e29>] ? scsi_done+0x0/0x51
 [<ffffffff81333492>] ? ata_scsi_flush_xlat+0x0/0x35
 [<ffffffff81336a92>] __ata_scsi_queuecmd+0x192/0x1ee
 [<ffffffff81311e29>] ? scsi_done+0x0/0x51
 [<ffffffff81311e29>] ? scsi_done+0x0/0x51
 [<ffffffff81336ba5>] ata_scsi_queuecmd+0x5e/0x9d
 [<ffffffff8149db5f>] ? _raw_spin_lock_irqsave+0x71/0x7f
 [<ffffffff81312dd4>] ? scsi_dispatch_cmd+0x14b/0x29b
 [<ffffffff81312e69>] scsi_dispatch_cmd+0x1e0/0x29b
 [<ffffffff813194e4>] scsi_request_fn+0x47d/0x4a9
 [<ffffffff8122064e>] __blk_run_queue+0x45/0x75
 [<ffffffff8121c951>] elv_insert+0xb6/0x1bd
 [<ffffffff8121caf0>] __elv_add_request+0x98/0x9f
 [<ffffffff812227b5>] __make_request+0x381/0x3f0
 [<ffffffff8121fb6d>] generic_make_request+0x285/0x301
 [<ffffffff8121fcc3>] submit_bio+0xda/0xf7
 [<ffffffff81223a05>] blkdev_issue_flush+0xcd/0x13e
 [<ffffffff8107acb3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff811515a2>] blkdev_fsync+0x43/0x65
 [<ffffffff8149c823>] ? mutex_lock_nested+0x3e/0x43
 [<ffffffff81149c95>] vfs_fsync_range+0x5d/0x80
 [<ffffffff81149d20>] vfs_fsync+0x1c/0x1e
 [<ffffffff81149d50>] do_fsync+0x2e/0x43
 [<ffffffff8114a01a>] sys_fsync+0x10/0x14
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
ata7.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.01: failed command: FLUSH CACHE
ata7.01: cmd e7/00:00:00:00:00/00:00:00:00:00/b0 tag 0
         res 50/00:00:00:00:00/00:00:00:00:00/e0 Emask 0x1 (device error)
ata7.01: status: { DRDY }
ata7.00: configured for DMA
ata7.01: configured for DMA
ata7.01: device reported invalid CHS sector 0
ata7: EH complete
