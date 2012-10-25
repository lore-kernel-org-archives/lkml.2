Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247Ab2JYJmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:42:54 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:37273 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884Ab2JYJmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:42:51 -0400
Message-ID: <50890937.7010809@ce.jp.nec.com>
Date: Thu, 25 Oct 2012 18:41:11 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 2/2] dm: stay in blk_queue_bypass until queue becomes initialized
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] dm: stay in blk_queue_bypass until queue becomes initialized

With 749fefe677 ("block: lift the initial queue bypass mode on
blk_register_queue() instead of blk_init_allocated_queue()"),
add_disk() eventually calls blk_queue_bypass_end().
This change invokes the following warning when multipath is used.

  BUG: scheduling while atomic: multipath/2460/0x00000002
  1 lock held by multipath/2460:
   #0:  (&md->type_lock){......}, at: [<ffffffffa019fb05>] dm_lock_md_type+0x17/0x19 [dm_mod]
  Modules linked in: ...
  Pid: 2460, comm: multipath Tainted: G        W    3.7.0-rc2 #1
  Call Trace:
   [<ffffffff810723ae>] __schedule_bug+0x6a/0x78
   [<ffffffff81428ba2>] __schedule+0xb4/0x5e0
   [<ffffffff814291e6>] schedule+0x64/0x66
   [<ffffffff8142773a>] schedule_timeout+0x39/0xf8
   [<ffffffff8108ad5f>] ? put_lock_stats+0xe/0x29
   [<ffffffff8108ae30>] ? lock_release_holdtime+0xb6/0xbb
   [<ffffffff814289e3>] wait_for_common+0x9d/0xee
   [<ffffffff8107526c>] ? try_to_wake_up+0x206/0x206
   [<ffffffff810c0eb8>] ? kfree_call_rcu+0x1c/0x1c
   [<ffffffff81428aec>] wait_for_completion+0x1d/0x1f
   [<ffffffff810611f9>] wait_rcu_gp+0x5d/0x7a
   [<ffffffff81061216>] ? wait_rcu_gp+0x7a/0x7a
   [<ffffffff8106fb18>] ? complete+0x21/0x53
   [<ffffffff810c0556>] synchronize_rcu+0x1e/0x20
   [<ffffffff811dd903>] blk_queue_bypass_start+0x5d/0x62
   [<ffffffff811ee109>] blkcg_activate_policy+0x73/0x270
   [<ffffffff81130521>] ? kmem_cache_alloc_node_trace+0xc7/0x108
   [<ffffffff811f04b3>] cfq_init_queue+0x80/0x28e
   [<ffffffffa01a1600>] ? dm_blk_ioctl+0xa7/0xa7 [dm_mod]
   [<ffffffff811d8c41>] elevator_init+0xe1/0x115
   [<ffffffff811e229f>] ? blk_queue_make_request+0x54/0x59
   [<ffffffff811dd743>] blk_init_allocated_queue+0x8c/0x9e
   [<ffffffffa019ffcd>] dm_setup_md_queue+0x36/0xaa [dm_mod]
   [<ffffffffa01a60e6>] table_load+0x1bd/0x2c8 [dm_mod]
   [<ffffffffa01a7026>] ctl_ioctl+0x1d6/0x236 [dm_mod]
   [<ffffffffa01a5f29>] ? table_clear+0xaa/0xaa [dm_mod]
   [<ffffffffa01a7099>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
   [<ffffffff811479fc>] do_vfs_ioctl+0x3fb/0x441
   [<ffffffff811b643c>] ? file_has_perm+0x8a/0x99
   [<ffffffff81147aa0>] sys_ioctl+0x5e/0x82
   [<ffffffff812010be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
   [<ffffffff814310d9>] system_call_fastpath+0x16/0x1b

The warning means during queue initialization blk_queue_bypass_start()
calls sleeping function (synchronize_rcu) while dm holds md->type_lock.

dm device initialization basically includes the following 3 steps:
  1. create ioctl, allocates queue and call add_disk()
  2. table load ioctl, determines device type and initialize queue
     if request-based
  3. resume ioctl, device becomes functional

So it is better to have dm's queue stay in bypass mode until
the initialization completes in table load ioctl.

The effect of additional blk_queue_bypass_start():

  3.7-rc2 (plain)
    # time for n in $(seq 1000); do dmsetup create --noudevsync --notable a; \
                                    dmsetup remove a; done

    real  0m15.434s
    user  0m0.423s
    sys   0m7.052s

  3.7-rc2 (with this patch)
    # time for n in $(seq 1000); do dmsetup create --noudevsync --notable a; \
                                    dmsetup remove a; done
    real  0m19.766s
    user  0m0.442s
    sys   0m6.861s

If this additional cost is not negligible, we need a variant of add_disk()
that does not end bypassing.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm.c        |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 02db918..ad02761 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1869,6 +1869,8 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 	add_disk(md->disk);
+	/* Until md type is determined, put the queue in bypass mode */
+	blk_queue_bypass_start(md->queue);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush",
@@ -2172,6 +2174,7 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 		return 1;
 
 	/* Fully initialize the queue */
+	WARN_ON(!blk_queue_bypass(md->queue));
 	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
 	if (!q)
 		return 0;
@@ -2198,6 +2201,7 @@ int dm_setup_md_queue(struct mapped_device *md)
 		return -EINVAL;
 	}
 
+	blk_queue_bypass_end(md->queue);
 	return 0;
 }
