Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1C0QTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 12:19:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:51091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab1C0QTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 12:19:08 -0400
Date: Sun, 27 Mar 2011 16:18:56 GMT
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
In-Reply-To: <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
References: <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Reserve the irq when calling irq_set_chip()
Message-ID: <tip-d72274e5895d11570a0a4a3214a1933c86d5ccb7@git.kernel.org>
Git-Commit-ID: d72274e5895d11570a0a4a3214a1933c86d5ccb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Mar 2011 16:18:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d72274e5895d11570a0a4a3214a1933c86d5ccb7
Gitweb:     http://git.kernel.org/tip/d72274e5895d11570a0a4a3214a1933c86d5ccb7
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Fri, 25 Mar 2011 12:38:48 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 27 Mar 2011 17:45:58 +0200

genirq: Reserve the irq when calling irq_set_chip()

The helper macros and functions like for_each_active_irq() don't work
unless the irq is in the allocated_irqs set.

In the case of !CONFIG_SPARSE_IRQ, instead of forcing all users of the
irq infrastructure to explicitly call irq_reserve_irq(), do it for
them.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org
LKML-Reference: <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c9c0601..c35d74c 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -37,6 +37,12 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	irq_chip_set_defaults(chip);
 	desc->irq_data.chip = chip;
 	irq_put_desc_unlock(desc, flags);
+	/*
+	 * For !CONFIG_SPARSE_IRQ make the irq show up in
+	 * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
+	 * already marked, and this call is harmless.
+	 */
+	irq_reserve_irq(irq);
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
