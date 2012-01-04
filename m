Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2ADFck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:32:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52426 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2ADFcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:32:32 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <davej@redhat.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <hvaibhav@ti.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 2/2] cpufreq: update lpj only if frequency has changed
Date: Wed, 4 Jan 2012 10:52:46 +0530
Message-ID: <1325654566-14217-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During scaling up of cpu frequency, loops_per_jiffy
is updated upon invoking PRECHANGE notifier.
If setting to new frequency fails in cpufreq driver,
lpj is left at incorrect value.

Hence update lpj only if cpu frequency is changed,
i.e. upon invoking POSTCHANGE notifier.

Penalty would be that during time period between
changing cpu frequency & invocation of POSTCHANGE
notifier, udelay(x) may not gurantee minimal delay
of 'x' us for frequency scaling up operation.

Perhaps a better solution would be to define
CPUFREQ_ABORTCHANGE & handle accordingly, but then
it would be more intrusive (using ABORTCHANGE may
help drivers also; if any has registered notifier
and expect POST for a PRECHANGE, their needs can
be taken care using ABORT)

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/cpufreq/cpufreq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 987a165..2f5801a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -204,8 +204,7 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 		pr_debug("saving %lu as reference value for loops_per_jiffy; "
 			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
 	}
-	if ((val == CPUFREQ_PRECHANGE  && ci->old < ci->new) ||
-	    (val == CPUFREQ_POSTCHANGE && ci->old > ci->new) ||
+	if ((val == CPUFREQ_POSTCHANGE  && ci->old != ci->new) ||
 	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
 		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
 								ci->new);
-- 
1.7.1

