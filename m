Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0JEIsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:48:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56606 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0JEIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:48:53 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] intel_ips -- ensure we do not enable gpu turbo mode without driver linkage
Date: Tue,  5 Oct 2010 09:48:42 +0100
Message-Id: <1286268522-26337-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both when polling the current turbo status (in poll_turbo_status mode)
and when handling thermal events (in ips_irq_handler) the current status
of GPU turbo is updated to match the hardware status.  However if during
driver initialisation we were unable aquire linkage to the i915 driver
enabling GPU turbo will lead to an oops on the first attempt to determine
GPU busy status.

Ensure that we do not enable GPU turbo unless we have driver linkage.

BugLink: http://bugs.launchpad.net/bugs/632430
Cc: stable@kernel.org
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/platform/x86/intel_ips.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index afe82e5..3ca50b3 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -680,7 +680,8 @@ static void update_turbo_limits(struct ips_driver *ips)
 	u32 hts = thm_readl(THM_HTS);
 
 	ips->cpu_turbo_enabled = !(hts & HTS_PCTD_DIS);
-	ips->gpu_turbo_enabled = !(hts & HTS_GTD_DIS);
+	if (ips->gpu_busy)
+		ips->gpu_turbo_enabled = !(hts & HTS_GTD_DIS);
 	ips->core_power_limit = thm_readw(THM_MPCPC);
 	ips->mch_power_limit = thm_readw(THM_MMGPC);
 	ips->mcp_temp_limit = thm_readw(THM_PTL);
@@ -1150,7 +1151,8 @@ static irqreturn_t ips_irq_handler(int irq, void *arg)
 				STS_GPL_SHIFT;
 			/* ignore EC CPU vs GPU pref */
 			ips->cpu_turbo_enabled = !(sts & STS_PCTD_DIS);
-			ips->gpu_turbo_enabled = !(sts & STS_GTD_DIS);
+			if (ips->gpu_busy)
+				ips->gpu_turbo_enabled = !(sts & STS_GTD_DIS);
 			ips->mcp_temp_limit = (sts & STS_PTL_MASK) >>
 				STS_PTL_SHIFT;
 			ips->mcp_power_limit = (tc1 & STS_PPL_MASK) >>
-- 
1.7.1

