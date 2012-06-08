Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab2FHF3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:29:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43150 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759958Ab2FHFHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:12 -0400
Message-Id: <20120608041841.840980710@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 07/82] [SCSI] Fix dm-multipath starvation when scsi host is busy
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

commit b7e94a1686c5daef4f649f7f4f839cc294f07710 upstream.

block congestion control doesn't have any concept of fairness across
multiple queues.  This means that if SCSI reports the host as busy in
the queue congestion control it can result in an unfair starvation
situation in dm-mp if there are multiple multipath devices on the same
host.  For example:
http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html

The fix for this is to report only the sdev busy state (and ignore the
host busy state) in the block congestion control call back.
The host is still congested, but the SCSI subsystem will sort out the
congestion in a fair way because it knows the relation between the
queues and the host.

[jejb: fixed up trailing whitespace]
Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_lib.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62ddfd3..6dfb978 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1378,16 +1378,19 @@ static int scsi_lld_busy(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
-	struct scsi_target *starget;
 
 	if (!sdev)
 		return 0;
 
 	shost = sdev->host;
-	starget = scsi_target(sdev);
 
-	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
-	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
+	/*
+	 * Ignore host/starget busy state.
+	 * Since block layer does not have a concept of fairness across
+	 * multiple queues, congestion of host/starget needs to be handled
+	 * in SCSI layer.
+	 */
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev))
 		return 1;
 
 	return 0;


