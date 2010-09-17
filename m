Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0IQSq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:46:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0IQSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:46:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Remaining BKL users, what to do
Date: Fri, 17 Sep 2010 20:46:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "codalist@coda.cs.cmu.edu" <codalist@TELEMANN.coda.cs.cmu.edu>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de> <1284648549.23787.26.camel@gandalf.stny.rr.com> <4C9262C4.9050006@fusionio.com>
In-Reply-To: <4C9262C4.9050006@fusionio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009172046.11378.arnd@arndb.de>
X-Provags-ID: V02:K0:F5R5D3pkUTZ6x2mmROfBWzJen/YCf06Gyh7IpKXtyF0
 79+MluTdy5X4JJKlSyACHUfeJF+tsTAZvWCh7p4mrMGhtrvy4z
 oaFa8WlT0RTz7tZ90n+isUHIAXJo80LHYml76FVmIFK/8grKBV
 RU1ltHU0bIx4+OLlVTsYefQUq6uYLCZAk4nP4NJNJDH77KCRC+
 fLP1WIiHl1oUy56X1fBoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010 20:32:36 Jens Axboe wrote:
> On 2010-09-16 16:49, Steven Rostedt wrote:
> > Git blame shows this to be your code (copied from block/blktrace.c from
> > years past).
> > 
> > Is the lock_kernel() needed here? (although Arnd did add it in 62c2a7d9)
> 
> It isn't, it can be removed.

Ok, I queued up this patch now. Thanks!

	Arnd
---
Subject: [PATCH] blktrace: remove the big kernel lock

According to Jens, this code does not need the BKL at all,
it is sufficiently serialized by bd_mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 959f8d6..5328e87 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -23,7 +23,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
 
@@ -639,7 +638,6 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	if (!q)
 		return -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&bdev->bd_mutex);
 
 	switch (cmd) {
@@ -667,7 +665,6 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	}
 
 	mutex_unlock(&bdev->bd_mutex);
-	unlock_kernel();
 	return ret;
 }
 
@@ -1652,10 +1649,9 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	struct block_device *bdev;
 	ssize_t ret = -ENXIO;
 
-	lock_kernel();
 	bdev = bdget(part_devt(p));
 	if (bdev == NULL)
-		goto out_unlock_kernel;
+		goto out;
 
 	q = blk_trace_get_queue(bdev);
 	if (q == NULL)
@@ -1683,8 +1679,7 @@ out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 out_bdput:
 	bdput(bdev);
-out_unlock_kernel:
-	unlock_kernel();
+out:
 	return ret;
 }
 
@@ -1714,11 +1709,10 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	ret = -ENXIO;
 
-	lock_kernel();
 	p = dev_to_part(dev);
 	bdev = bdget(part_devt(p));
 	if (bdev == NULL)
-		goto out_unlock_kernel;
+		goto out;
 
 	q = blk_trace_get_queue(bdev);
 	if (q == NULL)
@@ -1753,8 +1747,6 @@ out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 out_bdput:
 	bdput(bdev);
-out_unlock_kernel:
-	unlock_kernel();
 out:
 	return ret ? ret : count;
 }
