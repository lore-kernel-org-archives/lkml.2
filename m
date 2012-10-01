Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2JAXBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35314 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab2JAXBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:12 -0400
Message-Id: <20121001225201.969551571@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 103/180] SCSI: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/scsi_error.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 573921d..3890793 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1550,6 +1550,20 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
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
-- 
1.7.2.1.45.g54fbc



