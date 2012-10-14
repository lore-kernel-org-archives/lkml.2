Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2JNOpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:45:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46808 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab2JNOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:22 -0400
Message-Id: <20121014143538.018983778@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Donald Dutile <ddutile@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 031/147] intel-iommu: Default to non-coherent for domains unattached to
 iommus
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 2e12bc29fc5a12242d68e11875db3dd58efad9ff upstream.

domain_update_iommu_coherency() currently defaults to setting domains
as coherent when the domain is not attached to any iommus.  This
allows for a window in domain_context_mapping_one() where such a
domain can update context entries non-coherently, and only after
update the domain capability to clear iommu_coherency.

This can be seen using KVM device assignment on VT-d systems that
do not support coherency in the ecap register.  When a device is
added to a guest, a domain is created (iommu_coherency = 0), the
device is attached, and ranges are mapped.  If we then hot unplug
the device, the coherency is updated and set to the default (1)
since no iommus are attached to the domain.  A subsequent attach
of a device makes use of the same dmar domain (now marked coherent)
updates context entries with coherency enabled, and only disables
coherency as the last step in the process.

To fix this, switch domain_update_iommu_coherency() to use the
safer, non-coherent default for domains not attached to iommus.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[bwh: Backported to 3.2: dmar_domain::iommu_bmp is a single unsigned long
 not an array, so add &]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -563,7 +563,9 @@ static void domain_update_iommu_coherenc
 {
 	int i;
 
-	domain->iommu_coherency = 1;
+	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+
+	domain->iommu_coherency = i < g_num_of_iommus ? 1 : 0;
 
 	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {


