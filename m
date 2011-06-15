Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1FPHnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:43:04 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59964 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab1FPHAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:03 -0400
X-Sasl-enc: Mz0vkk8hW3K2MN1dJUabOKoP0kqqqaBO0kUY4Uje/iKd 1308207602
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.195142423@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [02/89] intel-iommu: Flush unmaps at domain_exit
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 7b668357810ecb5fdda4418689d50f5d95aea6a8 upstream.

We typically batch unmaps to be lazily flushed out at
regular intervals.  When we destroy a domain, we need
to force a flush of these lazy unmaps to be sure none
reference the domain we're about to free.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=35062
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1416,6 +1416,10 @@ static void domain_exit(struct dmar_doma
 	if (!domain)
 		return;
 
+	/* Flush any lazy unmaps that may reference this domain */
+	if (!intel_iommu_strict)
+		flush_unmaps_timeout(0);
+
 	domain_remove_dev_info(domain);
 	/* destroy iovas */
 	put_iova_domain(&domain->iovad);


