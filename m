Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1ECRAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:00:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab1ECRAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:00:23 -0400
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
From: James Bottomley <James.Bottomley@suse.de>
To: Jim Schutt <jaschut@sandia.gov>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4DC0330F.6050906@sandia.gov>
References: <4DC0330F.6050906@sandia.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 12:00:18 -0500
Message-ID: <1304442019.10982.7.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 10:53 -0600, Jim Schutt wrote:
> Please let me know if what further information you need, or if there is
> anything I can do, to help resolve this.

I think this is the fix (already in rc-fixes):

James

---
>From 3e85ea868dbd60a84240be5c1eebc36841b9c568 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@suse.de>
Date: Sun, 1 May 2011 09:42:07 -0500
Subject: [PATCH] [SCSI] fix oops in scsi_run_queue()

The recent commit closing the race window in device teardown:

commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Fri Apr 22 10:39:59 2011 -0500

    [SCSI] put stricter guards on queue dead checks

is causing a potential NULL deref in scsi_run_queue() because the
q->queuedata may already be NULL by the time this function is called.
Since we shouldn't be running a queue that is being torn down, simply
add a NULL check in scsi_run_queue() to forestall this.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9901b8..03979f4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -404,6 +404,10 @@ static void scsi_run_queue(struct request_queue *q)
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
+	/* if the device is dead, sdev will be NULL, so no queue to run */
+	if (!sdev)
+		return;
+
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 


