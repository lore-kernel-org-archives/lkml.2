Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2KENeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:34:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2KENeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:34:18 -0500
Date: Mon, 5 Nov 2012 14:34:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
In-Reply-To: <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz>
References: <20121105070106.GA17015@localhost> <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Jiri Kosina wrote:

> > I got the below oops in Linux 3.7-rc4 and it's bisected down to
> > 
> > commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084
> > Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > Date:   Mon Aug 27 20:56:51 2012 -0300
> > 
> >     floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
> 
> Fengguang,
> 
> thanks for the report.
> 
> How reliable is the bisection result? (i.e. how reliably are you able to 
> trigger this oops?).
> 
> I am having a hard time seeing how that particular commit could be causing 
> this kind of oops.

Hmm, actually I do see an option how this might happen on machines not 
having an actual floppy drive.

Fengguang, does the patch below make any difference for you please?

Thanks.




 drivers/block/floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1c49d71..3b9cc0f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4329,6 +4329,7 @@ out_unreg_region:
 	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+	destroy_workqueue(floppy_wq);
 out_put_disk:
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		if (!disks[drive])
@@ -4340,7 +4341,6 @@ out_put_disk:
 		}
 		put_disk(disks[drive]);
 	}
-	destroy_workqueue(floppy_wq);
 	return err;
 }
 

-- 
Jiri Kosina
SUSE Labs
