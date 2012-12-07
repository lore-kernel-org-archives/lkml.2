Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423689Ab2LGBAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:00:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423622Ab2LGBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Peter Maloney <peter.maloney@brockmann-consult.de>,
        NeilBrown <neilb@suse.de>
Subject: [ 15/27] md/raid1{,0}: fix deadlock in bitmap_unplug.
Date: Thu,  6 Dec 2012 16:58:59 -0800
Message-Id: <20121207005830.182431944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 874807a83139abc094f939e93623c5623573d543 upstream.

If the raid1 or raid10 unplug function gets called
from a make_request function (which is very possible) when
there are bios on the current->bio_list list, then it will not
be able to successfully call bitmap_unplug() and it could
need to submit more bios and wait for them to complete.
But they won't complete while current->bio_list is non-empty.

So detect that case and handle the unplugging off to another thread
just like we already do when called from within the scheduler.

RAID1 version of bug was introduced in 3.6, so that part of fix is
suitable for 3.6.y.  RAID10 part won't apply.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Reported-by: Peter Maloney <peter.maloney@brockmann-consult.de>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -958,7 +958,7 @@ static void raid1_unplug(struct blk_plug
 	struct r1conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;


