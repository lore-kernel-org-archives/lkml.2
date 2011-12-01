Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1LAA6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:58:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:42702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1LAA6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:58:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="81544428"
From: "Yang, Fei" <fei.yang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@linux.intel.com>, "Gross, Mark" <mark.gross@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Wed, 30 Nov 2011 16:58:28 -0800
Subject: [PATCH] IRQ: Validate irq_ack function pointer before calling it
Thread-Topic: [PATCH] IRQ: Validate irq_ack function pointer before calling
 it
Thread-Index: AcyvxFZyxvFLKBmhSVub+D9qNz0Vpg==
Message-ID: <88D294E28D20D84C9350E231A79B0E63017F07D53E@orsmsx506.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_edge_irq doesn't validate function pointer irq_ack
before calling it. We need to check the pointer for NULL or the
drivers have to implement irq_ack even an empty one. I think the
former is better in case driver doesn't really need irq_ack.

Signed-off-by: Fei Yang <fei.yang@intel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---
kernel/irq/chip.c |    3 ++-
1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc5114b..12f9550 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -448,7 +448,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
    kstat_incr_irqs_this_cpu(irq, desc);

     /* Start handling the irq */
-    desc->irq_data.chip->irq_ack(&desc->irq_data);
+    if (desc->irq_data.chip->irq_ack)
+          desc->irq_data.chip->irq_ack(&desc->irq_data);

     do {
          if (unlikely(!desc->action)) {
-- 
1.7.0.4

