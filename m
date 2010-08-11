Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0HKX5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:57:25 -0400
Received: from kroah.org ([198.145.64.141]:39995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab0HKX5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:23 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:55 2010
Message-Id: <20100811235455.701557457@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [001/111] ata_piix: fix locking around SIDPR access
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 213373cf974fe69e78ec894b07f45ae2f5a3a078 upstream.

SIDPR window registers are shared across ports and as each access is
done in two steps, accesses to different ports under EH may race.
This primarily is caused by incorrect host locking in EH context and
should be fixed by defining locking requirements for each EH operation
which can be used during EH and enforcing them but for now work around
the problem by adding a dedicated SIDPR lock and grabbing it for each
SIDPR access.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mark Knecht <markknecht@gmail.com>
Reported-by: Paul Check <paul@thechecks.ca>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -157,6 +157,7 @@ struct piix_map_db {
 struct piix_host_priv {
 	const int *map;
 	u32 saved_iocfg;
+	spinlock_t sidpr_lock;	/* FIXME: remove once locking in EH is fixed */
 	void __iomem *sidpr;
 };
 
@@ -948,12 +949,15 @@ static int piix_sidpr_scr_read(struct at
 			       unsigned int reg, u32 *val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -961,12 +965,15 @@ static int piix_sidpr_scr_write(struct a
 				unsigned int reg, u32 val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -1555,6 +1562,7 @@ static int __devinit piix_init_one(struc
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
+	spin_lock_init(&hpriv->sidpr_lock);
 
 	/* Save IOCFG, this will be used for cable detection, quirk
 	 * detection and restoration on detach.  This is necessary


