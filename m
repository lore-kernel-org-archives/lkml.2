Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220Ab2CMAdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:33:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:48752 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab2CMAYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 169/196] fix oops in scsi_run_queue()
Date: Mon, 12 Mar 2012 20:21:22 -0400
Message-Id: <1331598109-31424-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844 upstream.

The recent commit closing the race window in device teardown:

commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Fri Apr 22 10:39:59 2011 -0500

    [SCSI] put stricter guards on queue dead checks

is causing a potential NULL deref in scsi_run_queue() because the
q->queuedata may already be NULL by the time this function is called.
Since we shouldn't be running a queue that is being torn down, simply
add a NULL check in scsi_run_queue() to forestall this.

Tested-by: Jim Schutt <jaschut@sandia.gov>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_lib.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2a9e12..725f3cd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -400,10 +400,15 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 static void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost;
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
+	/* if the device is dead, sdev will be NULL, so no queue to run */
+	if (!sdev)
+		return;
+
+	shost = sdev->host;
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
-- 
1.7.9.3

