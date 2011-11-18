Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab1KRXsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:48:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1KRXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:48:46 -0500
Date: Fri, 18 Nov 2011 15:48:28 -0800
From: tip-bot for Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <tip-2ed0e645f358c26f4f4a7aed56a9488db0020ad1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        santosh.shilimkar@ti.com, marc.zyngier@arm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, santosh.shilimkar@ti.com, tglx@linutronix.de
In-Reply-To: <1321446459-31409-1-git-send-email-marc.zyngier@arm.com>
References: <1321446459-31409-1-git-send-email-marc.zyngier@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Don't allow per cpu interrupts to be suspended
Git-Commit-ID: 2ed0e645f358c26f4f4a7aed56a9488db0020ad1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:48:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ed0e645f358c26f4f4a7aed56a9488db0020ad1
Gitweb:     http://git.kernel.org/tip/2ed0e645f358c26f4f4a7aed56a9488db0020ad1
Author:     Marc Zyngier <marc.zyngier@arm.com>
AuthorDate: Wed, 16 Nov 2011 12:27:39 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Nov 2011 17:44:04 +0100

genirq: Don't allow per cpu interrupts to be suspended

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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1321446459-31409-1-git-send-email-marc.zyngier@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 67ce837..0e2b179 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1596,7 +1596,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		return -ENOMEM;
 
 	action->handler = handler;
-	action->flags = IRQF_PERCPU;
+	action->flags = IRQF_PERCPU | IRQF_NO_SUSPEND;
 	action->name = devname;
 	action->percpu_dev_id = dev_id;
 
