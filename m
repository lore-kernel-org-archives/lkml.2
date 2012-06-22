Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591Ab2FVQPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:15:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57722 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762512Ab2FVQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336363200"; 
   d="scan'208";a="199722624"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <tim@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH WIP 6/6] xen/arm: enable evtchn irqs
Date: Fri, 22 Jun 2012 17:14:45 +0100
Message-ID: <1340381685-22529-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM irqs are not enabled by default:

- call enable_percpu_irq for IRQ_EVTCHN_CALLBACK;

- set the IRQF_VALID flag for the other irqs bound to evtchns. It causes
IRQ_NOAUTOEN to be set and as a consequence irq_unmask is going to be
called when a xenbus driver calls request_irq.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0132505..ca92755 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -53,6 +53,7 @@
 #include <xen/interface/hvm/params.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/sched.h>
+#include <asm/hw_irq.h>
 
 /*
  * This lock protects updates to the following mapping and reference-count
@@ -827,6 +828,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
+	set_irq_flags(irq, IRQF_VALID);
 
 out:
 	mutex_unlock(&irq_mapping_update_lock);
@@ -1751,6 +1753,7 @@ int __init xen_init_IRQ_arm(void)
 	if (rc) {
 		printk(KERN_ERR "Error requesting IRQ %d\n", IRQ_EVTCHN_CALLBACK);
 	}
+	enable_percpu_irq(IRQ_EVTCHN_CALLBACK, 0);
 	return rc;
 }
 core_initcall(xen_init_IRQ_arm);
-- 
1.7.2.5

