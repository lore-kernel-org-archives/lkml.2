Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1I1Wnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab1I1WnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.657830411@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [117/244] genirq: Make irq_shutdown() symmetric vs. irq_startup again
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit ed585a651681e822089087b426e6ebfb6d3d9873 upstream.

If an irq_chip provides .irq_shutdown(), but neither of .irq_disable() or
.irq_mask(), free_irq() crashes when jumping to NULL.
Fix this by only trying .irq_disable() and .irq_mask() if there's no
.irq_shutdown() provided.

This revives the symmetry with irq_startup(), which tries .irq_startup(),
.irq_enable(), and irq_unmask(), and makes it consistent with the comment for
irq_chip.irq_shutdown() in <linux/irq.h>, which says:

 * @irq_shutdown:	shut down the interrupt (defaults to ->disable if NULL)

This is also how __free_irq() behaved before the big overhaul, cfr. e.g.
3b56f0585fd4c02d047dc406668cb40159b2d340 ("genirq: Remove bogus conditional"),
where the core interrupt code always overrode .irq_shutdown() to
.irq_disable() if .irq_shutdown() was NULL.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Link: http://lkml.kernel.org/r/1315742394-16036-2-git-send-email-geert@linux-m68k.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -178,7 +178,7 @@ void irq_shutdown(struct irq_desc *desc)
 	desc->depth = 1;
 	if (desc->irq_data.chip->irq_shutdown)
 		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-	if (desc->irq_data.chip->irq_disable)
+	else if (desc->irq_data.chip->irq_disable)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);


