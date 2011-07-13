Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1GMV4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:56:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1GMV4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:56:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM / Domains: Take .power_off() error code into account
Date: Wed, 13 Jul 2011 23:55:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201107132352.59801.rjw@sisk.pl>
In-Reply-To: <201107132352.59801.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107132355.27355.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently pm_genpd_poweroff() discards error codes returned by
the PM domain's .power_off() callback, because it's safer to always
regard the domain as inaccessible to drivers after a failing
.power_off().  Still, there are situations in which the low-level
code may want to indicate that it doesn't want to power off the
domain, so allow it to do that by returning -EBUSY from .power_off().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -312,8 +312,16 @@ static int pm_genpd_poweroff(struct gene
 		}
 	}
 
-	if (genpd->power_off)
-		genpd->power_off(genpd);
+	if (genpd->power_off) {
+		ret = genpd->power_off(genpd);
+		if (ret == -EBUSY) {
+			genpd_set_active(genpd);
+			if (parent)
+				genpd_release_lock(parent);
+
+			goto out;
+		}
+	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
 

