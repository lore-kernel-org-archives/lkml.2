Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab0G3S1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:27:12 -0400
Received: from kroah.org ([198.145.64.141]:58283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759832Ab0G3Rz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:40 2010
Message-Id: <20100730175140.630439247@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Prasanna S. Panchamukhi" <prasanna.panchamukhi@riverbed.com>,
        Rob Becker <rbecker@riverbed.com>, NeilBrown <neilb@suse.de>
Subject: [077/205] md: raid10: Fix null pointer dereference in fix_read_error()
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>

commit 0544a21db02c1d8883158fd6f323364f830a120a upstream.

Such NULL pointer dereference can occur when the driver was fixing the
read errors/bad blocks and the disk was physically removed
causing a system crash. This patch check if the
rcu_dereference() returns valid rdev before accessing it in fix_read_error().

Signed-off-by: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
Signed-off-by: Rob Becker <rbecker@riverbed.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1487,14 +1487,14 @@ static void fix_read_error(conf_t *conf,
 	int sectors = r10_bio->sectors;
 	mdk_rdev_t*rdev;
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
+	int d = r10_bio->devs[r10_bio->read_slot].devnum;
 
 	rcu_read_lock();
-	{
-		int d = r10_bio->devs[r10_bio->read_slot].devnum;
+	rdev = rcu_dereference(conf->mirrors[d].rdev);
+	if (rdev) { /* If rdev is not NULL */
 		char b[BDEVNAME_SIZE];
 		int cur_read_error_count = 0;
 
-		rdev = rcu_dereference(conf->mirrors[d].rdev);
 		bdevname(rdev->bdev, b);
 
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1534,7 +1534,7 @@ static void fix_read_error(conf_t *conf,
 
 		rcu_read_lock();
 		do {
-			int d = r10_bio->devs[sl].devnum;
+			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
@@ -1568,7 +1568,7 @@ static void fix_read_error(conf_t *conf,
 		rcu_read_lock();
 		while (sl != r10_bio->read_slot) {
 			char b[BDEVNAME_SIZE];
-			int d;
+
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
@@ -1604,7 +1604,7 @@ static void fix_read_error(conf_t *conf,
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
-			int d;
+
 			if (sl==0)
 				sl = conf->copies;
 			sl--;


