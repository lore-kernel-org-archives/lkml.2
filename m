Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0GAWGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:06:15 -0400
Received: from kroah.org ([198.145.64.141]:47600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717Ab0GAUue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:34 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.799619611@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marek Vasut <marek.vasut@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 083/164] ARM: 6146/1: sa1111: Prevent deadlock in resume path
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Va=C5=A1ut?= <marek.vasut@gmail.com>

commit 3defb2476166445982a90c12d33f8947e75476c4 upstream.

This patch reorganises the sa1111_resume() function in a manner the spinlock
happens after calling the sa1111_wake(). This fixes two bugs:

1) This function called sa1111_wake() which tried to claim the same spinlock
   the sa1111_resume() already claimed. This would result in certain deadlock.

   Original idea for this part: Russell King <rmk+kernel@arm.linux.org.uk>

2) The function didn't unlock the spinlock in case the chip didn't report
   correct ID.

   Original idea for this part: Julia Lawall <julia@diku.dk>

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/common/sa1111.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -887,8 +887,6 @@ static int sa1111_resume(struct platform
 	if (!save)
 		return 0;
 
-	spin_lock_irqsave(&sachip->lock, flags);
-
 	/*
 	 * Ensure that the SA1111 is still here.
 	 * FIXME: shouldn't do this here.
@@ -905,6 +903,13 @@ static int sa1111_resume(struct platform
 	 * First of all, wake up the chip.
 	 */
 	sa1111_wake(sachip);
+
+	/*
+	 * Only lock for write ops. Also, sa1111_wake must be called with
+	 * released spinlock!
+	 */
+	spin_lock_irqsave(&sachip->lock, flags);
+
 	sa1111_writel(0, sachip->base + SA1111_INTC + SA1111_INTEN0);
 	sa1111_writel(0, sachip->base + SA1111_INTC + SA1111_INTEN1);
 


