Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1ACNuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1ACNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=evnWW36WcAznjHamxe9hoeEbK7h2Eni7WORhrIpo4xhFi+Wny3szRL/URGnRnI3FZ8
         v1Y+4fApOfQ+Cf1eZHgwuwTOvwc2XF6c1C7hWo9TltbYIEKCabzOtpTJRLitXa6Rh0oi
         iMwzzpct68e0WlWk5jQ6Jm1rMGZG2lZmI93LM=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/32] bio-integrity: mark kintegrityd_wq highpri and CPU intensive
Date: Mon,  3 Jan 2011 14:49:27 +0100
Message-Id: <1294062595-30097-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work items processed by kintegrityd_wq won't block much, may burn a
lot of CPU cycles and affect IO latency.  Use alloc_workqueue() to
mark it highpri and CPU intensive with max concurrency of 1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/bio-integrity.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 4d0ff5e..e49cce2 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -782,7 +782,12 @@ void __init bio_integrity_init(void)
 {
 	unsigned int i;
 
-	kintegrityd_wq = create_workqueue("kintegrityd");
+	/*
+	 * kintegrityd won't block much but may burn a lot of CPU cycles.
+	 * Make it highpri CPU intensive wq with max concurrency of 1.
+	 */
+	kintegrityd_wq = alloc_workqueue("kintegrityd", WQ_MEM_RECLAIM |
+					 WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
 	if (!kintegrityd_wq)
 		panic("Failed to create kintegrityd\n");
 
-- 
1.7.1

