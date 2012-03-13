Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040Ab2CMAY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40684 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938Ab2CMAYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 1/6] PM / Domains: Fix handling of wakeup devices during system resume
Date: Tue, 13 Mar 2012 01:24:11 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl>
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130124.11871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

During system suspend pm_genpd_suspend_noirq() checks if the given
device is in a wakeup path (i.e. it appears to be needed for one or
more wakeup devices to work or is a wakeup device itself) and if it
needs to be "active" for wakeup to work.  If that is the case, the
function returns 0 without incrementing the device domain's counter
of suspended devices and without executing genpd_stop_dev() for the
device.  In consequence, the device is not stopped (e.g. its clock
isn't disabled) and power is always supplied to its domain in the
resulting system sleep state.

However, pm_genpd_resume_noirq() doesn't repeat that check and it
runs genpd_start_dev() and decrements the domain's counter of
suspended devices even for the wakeup device that weren't stopped by
pm_genpd_suspend_noirq().  As a result, the start callback may be run
unnecessarily for them and their domains' counters of suspended
devices may become negative.  Both outcomes aren't desirable, so fix
pm_genpd_resume_noirq() to look for wakeup devices that might not be
stopped by during system suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -896,7 +896,8 @@ static int pm_genpd_resume_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off)
+	if (genpd->suspend_power_off
+	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
 	/*

