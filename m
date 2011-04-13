Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab1DMPKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:10:47 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:20501 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756961Ab1DMPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:10:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAG+8pU1Ld/sX/2dsb2JhbAAMhEDUWZEmhHZ4BJQT
X-IronPort-AV: E=Sophos;i="4.64,204,1301889600"; 
   d="scan'208";a="106264144"
Message-ID: <4DA5BCF3.5080205@teksavvy.com>
Date: Wed, 13 Apr 2011 11:10:43 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <4D9FACC9.7020200@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
Content-Type: multipart/mixed;
 boundary="------------070402090709050506040303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070402090709050506040303
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11-04-12 06:30 AM, Bruce Stenning wrote:
..
> I am currently inserting tracing into 2.6.38.2 to try to work out what is going
> on.  From mv_write_main_irq_mask I can see that the IRQ for each port is still
> enabled, even when ports stop responding.
..
> One thing I noticed was that there is no spinlock around the
> mv_save_cached_regs/mv_edma_cfg in mv_hardreset (unlike mv_port_start and
> mv_port_stop); why is this?

Yeah, I'm suspecting there's a loophole in the logic there somewhere.

I dusted off the 6041 reference card I have here, and played with the cables
for a while.  Managed to get one port to stop responding to hot plug fairly
quickly, though I'm not sure how/why.

Then I added a debug printk() to mv_write_main_irq_mask(),
with no other changes, and that appears to have been enough
to change the race timing so that I could no longer produce
the problem.

Bruce, here's a slightly-ugly patch that should remove all
doubt about races in the irq_mask.  Please apply it, test with it,
and let me know here if the issue goes away.

Thanks

--- old/drivers/ata/sata_mv.c	2011-04-13 11:03:07.442481426 -0400
+++ linux/drivers/ata/sata_mv.c	2011-04-13 11:07:55.224249621 -0400
@@ -1027,15 +1027,19 @@
 static void mv_set_main_irq_mask(struct ata_host *host,
 				 u32 disable_bits, u32 enable_bits)
 {
+	static spinlock_t irq_mask_lock = __SPIN_LOCK_UNLOCKED(irq_mask_lock); //
FIXME: per-host would be nicer
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 old_mask, new_mask;
+	unsigned long flags;

+	spin_lock_irqsave(&irq_mask_lock, flags);
 	old_mask = hpriv->main_irq_mask;
 	new_mask = (old_mask & ~disable_bits) | enable_bits;
 	if (new_mask != old_mask) {
 		hpriv->main_irq_mask = new_mask;
 		mv_write_main_irq_mask(new_mask, hpriv);
 	}
+	spin_unlock_irqrestore(&irq_mask_lock, flags);
 }

 static void mv_enable_port_irqs(struct ata_port *ap,

--------------070402090709050506040303
Content-Type: text/x-patch;
 name="sata_mv_irq_mask_lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sata_mv_irq_mask_lock.patch"

--- old/drivers/ata/sata_mv.c	2011-04-13 11:03:07.442481426 -0400
+++ linux/drivers/ata/sata_mv.c	2011-04-13 11:07:55.224249621 -0400
@@ -1027,15 +1027,19 @@
 static void mv_set_main_irq_mask(struct ata_host *host,
 				 u32 disable_bits, u32 enable_bits)
 {
+	static spinlock_t irq_mask_lock = __SPIN_LOCK_UNLOCKED(irq_mask_lock); // FIXME: per-host would be nicer
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 old_mask, new_mask;
+	unsigned long flags;
 
+	spin_lock_irqsave(&irq_mask_lock, flags);
 	old_mask = hpriv->main_irq_mask;
 	new_mask = (old_mask & ~disable_bits) | enable_bits;
 	if (new_mask != old_mask) {
 		hpriv->main_irq_mask = new_mask;
 		mv_write_main_irq_mask(new_mask, hpriv);
 	}
+	spin_unlock_irqrestore(&irq_mask_lock, flags);
 }
 
 static void mv_enable_port_irqs(struct ata_port *ap,

--------------070402090709050506040303--
