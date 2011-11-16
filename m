Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1KPM1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:27:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34655 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1KPM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:27:33 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH REPOST] genirq: don't allow per cpu interrupts to be suspended
Date: Wed, 16 Nov 2011 12:27:39 +0000
Message-Id: <1321446459-31409-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 16 Nov 2011 12:27:28.0818 (UTC) FILETIME=[1AF58920:01CCA45B]
X-MC-Unique: 111111612273002701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pAGCRm1J029914

The power management functions related to interrupts do not know
(yet) about per-cpu interrupts and end up calling the wrong
low-level methods to enable/disable interrupts.

This leads to all kind of interesting issues (action taken on one
CPU only, updating a refcount which is not used otherwise...).

The workaround for the time being is simply to flag these interrupts
with IRQF_NO_SUSPEND. At least on ARM, these interrupts are actually
dealt with at the architecture level.

Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 63c1625..6e04134 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1596,7 +1596,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		return -ENOMEM;
 
 	action->handler = handler;
-	action->flags = IRQF_PERCPU;
+	action->flags = IRQF_PERCPU | IRQF_NO_SUSPEND;
 	action->name = devname;
 	action->percpu_dev_id = dev_id;
 
-- 
1.7.0.4


