Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2L1Tln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:41:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55342 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab2L1TSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:36 -0500
Message-Id: <20121228190350.979751101@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 099/173] s390/cio: fix pgid reserved check
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

commit d99e79ec5574fc556c988f613ed6175f6de66f4a upstream.

The check to whom a device is reserved is done by checking the path
state of the affected channel paths. If it turns out that one path is
flagged as reserved by someone else the whole device is marked as such.

However the meaning of the RESVD_ELSE bit is that the addressed device
is reserved to a different pathgroup (and not reserved to a different
LPAR). If we do this test on a path which is currently not a member of
the pathgroup we could erroneously mark the device as reserved to
someone else.

To fix this collect the reserved state for all potential members of the
pathgroup and only mark the device as reserved if all of those potential
members have the RESVD_ELSE bit set.

Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/cio/device_pgid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index 368368f..908d287 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -234,7 +234,7 @@ static int pgid_cmp(struct pgid *p1, struct pgid *p2)
  * Determine pathgroup state from PGID data.
  */
 static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
-			 int *mismatch, int *reserved, u8 *reset)
+			 int *mismatch, u8 *reserved, u8 *reset)
 {
 	struct pgid *pgid = &cdev->private->pgid[0];
 	struct pgid *first = NULL;
@@ -248,7 +248,7 @@ static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
 		if ((cdev->private->pgid_valid_mask & lpm) == 0)
 			continue;
 		if (pgid->inf.ps.state2 == SNID_STATE2_RESVD_ELSE)
-			*reserved = 1;
+			*reserved |= lpm;
 		if (pgid_is_reset(pgid)) {
 			*reset |= lpm;
 			continue;
@@ -316,14 +316,14 @@ static void snid_done(struct ccw_device *cdev, int rc)
 	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 	struct pgid *pgid;
 	int mismatch = 0;
-	int reserved = 0;
+	u8 reserved = 0;
 	u8 reset = 0;
 	u8 donepm;
 
 	if (rc)
 		goto out;
 	pgid_analyze(cdev, &pgid, &mismatch, &reserved, &reset);
-	if (reserved)
+	if (reserved == cdev->private->pgid_valid_mask)
 		rc = -EUSERS;
 	else if (mismatch)
 		rc = -EOPNOTSUPP;
@@ -336,7 +336,7 @@ static void snid_done(struct ccw_device *cdev, int rc)
 	}
 out:
 	CIO_MSG_EVENT(2, "snid: device 0.%x.%04x: rc=%d pvm=%02x vpm=%02x "
-		      "todo=%02x mism=%d rsvd=%d reset=%02x\n", id->ssid,
+		      "todo=%02x mism=%d rsvd=%02x reset=%02x\n", id->ssid,
 		      id->devno, rc, cdev->private->pgid_valid_mask, sch->vpm,
 		      cdev->private->pgid_todo_mask, mismatch, reserved, reset);
 	switch (rc) {


