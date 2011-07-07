Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1GGUAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:00:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1GGUAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:00:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [Update][PATCH 5/5] PM / Domains: Do not restore all devices on power off error
Date: Thu, 7 Jul 2011 22:01:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl> <201107062301.22277.rjw@sisk.pl>
In-Reply-To: <201107062301.22277.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072201.52278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since every device in a PM domain has its own need_restore
flag, which is set by __pm_genpd_save_device(), there's no need to
walk the domain's device list and restore all devices on an error
from one of the drivers' .runtime_suspend() callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This update is on top of the [4/5] update I've just sent.  It makes the code
more straightforward IMHO.

Thanks,
Rafael

---
 drivers/base/power/domain.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -269,8 +269,10 @@ static int pm_genpd_poweroff(struct gene
 
 	list_for_each_entry_reverse(dle, &genpd->dev_list, node) {
 		ret = __pm_genpd_save_device(dle, genpd);
-		if (ret)
-			goto err_dev;
+		if (ret) {
+			genpd_set_active(genpd);
+			goto out;
+		}
 
 		if (genpd_abort_poweroff(genpd))
 			goto out;
@@ -311,13 +313,6 @@ static int pm_genpd_poweroff(struct gene
 	genpd->poweroff_task = NULL;
 	wake_up_all(&genpd->status_wait_queue);
 	return ret;
-
- err_dev:
-	list_for_each_entry_continue(dle, &genpd->dev_list, node)
-		__pm_genpd_restore_device(dle, genpd);
-
-	genpd_set_active(genpd);
-	goto out;
 }
 
 /**

