Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab1CYPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:11:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45345 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1CYPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nU4v1ybOxSifApnFjjKJsFOYTZbGoPrkQBg+lx+W8zuH64o/22v/1TXg3cfizYmEnb
         4mGYtXrAFoiepTLxrTBw7v+Lnk+wFU+YvcZRuuOyvV5cyskb+q6TlMfesbaGfK1fMn5X
         0tTElwn2zSwWR1KgGC8nIkns6AIHrm5efsVo0=
Date: Fri, 25 Mar 2011 17:15:30 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [OOPS] elevator private data for REQ_FLUSH
Message-ID: <20110325151530.GA4414@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Commit
    9d5a4e946ce5352f19400b6370f4cd8e72806278
    block: skip elevator data initialization for flush requests
    
    Skip elevator initialization for flush requests by passing priv=0 to
    blk_alloc_request() in get_request().  As such elv_set_request() is
    never called for flush requests.

introduced priv flag, to skip elevator_private data init for FLUSH requests.
This, I guess, lead to NULL pointer deref on my machine in cfq_insert_request,
which requires elevator_private to be set:

  1 [   78.982169] Call Trace:                                                                                                                                                                                                     
  2 [   78.982178]  [<ffffffff8122d1fe>] cfq_insert_request+0x4e/0x47d
  3 [   78.982184]  [<ffffffff8123e139>] ? do_raw_spin_lock+0x6b/0x122
  4 [   78.982189]  [<ffffffff81218c4a>] elv_insert+0x212/0x265
  5 [   78.982192]  [<ffffffff81218ced>] __elv_add_request+0x50/0x52
  6 [   78.982195]  [<ffffffff8121b44a>] flush_plug_list+0xce/0x12f
  7 [   78.982199]  [<ffffffff8121b4c0>] __blk_flush_plug+0x15/0x21
  8 [   78.982205]  [<ffffffff8146b321>] schedule+0x43e/0xbea
  9 [   78.982211]  [<ffffffff8106f8bd>] ? __lock_acquire+0x149d/0x1576
 10 [   78.982215]  [<ffffffff8121ba9e>] ? drive_stat_acct+0x1b6/0x1c3
 11 [   78.982218]  [<ffffffff8121b92c>] ? drive_stat_acct+0x44/0x1c3
 12 [   78.982223]  [<ffffffff8121f641>] ? __make_request+0x268/0x2bf
 13 [   78.982226]  [<ffffffff8146bf66>] schedule_timeout+0x35/0x3b8
 14 [   78.982230]  [<ffffffff810705ed>] ? mark_held_locks+0x4b/0x6d
 15 [   78.982234]  [<ffffffff8146e768>] ? _raw_spin_unlock_irq+0x28/0x56
 16 [   78.982239]  [<ffffffff81033bc1>] ? get_parent_ip+0xe/0x3e
 17 [   78.982244]  [<ffffffff81471822>] ? sub_preempt_count+0x90/0xa3
 18 [   78.982247]  [<ffffffff8146acbb>] wait_for_common+0xc3/0x141
 19 [   78.982251]  [<ffffffff8103823a>] ? default_wake_function+0x0/0xf
 20 [   78.982254]  [<ffffffff8146ad51>] wait_for_completion+0x18/0x1a
 21 [   78.982258]  [<ffffffff8122087b>] blkdev_issue_flush+0xcb/0x11a
 22 [   78.982264]  [<ffffffff811a9d65>] ext4_sync_file+0x2b3/0x302
 23 [   78.982268]  [<ffffffff81129e25>] vfs_fsync_range+0x55/0x75
 24 [   78.982271]  [<ffffffff81129e84>] generic_write_sync+0x3f/0x41
 25 [   78.982278]  [<ffffffff810c6c6c>] generic_file_aio_write+0x8c/0xb9
 26 [   78.982281]  [<ffffffff811a99a9>] ext4_file_write+0x1dc/0x237
 27 [   78.982285]  [<ffffffff8123e139>] ? do_raw_spin_lock+0x6b/0x122
 28 [   78.982288]  [<ffffffff811a97cd>] ? ext4_file_write+0x0/0x237
 29 [   78.982292]  [<ffffffff81104859>] do_sync_readv_writev+0xb4/0xf9
 30 [   78.982298]  [<ffffffff8120af11>] ? security_file_permission+0x1e/0x84
 31 [   78.982302]  [<ffffffff8110418e>] ? rw_verify_area+0xab/0xc8
 32 [   78.982305]  [<ffffffff81104ac6>] do_readv_writev+0xb8/0x17d
 33 [   78.982309]  [<ffffffff81105b5e>] ? fget_light+0x166/0x30b
 34 [   78.982312]  [<ffffffff81104bcb>] vfs_writev+0x40/0x42
 35 [   78.982315]  [<ffffffff81104e1c>] sys_pwritev+0x55/0x99
 36 [   78.982320]  [<ffffffff81474a52>] system_call_fastpath+0x16/0x1b
 37 
 

Should we in that case use ELEVATOR_INSERT_FLUSH for REQ_FLUSH | REQ_FUA requests
(like below)?

---

 block/elevator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index c387d31..b17e577 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -734,6 +734,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
+	} else if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+		where = ELEVATOR_INSERT_FLUSH;
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
 		    where == ELEVATOR_INSERT_SORT)
 		where = ELEVATOR_INSERT_BACK;


