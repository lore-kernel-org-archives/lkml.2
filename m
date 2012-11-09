Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2KIA0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:26:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:47581 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864Ab2KIA0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:26:02 -0500
Message-Id: <e8a1a14896156327aea0feff6a1076f7f121b748.1352410985.git.ecashin@coraid.com>
In-Reply-To: <cover.1352410985.git.ecashin@coraid.com>
References: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/8] aoe: manipulate aoedev network stats under lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:25:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this bugfix in place the calculation of the criterion for
"lateness" is performed under lock.  Without the lock, there is a
chance that one of the non-atomic operations performed on the
round trip time statistics could be incomplete, such that an
incorrect lateness criterion would be calculated.

Without this change, the effect of the bug would be rare
unecessary but benign retransmissions.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6ea27fd..9aefbe3 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -603,14 +603,14 @@ rexmit_timer(ulong vp)
 
 	d = (struct aoedev *) vp;
 
+	spin_lock_irqsave(&d->lock, flags);
+
 	/* timeout based on observed timings and variations */
 	timeout = 2 * d->rttavg >> RTTSCALE;
 	timeout += 8 * d->rttdev >> RTTDSCALE;
 	if (timeout == 0)
 		timeout = 1;
 
-	spin_lock_irqsave(&d->lock, flags);
-
 	if (d->flags & DEVFL_TKILL) {
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
-- 
1.7.1

