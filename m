Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0ESPpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:45:54 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25361 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0ESPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:45:49 -0400
X-IronPort-AV: E=Sophos;i="4.53,264,1272859200"; 
   d="scan'208";a="97735856"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] xen: ensure timer tick is resumed even on CPU driving the resume
Date: Wed, 19 May 2010 16:36:57 +0100
Message-Id: <1274283417-5224-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1274283134.14939.205.camel@zakaz.uk.xensource.com>
References: <1274283134.14939.205.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 19 May 2010 15:36:14.0228 (UTC) FILETIME=[03E27540:01CAF769]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core suspend/resume code is run from stop_machine on CPU0 but
parts of the suspend/resume machinery (including xen_arch_resume) are
run on whichever CPU happened to schedule the xenwatch kernel thread.

As part of the non-core resume code xen_arch_resume is called in order
to restart the timer tick on non-boot processors. The boot processor
itself is taken care of by core timekeeping code.

xen_arch_resume uses smp_call_function which does not call the given
function on the current processor. This means that we can end up with
one CPU not receiving timer ticks if the xenwatch thread happened to
be scheduled on CPU > 0.

Use on_each_cpu instead of smp_call_function to ensure the timer tick
is resumed everywhere.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stable Kernel <stable@kernel.org>
---
 arch/x86/xen/suspend.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 987267f..a9c6611 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -60,6 +60,6 @@ static void xen_vcpu_notify_restore(void *data)
 
 void xen_arch_resume(void)
 {
-	smp_call_function(xen_vcpu_notify_restore,
-			       (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
+	on_each_cpu(xen_vcpu_notify_restore,
+		    (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
 }
-- 
1.5.6.5

