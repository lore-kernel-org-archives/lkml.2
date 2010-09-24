Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0IXNvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:51:19 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:29585 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756557Ab0IXNvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:51:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACpJnExLd/sX/2dsb2JhbAAHgxXSLJIlgSKDLnMEjzI
X-IronPort-AV: E=Sophos;i="4.57,230,1283745600"; 
   d="scan'208";a="76633719"
Subject: [PATCH] block: Prevent hang_check firing during long I/O
From: Mark Lord <kernel@teksavvy.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: dgilbert@interlog.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Joel Becker <joel.becker@oracle.com>
In-Reply-To: <4C9C6B7D.1060805@kernel.dk>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com>
	 <4C9C129E.5050504@teksavvy.com> <4C9C2039.8050903@teksavvy.com>
	 <4C9C6B7D.1060805@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 09:51:13 -0400
Message-ID: <1285336273.9259.2.camel@corey>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During long I/O operations, the hang_check timer may fire,
trigger stack dumps that unnecessarily alarm the user.

Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to complete

So, if hang_check is armed, we should wake up periodically
to prevent it from triggering.  This patch uses a wake-up interval
equal to half the hang_check timer period, which keeps overhead low enough.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/block/blk-exec.c	2010-09-20 19:56:53.000000000 -0400
+++ linux/block/blk-exec.c	2010-09-24 09:43:32.342604574 -0400
@@ -80,6 +80,7 @@
 	DECLARE_COMPLETION_ONSTACK(wait);
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	int err = 0;
+	unsigned long hang_check;
 
 	/*
 	 * we need an extra reference to the request, so we can look at
@@ -95,7 +96,13 @@
 
 	rq->end_io_data = &wait;
 	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
-	wait_for_completion(&wait);
+
+	/* Prevent hang_check timer from firing at us during very long I/O */
+	hang_check = sysctl_hung_task_timeout_secs;
+	if (hang_check)
+		while (!wait_for_completion_timeout(&wait, hang_check * (HZ/2)));
+	else
+		wait_for_completion(&wait);
 
 	if (rq->errors)
 		err = -EIO;


