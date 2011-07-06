Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1GFVBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:01:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab1GFVBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/5 v1] PM / Domains: Make failing pm_genpd_prepare() clean up properly
Date: Wed, 6 Jul 2011 22:51:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl>
In-Reply-To: <201107062248.35586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062251.55481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If pm_generic_prepare() in pm_genpd_prepare() returns error code,
the PM domains counter of "prepared" devices should be decremented
and its suspend_power_off flag should be reset if this counter drops
down to zero.  Otherwise, the PM domain runtime PM code will not
handle the domain correctly (it will permanently think that system
suspend is in progress).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -367,6 +367,7 @@ static void pm_genpd_sync_poweroff(struc
 static int pm_genpd_prepare(struct device *dev)
 {
 	struct generic_pm_domain *genpd;
+	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -400,7 +401,16 @@ static int pm_genpd_prepare(struct devic
 
 	mutex_unlock(&genpd->lock);
 
-	return pm_generic_prepare(dev);
+	ret = pm_generic_prepare(dev);
+	if (ret) {
+		mutex_lock(&genpd->lock);
+
+		if (--genpd->prepared_count == 0)
+			genpd->suspend_power_off = false;
+
+		mutex_unlock(&genpd->lock);
+	}
+	return ret;
 }
 
 /**

