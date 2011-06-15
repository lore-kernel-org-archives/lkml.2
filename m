Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1FPHAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52769 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab1FPHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:08 -0400
X-Sasl-enc: gS+uQQ5beFNNUxNtXKJpp2UxUBkUGzEwVxxRaOfqhbt3 1308207607
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.482757566@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Travis <travis@sgi.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [05/89] intel-iommu: Speed up processing of the identity_mapping
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 function

From: Mike Travis <travis@sgi.com>

commit cb452a4040bb051d92e85d6e7eb60c11734c1781 upstream.

When there are a large count of PCI devices, and the pass through
option for iommu is set, much time is spent in the identity_mapping
function hunting though the iommu domains to check if a specific
device is "identity mapped".

Speed up the function by checking the cached info to see if
it's mapped to the static identity domain.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2109,10 +2109,10 @@ static int identity_mapping(struct pci_d
 	if (likely(!iommu_identity_mapping))
 		return 0;
 
+	info = pdev->dev.archdata.iommu;
+	if (info && info != DUMMY_DEVICE_DOMAIN_INFO)
+		return (info->domain == si_domain);
 
-	list_for_each_entry(info, &si_domain->devices, link)
-		if (info->dev == pdev)
-			return 1;
 	return 0;
 }
 


