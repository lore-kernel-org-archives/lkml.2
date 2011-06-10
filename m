Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1FJI62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:58:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1FJI6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:58:25 -0400
Date: Fri, 10 Jun 2011 08:58:16 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-13863a66c9c8a663665445cf05d68de96ff31830@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tglx@linutronix.de
In-Reply-To: <alpine.LNX.2.00.1106092300360.17868@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106092300360.17868@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Prevent potential NULL dereference in irq_set_irq_wake()
Git-Commit-ID: 13863a66c9c8a663665445cf05d68de96ff31830
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Jun 2011 08:58:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13863a66c9c8a663665445cf05d68de96ff31830
Gitweb:     http://git.kernel.org/tip/13863a66c9c8a663665445cf05d68de96ff31830
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Thu, 9 Jun 2011 23:14:58 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 10 Jun 2011 10:53:42 +0200

genirq: Prevent potential NULL dereference in irq_set_irq_wake()

In kernel/irq/manage.c::irq_set_irq_wake() we call
irq_get_desc_buslock() which may return NULL, but the code
dereferences the result unconditionally.

irq_set_irq_wake() has lots of callers - I checked a few and I couldn't
find anything that guarantees that they won't call it with some input that
will cause irq_get_desc_buslock() to return NULL, so I think it's a good
thing to test and -EINVAL was the most sane error code in this situation
that I could think of.

Not all callers test the return value of irq_set_irq_wake(), but those
that do take != 0 to mean error as far as I can see, so they should be
fine. I guess those that don't test actually should, but that's a
different issue.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1106092300360.17868@swampdragon.chaosbits.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d64bafb..0a7840ae 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -491,6 +491,9 @@ int irq_set_irq_wake(unsigned int irq, unsigned int on)
 	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
 	int ret = 0;
 
+	if (!desc)
+		return -EINVAL;
+
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
