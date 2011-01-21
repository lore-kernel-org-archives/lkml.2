Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1AUMze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:55:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63519 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1AUMzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PoYQGsv2eLHYsj984bqiysTP39pqCrfFxAghaSuosOOD8qhRCrt4adWK7zvou5gwE8
         bBuMmTNljLxj5yEfiN4R5pcFPNm6l2tyHZVttvot5gFWB9bVs9zWUqkvbd9cWDPIRvEM
         qNLA7R/UTtCNlWiFsu4D82ZF8CgOw09iW/lTs=
Date: Fri, 21 Jan 2011 14:55:26 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] loop: queue_lock NULL pointer derefence in blk_throtl_exit
 (v3)
Message-ID: <20110121125526.GA4250@swordfish>
References: <20110114192532.GA4274@swordfish>
 <20110120113211.GB16184@redhat.com>
 <20110120125849.GA4172@swordfish>
 <20110120143546.GA18875@redhat.com>
 <20110120151738.GA4665@swordfish.minsk.epam.com>
 <20110120154327.GD18875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120154327.GD18875@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performing
$ sudo mount -o loop -o umask=0 /dev/sdb1 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ sudo modprobe -r loop

results in oops:       

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
 IP: [<ffffffff812479d4>] do_raw_spin_lock+0x14/0x122
 Process modprobe (pid: 6189, threadinfo ffff88009a898000, task
 ffff880154a88000)                                                        
 Call Trace:                                         
  [<ffffffff81486788>] _raw_spin_lock_irq+0x4a/0x51                         
  [<ffffffff8123404b>] ? blk_throtl_exit+0x3b/0xa0
  [<ffffffff8105b120>] ? cancel_delayed_work_sync+0xd/0xf
  [<ffffffff8123404b>] blk_throtl_exit+0x3b/0xa0   
  [<ffffffff81229bc8>] blk_release_queue+0x21/0x65
  [<ffffffff8123bb06>] kobject_release+0x51/0x66         
  [<ffffffff8123bab5>] ? kobject_release+0x0/0x66
  [<ffffffff8123ce1e>] kref_put+0x43/0x4d         
  [<ffffffff8123ba27>] kobject_put+0x47/0x4b    
  [<ffffffff8122717c>] blk_cleanup_queue+0x56/0x5b
  [<ffffffffa01c3824>] loop_exit+0x68/0x844 [loop]
  [<ffffffff8107cccc>] sys_delete_module+0x1e8/0x25b
  [<ffffffff814864c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81002112>] system_call_fastpath+0x16/0x1b


because of an attempt to acquire NULL queue_lock.   
Added the same lines as in blk_queue_make_request -       
`fall back to embedded per-queue lock' - when call blk_release_queue on
allocated but not initialized queue.

v2: According to comment by Vivek Goyal, queue_lock NULL check and fix moved
out from loop driver code to blk_release_queue, which is more general
approach.                                        
         
         
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 block/blk-sysfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 41fb691..b8ca1f7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -471,6 +471,12 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	/* It's possible that blk_release_queue will be called on allocated
+	 * but never initilalized queue. Fall back to our embedded per-queue 
+	 * locks in this case. */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
 	blk_throtl_exit(q);
 
 	if (rl->rq_pool)

