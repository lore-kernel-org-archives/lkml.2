Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2AXCn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab2AXCnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.502760699@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bhavesh Parekh <bparekh@nvidia.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [029/129] UBI: fix missing scrub when there is a bit-flip
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2141
Lines: 71

From: Bhavesh Parekh <bparekh@nvidia.com>

commit e801e128b2200c40a0ec236cf2330b2586b6e05a upstream.

Under some cases, when scrubbing the PEB if we did not get the lock on
the PEB it fails to scrub. Add that PEB again to the scrub list

Artem: minor amendments.

Signed-off-by: Bhavesh Parekh <bparekh@nvidia.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/eba.c |    6 ++++--
 drivers/mtd/ubi/ubi.h |    2 ++
 drivers/mtd/ubi/wl.c  |    5 ++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1028,12 +1028,14 @@ int ubi_eba_copy_leb(struct ubi_device *
 	 * 'ubi_wl_put_peb()' function on the @ubi->move_mutex. In turn, we are
 	 * holding @ubi->move_mutex and go sleep on the LEB lock. So, if the
 	 * LEB is already locked, we just do not move it and return
-	 * %MOVE_CANCEL_RACE, which means that UBI will re-try, but later.
+	 * %MOVE_RETRY. Note, we do not return %MOVE_CANCEL_RACE here because
+	 * we do not know the reasons of the contention - it may be just a
+	 * normal I/O on this LEB, so we want to re-try.
 	 */
 	err = leb_write_trylock(ubi, vol_id, lnum);
 	if (err) {
 		dbg_wl("contention on LEB %d:%d, cancel", vol_id, lnum);
-		return MOVE_CANCEL_RACE;
+		return MOVE_RETRY;
 	}
 
 	/*
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -120,6 +120,7 @@ enum {
  *                     PEB
  * MOVE_CANCEL_BITFLIPS: canceled because a bit-flip was detected in the
  *                       target PEB
+ * MOVE_RETRY: retry scrubbing the PEB
  */
 enum {
 	MOVE_CANCEL_RACE = 1,
@@ -127,6 +128,7 @@ enum {
 	MOVE_TARGET_RD_ERR,
 	MOVE_TARGET_WR_ERR,
 	MOVE_CANCEL_BITFLIPS,
+	MOVE_RETRY,
 };
 
 /**
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -795,7 +795,10 @@ static int wear_leveling_worker(struct u
 			protect = 1;
 			goto out_not_moved;
 		}
-
+		if (err == MOVE_RETRY) {
+			scrubbing = 1;
+			goto out_not_moved;
+		}
 		if (err == MOVE_CANCEL_BITFLIPS || err == MOVE_TARGET_WR_ERR ||
 		    err == MOVE_TARGET_RD_ERR) {
 			/*


