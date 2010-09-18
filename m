Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IRTBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:11 -0400
Received: from kroah.org ([198.145.64.141]:51070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0IRTBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:09 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185952.974671077@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tom Kopec <tek@acm.org>, Daniel Stodden <daniel.stodden@citrix.com>
Subject: [002/123] xen: handle events as edge-triggered
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=xen-handle-events-as-edge-triggered.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -362,7 +362,7 @@ int bind_evtchn_to_irq(unsigned int evtc
 		irq = find_unbound_irq();
 
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "event");
+					      handle_edge_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_evtchn_info(evtchn);


