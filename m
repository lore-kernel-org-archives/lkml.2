Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1I1XVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:21:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1I1Wlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220134.809357657@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [090/244] iommu/amd: Dont take domain->lock recursivly
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit e33acde91140f1809952d1c135c36feb66a51887 upstream.

The domain_flush_devices() function takes the domain->lock.
But this function is only called from update_domain() which
itself is already called unter the domain->lock. This causes
a deadlock situation when the dma-address-space of a domain
grows larger than 1GB.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -773,14 +773,9 @@ static void domain_flush_complete(struct
 static void domain_flush_devices(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&domain->lock, flags);
 
 	list_for_each_entry(dev_data, &domain->dev_list, list)
 		device_flush_dte(dev_data->dev);
-
-	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
 /****************************************************************************


