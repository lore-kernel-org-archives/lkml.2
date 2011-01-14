Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1ANRGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:06:52 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56344 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1ANRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:06:46 -0500
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Fix up calibration refinement conditionals to avoid divide by zero
Date: Fri, 14 Jan 2011 09:06:28 -0800
Message-Id: <1295024788-15619-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditional (!hpet && !ref_start && !ref_stop) doesn't really make
sense. If the refs are null, but hpet is on, we still want to break out.

Additionally, we've seen cases where invalid non-null values are
returned from emulated hardware, and this conditional misses those,
resulting in a div by zero.

The div by zero would be possible to trigger by chance if both reads
from the hardware provided the exact same value (due to hardware
wrapping).

So checking if both the ref values are the same should handle if we
don't have hardware (both null) or if they are the same value (either by
invalid hardware, or by chance), avoiding the div by zero issue.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c43e182..362ca9a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -935,7 +935,7 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 	tsc_stop = tsc_read_refs(&ref_stop, hpet);
 
 	/* hpet or pmtimer available ? */
-	if (!hpet && !ref_start && !ref_stop)
+	if (ref_start == ref_stop)
 		goto out;
 
 	/* Check, whether the sampling was disturbed by an SMI */
-- 
1.7.3.2.146.gca209

