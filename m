Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0G3R5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:15 -0400
Received: from kroah.org ([198.145.64.141]:58643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0G3R4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:42 2010
Message-Id: <20100730175142.813457452@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [100/205] powerpc: Fix logic error in fixup_irqs
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 3cd8519248e9e17d982c6fab0f1a89bca6feb49a upstream.

When SPARSE_IRQ is set, irq_to_desc() can
return NULL. While the code here has a
check for NULL, it's not really correct.
Fix it by separating the check for it.

This fixes CPU hot unplug for me.

Reported-by: Alastair Bridgewater <alastair.bridgewater@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/irq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -294,7 +294,10 @@ void fixup_irqs(cpumask_t map)
 		cpumask_t mask;
 
 		desc = irq_to_desc(irq);
-		if (desc && desc->status & IRQ_PER_CPU)
+		if (!desc)
+			continue;
+
+		if (desc->status & IRQ_PER_CPU)
 			continue;
 
 		cpumask_and(&mask, desc->affinity, &map);


