Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0FTUyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:54:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51921 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab0FTUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:54:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:53:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/8] firewire: expose extended tcode of incoming lock requests
 to (userspace) drivers
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.8ca8144470b21311@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Tue, 18 May 2010 10:57:33 -0400
From: Jay Fenlason <fenlason@redhat.com>

When a remote device does a LOCK_REQUEST, the core does not pass
the extended tcode to userspace.  This patch makes it use the
juju-specific tcodes listed in firewire-constants.h for incoming
requests.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>

This matches how tcode in the API for outbound requests is treated.
Affects kernelspace and userspace drivers alike, but at the moment there
are no kernespace drivers that receive lock requests.

Split out from a combo patch, slightly reordered, changelog reworded.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -780,9 +780,11 @@ static void handle_exclusive_region_requ
 	unsigned long flags;
 	int tcode, destination, source;
 
-	tcode       = HEADER_GET_TCODE(p->header[0]);
 	destination = HEADER_GET_DESTINATION(p->header[0]);
 	source      = HEADER_GET_SOURCE(p->header[1]);
+	tcode       = HEADER_GET_TCODE(p->header[0]);
+	if (tcode == TCODE_LOCK_REQUEST)
+		tcode = 0x10 + HEADER_GET_EXTENDED_TCODE(p->header[3]);
 
 	spin_lock_irqsave(&address_handler_lock, flags);
 	handler = lookup_enclosing_address_handler(&address_handler_list,

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

