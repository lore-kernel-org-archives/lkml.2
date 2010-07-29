Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab0G2LcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:32:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:44785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0G2Lb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:31:59 -0400
Date: Thu, 29 Jul 2010 11:31:44 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, ian.campbell@citrix.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
        tglx@linutronix.de
In-Reply-To: <1280398595-29708-4-git-send-email-ian.campbell@citrix.com>
References: <1280398595-29708-4-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xen: Do not suspend IPI IRQs.
Message-ID: <tip-4877c737283813bdb4bebfa3168c1585f6e3a8ca@git.kernel.org>
Git-Commit-ID: 4877c737283813bdb4bebfa3168c1585f6e3a8ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 11:31:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4877c737283813bdb4bebfa3168c1585f6e3a8ca
Gitweb:     http://git.kernel.org/tip/4877c737283813bdb4bebfa3168c1585f6e3a8ca
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Thu, 29 Jul 2010 11:16:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Jul 2010 13:24:58 +0200

xen: Do not suspend IPI IRQs.

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
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
LKML-Reference: <1280398595-29708-4-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
