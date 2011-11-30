Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1K3NOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:14:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1K3NOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:14:49 -0500
Message-ID: <4ED62C38.1020106@redhat.com>
Date: Wed, 30 Nov 2011 14:14:32 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Nitin Gupta <ngupta@vflare.org>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Staging: zram: Turn lockdep off during zram_init_device()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


zram->init_lock can be hold over an allocation that may try to reclaim
memory in zram_init_device(). The same lock can later be taken from a
reclaim context in zram_make_request(), thus triggering a lockdep
warning. However, memory can not be reclaimed to an uninitialized zram
device. Therefore, this warning is a false positive.
To prevent the warning to occur, we turn lockdep off during while the
device is initialized.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
---
 zram_drv.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 09de99f..34f4b96 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -637,10 +637,22 @@ int zram_init_device(struct zram *zram)
 	int ret;
 	size_t num_pages;
 
+	/*
+	 * Here we hold init_lock over allocations that may try to reclaim
+	 * memory. The same lock is also taken from a reclaim context in
+	 * zram_make_request(). That end up in a lockdep warning.
+	 * Moreover the table can be quite big an it wouldn't be reasonable to
+	 * use kmalloc(GFP_NOFS,...) to allocate it.
+	 * Fortunately, memory can not be reclaimed to an uninitialized zram
+	 * device, so this warning is a false positive. Therefore, to prevent
+	 * the warning, we turn lockdep off here.
+	 */
+	lockdep_off();
 	down_write(&zram->init_lock);
 
 	if (zram->init_done) {
 		up_write(&zram->init_lock);
+		lockdep_on();
 		return 0;
 	}
 
@@ -682,6 +694,7 @@ int zram_init_device(struct zram *zram)
 
 	zram->init_done = 1;
 	up_write(&zram->init_lock);
+	lockdep_on();
 
 	pr_debug("Initialization done!\n");
 	return 0;
@@ -692,6 +705,7 @@ fail_no_table:
 fail:
 	__zram_reset_device(zram);
 	up_write(&zram->init_lock);
+	lockdep_on();
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
