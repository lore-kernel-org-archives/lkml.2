Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0FAHOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:14:45 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:50281 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0FAHOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:14:43 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 03:14:43 EDT
Message-ID: <4C04AC78.3020702@xenontk.org>
Date: Tue, 01 Jun 2010 12:15:12 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.9) Gecko/20100430 Thunderbird/3.0.4
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [2.6.35-rc1 BUG]: Calling sched_clock causes stack trace with DEBUG_PREEMPT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get stack traces like the following:

BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is native_sched_clock+0x37/0x6d
Pid: 1, comm: init Not tainted 2.6.35-rc1 #99
Call Trace:
[<ffffffff811c422b>] debug_smp_processor_id+0xd3/0xec
[<ffffffff81008a1e>] native_sched_clock+0x37/0x6d
[<ffffffff811a7bfd>] blk_rq_init+0x92/0x9e
[<ffffffff811a7f2e>] get_request+0x1c8/0x27e
[<ffffffff811a8011>] get_request_wait+0x2d/0x13c
[<ffffffff810306ee>] ? get_parent_ip+0x11/0x42
[<ffffffff81411ea6>] ? add_preempt_count+0xad/0xb1
[<ffffffff811a83b3>] __make_request+0x293/0x3b8
[<ffffffff81099737>] ? mempool_alloc_slab+0x10/0x12
[<ffffffff811a6bc4>] generic_make_request+0x187/0x1ea
[<ffffffff810306ee>] ? get_parent_ip+0x11/0x42
[<ffffffff811a6ce5>] submit_bio+0xbe/0xc7
[<ffffffff810f1f37>] submit_bh+0xef/0x111
[<ffffffff810f4865>] block_read_full_page+0x1ec/0x20c
[<ffffffff810f6815>] ? blkdev_get_block+0x0/0x5e
[<ffffffff81411de6>] ? sub_preempt_count+0x92/0xa5
[<ffffffff810a0500>] ? __lru_cache_add+0x73/0x93
[<ffffffff810f6e81>] blkdev_readpage+0x13/0x15
[<ffffffff8109f981>] __do_page_cache_readahead+0x161/0x194
[<ffffffff8109f9d0>] ra_submit+0x1c/0x20
[<ffffffff8109fc5f>] ondemand_readahead+0x1bb/0x1ce
[<ffffffff810973c9>] ? rcu_read_unlock+0xe/0x29
[<ffffffff8109fd46>] page_cache_sync_readahead+0x38/0x3a
[<ffffffff810993c2>] generic_file_aio_read+0x24d/0x57f
[<ffffffff810cf973>] ? __mem_cgroup_try_charge+0x78/0x46c
[<ffffffff810d2aa0>] do_sync_read+0xc6/0x103
[<ffffffff810306ee>] ? get_parent_ip+0x11/0x42
[<ffffffff810adca5>] ? handle_mm_fault+0x7cb/0x7e5
[<ffffffff810f69c5>] ? block_ioctl+0x32/0x36
[<ffffffff81189fcc>] ? selinux_file_permission+0x57/0xae
[<ffffffff81184524>] ? security_file_permission+0x11/0x13
[<ffffffff810d34af>] vfs_read+0xa6/0x103
[<ffffffff810d35c2>] sys_read+0x45/0x69
[<ffffffff810029ab>] system_call_fastpath+0x16/0x1b

Since with commit 9195291e you call 'set_start_time_ns' from
'blk_rq_init' which in turn calls 'sched_clock' with preempt enabled.
There are other calls to sched_clock in blk-cgroup.c. Maybe they should
be checked as well?

Regards,
David.
