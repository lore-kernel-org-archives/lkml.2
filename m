Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1ATM66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:58:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57543 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1ATM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W6SkgQTjTTs9G3rt19w1lznb3JS/ARYd43i0W+S+Faryz2JG/kI7xH0eO63wq5VXZq
         4sO4xcVowU+hBYCajHXXGL76zD3vHziN7cRxP3VNi4PM5KVwBZMqJK6eIXnaI4rx+c0X
         RznDDuxdT8k8uSbSjoqOvCIgbp2DfBMetSuYc=
Date: Thu, 20 Jan 2011 14:58:49 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in
 blk_throtl_exit (v2)
Message-ID: <20110120125849.GA4172@swordfish>
References: <20110114192532.GA4274@swordfish>
 <20110120113211.GB16184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120113211.GB16184@redhat.com>
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
 Process modprobe (pid: 6189, threadinfo ffff88009a898000, task ffff880154a88000)
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
I added the same lines as in blk_queue_make_request -
`fall back to embedded per-queue lock'.

v2: According to comment by Vivek Goyal, queue_lock NULL check and fix moved 
out from loop driver code to blk_cleanup_queue, which is more general approach.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 block/blk-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2f4002f..45073ab 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -458,6 +458,10 @@ void blk_put_queue(struct request_queue *q)
 
 void blk_cleanup_queue(struct request_queue *q)
 {
+	/* fall back to our embedded per-queue locks */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
 	/*
 	 * We know we have process context here, so we can be a little
 	 * cautious and ensure that pending block actions on this device


