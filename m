Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1GJM2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:28:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab1GJM2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:28:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 7 v2] PM / Domains: Queue up power off work only if it is not pending
Date: Sun, 10 Jul 2011 14:29:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl> <201107101059.30322.rjw@sisk.pl>
In-Reply-To: <201107101059.30322.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101429.26416.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In theory it is possible that pm_genpd_poweroff() for two different
subdomains of the same parent domain will attempt to queue up the
execution of pm_genpd_poweroff() for the parent twice in a row.  This
would lead to unpleasant consequences, so prevent it from happening
by checking if genpd->power_off_work is pending before attempting to
queue it up.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

One more patch to the "PM / Domains: Generic PM domains improvements" series,
the changelog should explain everything. :-)

Thanks,
Rafael

---
 drivers/base/power/domain.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -213,6 +213,19 @@ static bool genpd_abort_poweroff(struct
 }
 
 /**
+ * genpd_queue_power_off_work - Queue up the execution of pm_genpd_poweroff().
+ * @genpd: PM domait to power off.
+ *
+ * Queue up the execution of pm_genpd_poweroff() unless it's already been done
+ * before.
+ */
+static void genpd_queue_power_off_work(struct generic_pm_domain *genpd)
+{
+	if (!work_pending(&genpd->power_off_work))
+		queue_work(pm_wq, &genpd->power_off_work);
+}
+
+/**
  * pm_genpd_poweroff - Remove power from a given PM domain.
  * @genpd: PM domain to power down.
  *
@@ -304,7 +317,7 @@ static int pm_genpd_poweroff(struct gene
 	if (parent) {
 		genpd_sd_counter_dec(parent);
 		if (parent->sd_count == 0)
-			queue_work(pm_wq, &parent->power_off_work);
+			genpd_queue_power_off_work(parent);
 
 		genpd_release_lock(parent);
 	}
