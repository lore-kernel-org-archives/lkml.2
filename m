Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1BJXbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:31:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:43591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1BJXbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:31:05 -0500
Date: Thu, 10 Feb 2011 23:30:48 GMT
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
In-Reply-To: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
References: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Call bus_lock/unlock functions in setup_irq()
Message-ID: <tip-986c011ddbb3ed44b35e1bfd67f6aa60b293b495@git.kernel.org>
Git-Commit-ID: 986c011ddbb3ed44b35e1bfd67f6aa60b293b495
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Feb 2011 23:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  986c011ddbb3ed44b35e1bfd67f6aa60b293b495
Gitweb:     http://git.kernel.org/tip/986c011ddbb3ed44b35e1bfd67f6aa60b293b495
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Wed, 9 Feb 2011 16:04:25 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 11 Feb 2011 00:25:13 +0100

genirq: Call bus_lock/unlock functions in setup_irq()

irq_chips that supply .irq_bus_lock/.irq_bus_sync_unlock functions,
expect that the other chip methods will be called inside of calls to
the pair.  If this expectation is not met, things tend to not work.

Make setup_irq() call chip_bus_lock()/chip_bus_sync_unlock() too.

For the vast majority of irq_chips, this will be a NOP as most don't
have these bus lock functions.

[ tglx: No we don't want to call that in __setup_irq(). Way too many
  	error exit pathes. ]

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
LKML-Reference: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..a00bf2c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -871,9 +871,14 @@ out_thread:
  */
 int setup_irq(unsigned int irq, struct irqaction *act)
 {
+	int retval;
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	return __setup_irq(irq, desc, act);
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, act);
+	chip_bus_sync_unlock(desc);
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
