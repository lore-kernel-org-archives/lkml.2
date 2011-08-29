Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1H2OGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:06:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64968 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1H2OFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:05:55 -0400
Date: Mon, 29 Aug 2011 16:05:49 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH pm-freezer 3/4] freezer: check freezing() before leaving
 FROZEN state
Message-ID: <20110829140549.GD18871@mtj.dyndns.org>
References: <20110829140418.GB18871@mtj.dyndns.org>
 <20110829140509.GC18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140509.GC18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If another freeze happens before all tasks leave FROZEN state after
being thawed, the freezer can see the existing FROZEN and consider the
tasks to be frozen but they can clear FROZEN without checking the new
freezing().  Check freezing() while holding freezer_lock before
clearing FROZEN.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/freezer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: work/kernel/freezer.c
===================================================================
--- work.orig/kernel/freezer.c
+++ work/kernel/freezer.c
@@ -60,6 +60,7 @@ bool __refrigerator(bool check_kthr_stop
 	 */
 	spin_lock_irq(&freezer_lock);
 	current->flags |= PF_FROZEN;
+refreeze:
 	spin_unlock_irq(&freezer_lock);
 
 	save = current->state;
@@ -78,8 +79,10 @@ bool __refrigerator(bool check_kthr_stop
 		schedule();
 	}
 
-	/* leave FROZEN */
+	/* leave FROZEN after checking freezing() holding freezer_lock */
 	spin_lock_irq(&freezer_lock);
+	if (freezing(current))
+		goto refreeze;
 	current->flags &= ~PF_FROZEN;
 	spin_unlock_irq(&freezer_lock);
 
