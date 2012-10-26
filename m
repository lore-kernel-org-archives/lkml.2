Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2JZBnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:43:51 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:64925 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2JZBnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:43:50 -0400
Message-ID: <5089EA98.9070004@ce.jp.nec.com>
Date: Fri, 26 Oct 2012 10:42:48 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] dm: stay in blk_queue_bypass until queue becomes
 initialized
References: <50890937.7010809@ce.jp.nec.com>
In-Reply-To: <50890937.7010809@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/12 18:41, Jun'ichi Nomura wrote:
> With 749fefe677 ("block: lift the initial queue bypass mode on
> blk_register_queue() instead of blk_init_allocated_queue()"),
> add_disk() eventually calls blk_queue_bypass_end().
> This change invokes the following warning when multipath is used.
...
> The warning means during queue initialization blk_queue_bypass_start()
> calls sleeping function (synchronize_rcu) while dm holds md->type_lock.
> 
> dm device initialization basically includes the following 3 steps:
>   1. create ioctl, allocates queue and call add_disk()
>   2. table load ioctl, determines device type and initialize queue
>      if request-based
>   3. resume ioctl, device becomes functional
> 
> So it is better to have dm's queue stay in bypass mode until
> the initialization completes in table load ioctl.
> 
> The effect of additional blk_queue_bypass_start():
> 
>   3.7-rc2 (plain)
>     # time for n in $(seq 1000); do dmsetup create --noudevsync --notable a; \
>                                     dmsetup remove a; done
> 
>     real  0m15.434s
>     user  0m0.423s
>     sys   0m7.052s
> 
>   3.7-rc2 (with this patch)
>     # time for n in $(seq 1000); do dmsetup create --noudevsync --notable a; \
>                                     dmsetup remove a; done
>     real  0m19.766s
>     user  0m0.442s
>     sys   0m6.861s
> 
> If this additional cost is not negligible, we need a variant of add_disk()
> that does not end bypassing.

Or call blk_queue_bypass_start() before add_disk():

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ad02761..d14639b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1868,9 +1868,9 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
-	add_disk(md->disk);
 	/* Until md type is determined, put the queue in bypass mode */
 	blk_queue_bypass_start(md->queue);
+	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush",
---

If the patch is modified like above, we could fix the issue
without incurring additional cost on dm device creation.

# time for n in $(seq 1000); do dmsetup create --noudevsync --notable a; \
                                dmsetup remove a; done

real	0m15.684s
user	0m0.404s
sys	0m7.181s

-- 
Jun'ichi Nomura, NEC Corporation

