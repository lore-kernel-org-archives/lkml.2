Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2L1TjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:39:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209Ab2L1TSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:47 -0500
Message-Id: <20121228190348.832174310@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Jeffery <djeffery@redhat.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 089/173] [SCSI] qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit a394aac88506159e047630fc90dc2242568382d8 upstream.

When the qla2xxx driver loses access to multiple, remote ports, there is a race
condition which can occur which will keep the request stuck on a scsi request
queue indefinitely.

This bad state occurred do to a race condition with how the FCPORT_UPDATE_NEEDED
bit is set in qla2x00_schedule_rport_del(), and how it is cleared in
qla2x00_do_dpc().  The problem port has its drport pointer set, but it has never
been processed by the driver to inform the fc transport that the port has been
lost.  qla2x00_schedule_rport_del() sets drport, and then sets the
FCPORT_UPDATE_NEEDED bit.  In qla2x00_do_dpc(), the port lists are walked and
any drport pointer is handled and the fc transport informed of the port loss,
then the FCPORT_UPDATE_NEEDED bit is cleared.  This leaves a race where the
dpc thread is processing one port removal, another port removal is marked
with a call to qla2x00_schedule_rport_del(), and the dpc thread clears the
bit for both removals, even though only the first removal was actually
handled.  Until another event occurs to set FCPORT_UPDATE_NEEDED, the later
port removal is never finished and qla2xxx stays in a bad state which causes
requests to become stuck on request queues.

This patch updates the driver to test and clear FCPORT_UPDATE_NEEDED
atomically.  This ensures the port state changes are processed and not lost.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3541,9 +3541,9 @@ qla2x00_do_dpc(void *data)
 			    "ISP abort end.\n");
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
+		    &base_vha->dpc_flags)) {
 			qla2x00_update_fcports(base_vha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
 		if (test_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags)) {


