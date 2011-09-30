Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1I3Out (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:50:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23910 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1I3Our (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:50:47 -0400
Subject: [PATCH] cciss: auto engage SCSI mid layer at driver load time
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 30 Sep 2011 09:50:45 -0500
Message-ID: <20110930145045.23092.25562.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

A long time ago, probably in 2002, one of the distros, or maybe
more than one, loaded block drivers prior to loading the SCSI
mid layer.  This meant that the cciss driver, being a block
driver, could not engage the SCSI mid layer at init time without
panicking, and relied on being poked by a userland program after
the system was up (and the SCSI mid layer was therefore present)
to engage the SCSI mid layer.

This is no longer the case, and cciss can safely rely on the
SCSI mid layer being present at init time and engage the SCSI
mid layer straight away.  This means that users will see their
tape drives and medium changers at driver load time without need
for a script in /etc/rc.d that does this:

for x in /proc/driver/cciss/cciss*
do
	echo "engage scsi" > $x
done

However, if no tape drives or medium changers are detected, the
SCSI mid layer will not be engaged.  If a tape drive or medium
change is later hot-added to the system it will then be necessary
to use the above script or similar for the device(s) to be
acceesible.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/blockdev/cciss.txt |   14 ++++++--------
 drivers/block/cciss.c            |    1 +
 drivers/block/cciss_scsi.c       |    1 +
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/blockdev/cciss.txt b/Documentation/blockdev/cciss.txt
index c00c6a5..bc6cef0 100644
--- a/Documentation/blockdev/cciss.txt
+++ b/Documentation/blockdev/cciss.txt
@@ -88,14 +88,12 @@ You must enable "SCSI tape drive support for Smart Array 5xxx" and
 "SCSI support" in your kernel configuration to be able to use SCSI
 tape drives with your Smart Array 5xxx controller.
 
-Additionally, note that the driver will not engage the SCSI core at init 
-time.  The driver must be directed to dynamically engage the SCSI core via 
-the /proc filesystem entry which the "block" side of the driver creates as 
-/proc/driver/cciss/cciss* at runtime.  This is because at driver init time, 
-the SCSI core may not yet be initialized (because the driver is a block 
-driver) and attempting to register it with the SCSI core in such a case 
-would cause a hang.  This is best done via an initialization script 
-(typically in /etc/init.d, but could vary depending on distribution). 
+Additionally, note that the driver will engage the SCSI core at init
+time if any tape drives or medium changers are detected.  The driver may
+also be directed to dynamically engage the SCSI core via the /proc filesystem
+entry which the "block" side of the driver creates as
+/proc/driver/cciss/cciss* at runtime.  This is best done via a script.
+
 For example:
 
 	for x in /proc/driver/cciss/cciss[0-9]*
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..c945024 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -5126,6 +5126,7 @@ reinit_after_soft_reset:
 	h->cciss_max_sectors = 8192;
 
 	rebuild_lun_table(h, 1, 0);
+	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
 	return 1;
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 951a4e3..e820b68 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1720,5 +1720,6 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 /* If no tape support, then these become defined out of existence */
 
 #define cciss_scsi_setup(cntl_num)
+#define cciss_engage_scsi(h)
 
 #endif /* CONFIG_CISS_SCSI_TAPE */

