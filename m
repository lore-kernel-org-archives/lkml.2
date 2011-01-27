Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1A0WCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:02:38 -0500
Received: from mailhub.stratus.com ([134.111.1.18]:58553 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1A0WCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:02:37 -0500
Date: Thu, 27 Jan 2011 15:59:22 -0500
From: Bandan Das <bandan.das@stratus.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qla2xxx: Fix possible race that could hang kthread_stop()
Message-ID: <20110127205922.GF31955@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Company: Stratus Technologies
X-Disclaimer: This email will auto delete in 5 days, nah.. I am kidding!
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 27 Jan 2011 20:59:23.0015 (UTC) FILETIME=[13035170:01CBBE65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race window in qla2x00_do_dpc() between
checking for kthread_should_stop() and going to sleep after
setting TASK_INTERRUPTIBLE. If qla2x00_free_device() is called
in this window, kthread_stop will wait forever because there 
will be no one to wake up the process.


Signed-off-by: Bandan Das <bandan.das@stratus.com>
Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c194c23..8d14d77 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3286,6 +3286,8 @@ qla2x00_do_dpc(void *data)
 		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
 
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop())
+			break;
 		schedule();
 		__set_current_state(TASK_RUNNING);
 
-- 
1.7.2.3
