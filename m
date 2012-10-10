Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2JJWxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53177 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335Ab2JJWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:05 -0400
X-Sasl-enc: OADRrIS33E1FLJDA4w5KpTJHZiWziJ5/4FAVy7Jv0HZn 1349909584
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Donald Dutile <ddutile@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 006/133] intel-iommu: Default to non-coherent for domains unattached to iommus
Date: Thu, 11 Oct 2012 07:50:32 +0900
Message-Id: <20121010224855.594085462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -589,7 +589,9 @@ static void domain_update_iommu_coherenc
 {
 	int i;
 
-	domain->iommu_coherency = 1;
+	i = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
+
+	domain->iommu_coherency = i < g_num_of_iommus ? 1 : 0;
 
 	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {


