Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2GaEu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499Ab2GaEu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:26 -0400
Message-Id: <20120731044320.598387954@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        Tom Jackson <thomas.p.jackson@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 58/73] [SCSI] fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 57fc2e335fd3c2f898ee73570dc81426c28dc7b4 upstream.

Rapid ata hotplug on a libsas controller results in cases where libsas
is waiting indefinitely on eh to perform an ata probe.

A race exists between scsi_schedule_eh() and scsi_restart_operations()
in the case when scsi_restart_operations() issues i/o to other devices
in the sas domain.  When this happens the host state transitions from
SHOST_RECOVERY (set by scsi_schedule_eh) back to SHOST_RUNNING and
->host_busy is non-zero so we put the eh thread to sleep even though
->host_eh_scheduled is active.

Before putting the error handler to sleep we need to check if the
host_state needs to return to SHOST_RECOVERY for another trip through
eh.  Since i/o that is released by scsi_restart_operations has been
blocked for at least one eh cycle, this implementation allows those
i/o's to run before another eh cycle starts to discourage hung task
timeouts.

Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_error.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..804f632 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1687,6 +1687,20 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * requests are started.
 	 */
 	scsi_run_host_queues(shost);
+
+	/*
+	 * if eh is active and host_eh_scheduled is pending we need to re-run
+	 * recovery.  we do this check after scsi_run_host_queues() to allow
+	 * everything pent up since the last eh run a chance to make forward
+	 * progress before we sync again.  Either we'll immediately re-run
+	 * recovery or scsi_device_unbusy() will wake us again when these
+	 * pending commands complete.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->host_eh_scheduled)
+		if (scsi_host_set_state(shost, SHOST_RECOVERY))
+			WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**


