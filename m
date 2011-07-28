Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1G1Xoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:29723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab1G1Xof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352064"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: sshtylyov@ru.mvista.com, stern@rowland.harvard.edu, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [30/50] EHCI: only power off port if over-current is active
Message-Id: <20110728234434.CFC8E2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

[ upstream commit 81463c1d707186adbbe534016cd1249edeab0dac ]

MAX4967 USB power supply chip we use on our boards signals over-current when
power is not enabled; once it's enabled, over-current signal returns to normal.
That unfortunately caused the endless stream of "over-current change on port"
messages. The EHCI root hub code reacts on every over-current signal change
with powering off the port -- such change event is generated the moment the
port power is enabled, so once enabled the power is immediately cut off.
I think we should only cut off power when we're seeing the active over-current
signal, so I'm adding such check to that code. I also think that the fact that
we've cut off the port power should be reflected in the result of GetPortStatus
request immediately, hence I'm adding a PORTSCn register readback after write...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: stable@kernel.org
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/usb/host/ehci-hub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ehci-hub.c
+++ linux-2.6.35.y/drivers/usb/host/ehci-hub.c
@@ -837,10 +837,11 @@ static int ehci_hub_control (
 			 * power switching; they're allowed to just limit the
 			 * current.  khubd will turn the power back on.
 			 */
-			if (HCS_PPC (ehci->hcs_params)){
+			if ((temp & PORT_OC) && HCS_PPC(ehci->hcs_params)) {
 				ehci_writel(ehci,
 					temp & ~(PORT_RWC_BITS | PORT_POWER),
 					status_reg);
+				temp = ehci_readl(ehci, status_reg);
 			}
 		}
 
