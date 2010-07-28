Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0G1Kyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:54:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19098 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab0G1Kyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:54:39 -0400
X-IronPort-AV: E=Sophos;i="4.55,273,1278302400"; 
   d="scan'208";a="107382895"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com
Subject: [PATCH 4/4] xen: do not suspend IPI IRQs.
Date: Wed, 28 Jul 2010 11:54:27 +0100
Message-Id: <1280314467-5637-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
References: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 28 Jul 2010 10:54:38.0568 (UTC) FILETIME=[4633D680:01CB2E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general the semantics of IPIs are that they are are expected to
continue functioning after dpm_suspend_noirq().

Specifically I have seen a deadlock between the callfunc IPI and the
stop machine used by xen's do_suspend() routine. If one CPU has already
called dpm_suspend_noirq() then there is a window where it can be sent
a callfunc IPI before all the other CPUs have entered stop_cpu().

If this happens then the first CPU ends up spinning in stop_cpu()
waiting for the other to rendezvous in state STOPMACHINE_PREPARE while
the other is spinning in csd_lock_wait().

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: <stable@kernel.org> # .32.x+: 517d6934: irq: rename IRQF_TIMER to IRQF_NO_SUSPEND
Cc: <stable@kernel.org> # .32.x+
---
 drivers/xen/events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index db8f506..28f133a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,6 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
+	irqflags |= IRQF_NO_SUSPEND;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
-- 
1.5.6.5

