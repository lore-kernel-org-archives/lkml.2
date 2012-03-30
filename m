Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965989Ab2C3VU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965783Ab2C3VUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:50 -0400
Message-Id: <20120330194840.654976319@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ray Morris <support@bettercgi.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 081/175] md/raid1,raid10: avoid deadlock during resync/recovery.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit d6b42dcb995e6acd7cc276774e751ffc9f0ef4bf upstream.

If RAID1 or RAID10 is used under LVM or some other stacking
block device, it is possible to enter a deadlock during
resync or recovery.
This can happen if the upper level block device creates
two requests to the RAID1 or RAID10.  The first request gets
processed, blocks recovery and queue requests for underlying
requests in current->bio_list.  A resync request then starts
which will wait for those requests and block new IO.

But then the second request to the RAID1/10 will be attempted
and it cannot progress until the resync request completes,
which cannot progress until the underlying device requests complete,
which are on a queue behind that second request.

So allow that second request to proceed even though there is
a resync request about to start.

This is suitable for any -stable kernel.

Reported-by: Ray Morris <support@bettercgi.com>
Tested-by: Ray Morris <support@bettercgi.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |   17 +++++++++++++++--
 drivers/md/raid10.c |   17 +++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -737,9 +737,22 @@ static void wait_barrier(struct r1conf *
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
-		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+		/* Wait for the barrier to drop.
+		 * However if there are already pending
+		 * requests (preventing the barrier from
+		 * rising completely), and the
+		 * pre-process bio queue isn't empty,
+		 * then don't wait, as we need to empty
+		 * that queue to get the nr_pending
+		 * count down.
+		 */
+		wait_event_lock_irq(conf->wait_barrier,
+				    !conf->barrier ||
+				    (conf->nr_pending &&
+				     current->bio_list &&
+				     !bio_list_empty(current->bio_list)),
 				    conf->resync_lock,
-				    );
+			);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -863,9 +863,22 @@ static void wait_barrier(struct r10conf
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
-		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+		/* Wait for the barrier to drop.
+		 * However if there are already pending
+		 * requests (preventing the barrier from
+		 * rising completely), and the
+		 * pre-process bio queue isn't empty,
+		 * then don't wait, as we need to empty
+		 * that queue to get the nr_pending
+		 * count down.
+		 */
+		wait_event_lock_irq(conf->wait_barrier,
+				    !conf->barrier ||
+				    (conf->nr_pending &&
+				     current->bio_list &&
+				     !bio_list_empty(current->bio_list)),
 				    conf->resync_lock,
-				    );
+			);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;


