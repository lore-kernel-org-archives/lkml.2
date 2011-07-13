Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1GMV4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:56:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1GMV4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:56:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/3] ARM / shmobile: Return -EBUSY from A4LC power off if A3RV is active
Date: Wed, 13 Jul 2011 23:56:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201107132352.59801.rjw@sisk.pl>
In-Reply-To: <201107132352.59801.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107132356.45037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the A4LC should only be powered off if the A3RV is off, make
the A4LC's power down routine return -EBUSY if A3RV is not off to
indicate to the core that it doesn't want to power off the domain in
that case.  This will cause the core to regard A4LC as active, so
the pm_genpd_poweron() in pd_power_down_a3rv() is not necessary any
more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -106,7 +106,6 @@ static int pd_power_down_a3rv(struct gen
 	int ret = pd_power_down(genpd);
 
 	/* try to power down A4LC after A3RV is requested off */
-	pm_genpd_poweron(&sh7372_a4lc.genpd);
 	genpd_queue_power_off_work(&sh7372_a4lc.genpd);
 
 	return ret;
@@ -118,7 +117,7 @@ static int pd_power_down_a4lc(struct gen
 	if (!(__raw_readl(PSTR) & (1 << sh7372_a3rv.bit_shift)))
 		return pd_power_down(genpd);
 
-	return 0;
+	return -EBUSY;
 }
 
 static bool pd_active_wakeup(struct device *dev)

