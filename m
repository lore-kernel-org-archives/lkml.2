Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2AJQWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:22:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2AJQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:22:43 -0500
Date: Tue, 10 Jan 2012 08:22:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Problem since "block: make gendisk hold a reference to
 its queue"
Message-ID: <20120110162234.GA20446@google.com>
References: <gik44z4phd.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gik44z4phd.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 10, 2012 at 03:11:10PM +0100, Dirk Gouders wrote:
> I noticed problematic kernel messages when my laptop boots, bisecting
> this issue lead me to commit 523e1d399c.  I attach the messages that I
> currently (commit e4e11180df) see, please let me know if further
> information is needed.

Thank you very much for bisecting the problem.

> floppy0: no floppy controllers found
> =============================================================================
> BUG blkdev_queue: Poison overwritten
> -----------------------------------------------------------------------------

Yeah, floppy does some funky stuff during init.

> Object ffff88006ec30420: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkjkkkkkkk

This looks like refcnt is dec'd after released.  Can you please apply
the following patch and see whether the WARN_ON() triggers?

diff --git a/block/blk-core.c b/block/blk-core.c
index 15de223..c3de15e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -342,6 +342,7 @@ EXPORT_SYMBOL(blk_run_queue);
 
 void blk_put_queue(struct request_queue *q)
 {
+	WARN_ON(atomic_read(&q->kobj.kref.refcount) == 0x6b6b6b6b);
 	kobject_put(&q->kobj);
 }
 EXPORT_SYMBOL(blk_put_queue);
