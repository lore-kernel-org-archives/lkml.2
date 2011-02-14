Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1BNNKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:10:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59215 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1BNNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:09:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BTdqEHPHd2VrKCBebUIOPmkEGTcYqpbLId6GCChAtujvlQZR7+qnn5yoYrgVqbkGxn
         Iy6gpZxrd39xRF+UuCjkpe2qeb0rMSkqpwvNMRkSv5tYXUu+pIiL5k6mA9AElUcycz08
         hw37AVLi/IZThjH/mEDmmpOOTKkoSCUkU7X4w=
Date: Mon, 14 Feb 2011 14:09:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH wq#fixes-2.6.38] workqueue: wake up a worker when a rescuer
 is leaving a gcwq
Message-ID: <20110214130954.GI18742@htj.dyndns.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110214130300.GH18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214130300.GH18742@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After executing the matching works, a rescuer leaves the gcwq whether
there are more pending works or not.  This may decrease the
concurrency level to zero and stall execution until a new work item is
queued on the gcwq.

Make rescuer wake up a regular worker when it leaves a gcwq if there
are more works to execute, so that execution isn't stalled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ray Jui <rjui@broadcom.com>
Cc: stable@kernel.org
---
 kernel/workqueue.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11869fa..90a17ca 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2047,6 +2047,15 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
+
+		/*
+		 * Leave this gcwq.  If keep_working() is %true, notify a
+		 * regular worker; otherwise, we end up with 0 concurrency
+		 * and stalling the execution.
+		 */
+		if (keep_working(gcwq))
+			wake_up_worker(gcwq);
+
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-- 
1.7.1

