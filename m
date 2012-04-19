Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2DSVnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:43:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab2DSVNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:13 -0400
Message-Id: <20120419210304.162007403@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, majianpeng <majianpeng@gmail.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 12/75] md/raid1,raid10: Fix calculation of vcnt when processing error recovery.
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit f4380a915823dbed0bf8e3cf502ebcf2b7c7f833 upstream.

If r1bio->sectors % 8 != 0,then the memcmp and a later
memcpy will omit the last bio_vec.

This is suitable for any stable kernel since 3.1 when bad-block
management was introduced.

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1669,6 +1669,7 @@ static int process_checks(struct r1bio *
 	struct r1conf *conf = mddev->private;
 	int primary;
 	int i;
+	int vcnt;
 
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
@@ -1678,9 +1679,9 @@ static int process_checks(struct r1bio *
 			break;
 		}
 	r1_bio->read_disk = primary;
+	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
-		int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1742,6 +1742,7 @@ static void sync_request_write(struct md
 	struct r10conf *conf = mddev->private;
 	int i, first;
 	struct bio *tbio, *fbio;
+	int vcnt;
 
 	atomic_set(&r10_bio->remaining, 1);
 
@@ -1756,10 +1757,10 @@ static void sync_request_write(struct md
 	first = i;
 	fbio = r10_bio->devs[i].bio;
 
+	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
-		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
 		tbio = r10_bio->devs[i].bio;
 
@@ -1825,7 +1826,6 @@ static void sync_request_write(struct md
 	 */
 	for (i = 0; i < conf->copies; i++) {
 		int j, d;
-		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)


