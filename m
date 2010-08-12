Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab0HLAQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:16:31 -0400
Received: from kroah.org ([198.145.64.141]:47813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117Ab0HLAIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:21 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:15 2010
Message-Id: <20100812000615.142447588@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Subject: [27/67] md: move revalidate_disk() back outside open_mutex
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 147e0b6a639ac581ca3bf627bedc3f4a6d3eca66 upstream.

Commit b821eaa5 "md: remove ->changed and related code" moved
revalidate_disk() under open_mutex, and lockdep noticed.

[ INFO: possible circular locking dependency detected ]
2.6.32-mdadm-locking #1
-------------------------------------------------------
mdadm/3640 is trying to acquire lock:
 (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811acecb>] revalidate_disk+0x5b/0x90

but task is already holding lock:
 (&mddev->open_mutex){+.+...}, at: [<ffffffffa055e07a>] do_md_stop+0x4a/0x4d0 [md_mod]

which lock already depends on the new lock.

It is suitable for 2.6.35.x

Reported-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4711,7 +4711,7 @@ out:
  */
 static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 {
-	int err = 0;
+	int err = 0, revalidate = 0;
 	struct gendisk *disk = mddev->gendisk;
 	mdk_rdev_t *rdev;
 
@@ -4740,7 +4740,7 @@ static int do_md_stop(mddev_t * mddev, i
 			}
 
 		set_capacity(disk, 0);
-		revalidate_disk(disk);
+		revalidate = 1;
 
 		if (mddev->ro)
 			mddev->ro = 0;
@@ -4748,6 +4748,8 @@ static int do_md_stop(mddev_t * mddev, i
 		err = 0;
 	}
 	mutex_unlock(&mddev->open_mutex);
+	if (revalidate)
+		revalidate_disk(disk);
 	if (err)
 		return err;
 	/*


