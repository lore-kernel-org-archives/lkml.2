Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3AEC2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:28:13 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33355 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3AEC2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:28:10 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v7 5/6] PM / Runtime: force memory allocation with no I/O during Runtime PM callbcack
Date: Sat,  5 Jan 2013 10:25:43 +0800
Message-Id: <1357352744-8138-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the introduced memalloc_noio_save() and
memalloc_noio_restore() to force memory allocation with no I/O
during runtime_resume/runtime_suspend callback on device with
the flag of 'memalloc_noio' set.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
--
v7:
	- move memalloc_noio_save/memalloc_noio_restore into
	rpm_callback to avoid code duplication, as suggested
	by Rafael
v5:
	- use inline memalloc_noio_save()
v4:
	- runtime_suspend need this too because rpm_resume may wait for
	completion of concurrent runtime_suspend, so deadlock still may
	be triggered in runtime_suspend path.
---
 drivers/base/power/runtime.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index cd92e1c..1244930 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -348,7 +348,24 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
 	if (!cb)
 		return -ENOSYS;
 
-	retval = __rpm_callback(cb, dev);
+	if (dev->power.memalloc_noio) {
+		unsigned int noio_flag;
+
+		/*
+		 * Deadlock might be caused if memory allocation with
+		 * GFP_KERNEL happens inside runtime_suspend and
+		 * runtime_resume callbacks of one block device's
+		 * ancestor or the block device itself. Network
+		 * device might be thought as part of iSCSI block
+		 * device, so network device and its ancestor should
+		 * be marked as memalloc_noio too.
+		 */
+		noio_flag = memalloc_noio_save();
+		retval = __rpm_callback(cb, dev);
+		memalloc_noio_restore(noio_flag);
+	} else {
+		retval = __rpm_callback(cb, dev);
+	}
 
 	dev->power.runtime_error = retval;
 	return retval != -EACCES ? retval : -EIO;
-- 
1.7.9.5

