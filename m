Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1FPHlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:41:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37178 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964Ab1FPHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:13 -0400
X-Sasl-enc: BnURv0+8GDSN1xiRbtyLxbb8HO9fygGbPsuvGlAjbpsm 1308207613
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.871148895@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Habeck <habeck@sgi.com>, Mike Travis <travis@sgi.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [09/89] intel-iommu: Add domain check in domain_remove_one_dev_info
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Habeck <habeck@sgi.com>

commit 8519dc4401ddf8a5399f979870bbeeadbc111186 upstream.

The comment in domain_remove_one_dev_info() states "No need to compare
PCI domain; it has to be the same". But for the si_domain that isn't
going to be true, as it consists of all the PCI devices that are
identity mapped thus multiple PCI domains can be in si_domain.  The
code needs to validate the PCI domain too.

Signed-off-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3398,8 +3398,8 @@ static void domain_remove_one_dev_info(s
 	spin_lock_irqsave(&device_domain_lock, flags);
 	list_for_each_safe(entry, tmp, &domain->devices) {
 		info = list_entry(entry, struct device_domain_info, link);
-		/* No need to compare PCI domain; it has to be the same */
-		if (info->bus == pdev->bus->number &&
+		if (info->segment == pci_domain_nr(pdev->bus) &&
+		    info->bus == pdev->bus->number &&
 		    info->devfn == pdev->devfn) {
 			list_del(&info->link);
 			list_del(&info->global);


