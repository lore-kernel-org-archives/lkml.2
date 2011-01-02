Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab1ABHVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:34202 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1ABHVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tom Kopec <tek@acm.org>, Daniel Stodden <daniel.stodden@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 030/260] xen: handle events as edge-triggered
Date: Sun,  2 Jan 2011 02:15:26 -0500
Message-Id: <1293952756-15010-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:39.0210 (UTC) FILETIME=[8E9DC8A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit dffe2e1e1a1ddb566a76266136c312801c66dcf7 upstream.

Xen events are logically edge triggered, as Xen only calls the event
upcall when an event is newly set, but not continuously as it remains set.
As a result, use handle_edge_irq rather than handle_level_irq.

This has the important side-effect of fixing a long-standing bug of
events getting lost if:
 - an event's interrupt handler is running
 - the event is migrated to a different vcpu
 - the event is re-triggered

The most noticable symptom of these lost events is occasional lockups
of blkfront.

Many thanks to Tom Kopec and Daniel Stodden in tracking this down.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Tom Kopec <tek@acm.org>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 28f133a..cc72dad 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -363,7 +363,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		irq = find_unbound_irq();
 
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "event");
+					      handle_edge_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_evtchn_info(evtchn);
-- 
1.7.3.3

