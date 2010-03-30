Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0C3XSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:18:07 -0400
Received: from kroah.org ([198.145.64.141]:51962 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0C3XR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:58 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:25 2010
Message-Id: <20100330225625.113507162@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [042/116] readahead: add blk_run_backing_dev
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

commit 65a80b4c61f5b5f6eb0f5669c8fb120893bfb388 upstream.

I added blk_run_backing_dev on page_cache_async_readahead so readahead I/O
is unpluged to improve throughput on especially RAID environment.

The normal case is, if page N become uptodate at time T(N), then T(N) <=
T(N+1) holds.  With RAID (and NFS to some degree), there is no strict
ordering, the data arrival time depends on runtime status of individual
disks, which breaks that formula.  So in do_generic_file_read(), just
after submitting the async readahead IO request, the current page may well
be uptodate, so the page won't be locked, and the block device won't be
implicitly unplugged:

               if (PageReadahead(page))
                        page_cache_async_readahead()
                if (!PageUptodate(page))
                                goto page_not_up_to_date;
                //...
page_not_up_to_date:
                lock_page_killable(page);

Therefore explicit unplugging can help.

Following is the test result with dd.

#dd if=testdir/testfile of=/dev/null bs=16384

-2.6.30-rc6
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s

-2.6.30-rc6-patched
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s

(7Disks RAID-0 Array)

-2.6.30-rc6
1054976+0 records in
1054976+0 records out
17284726784 bytes (17 GB) copied, 212.233 seconds, 81.4 MB/s

-2.6.30-rc6-patched
1054976+0 records out
17284726784 bytes (17 GB) copied, 198.878 seconds, 86.9 MB/s

(7Disks RAID-5 Array)

The patch was found to improve performance with the SCST scsi target
driver.  See
http://sourceforge.net/mailarchive/forum.php?thread_name=a0272b440906030714g67eabc5k8f847fb1e538cc62%40mail.gmail.com&forum_name=scst-devel

[akpm@linux-foundation.org: unbust comment layout]
[akpm@linux-foundation.org: "fix" CONFIG_BLOCK=n]
Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Ronald <intercommit@gmail.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/readahead.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -553,5 +553,17 @@ page_cache_async_readahead(struct addres
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+
+#ifdef CONFIG_BLOCK
+	/*
+	 * Normally the current page is !uptodate and lock_page() will be
+	 * immediately called to implicitly unplug the device. However this
+	 * is not always true for RAID conifgurations, where data arrives
+	 * not strictly in their submission order. In this case we need to
+	 * explicitly kick off the IO.
+	 */
+	if (PageUptodate(page))
+		blk_run_backing_dev(mapping->backing_dev_info, NULL);
+#endif
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);


