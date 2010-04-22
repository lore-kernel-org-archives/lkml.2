Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0DVTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:49:30 -0400
Received: from kroah.org ([198.145.64.141]:41042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab0DVT2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:55 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190916.931886465@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [107/197] x86/amd-iommu: enable iommu before attaching devices
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 75f66533bc883f761a7adcab3281fe3323efbc90 upstream.

Hit another kdump problem as reported by Neil Horman.  When initializaing
the IOMMU, we attach devices to their domains before the IOMMU is
fully (re)initialized.  Attaching a device will issue some important
invalidations.  In the context of the newly kexec'd kdump kernel, the
IOMMU may have stale cached data from the original kernel.  Because we
do the attach too early, the invalidation commands are placed in the new
command buffer before the IOMMU is updated w/ that buffer.  This leaves
the stale entries in the kdump context and can renders device unusable.
Simply enable the IOMMU before we do the attach.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1284,6 +1284,8 @@ int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	enable_iommus();
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1294,8 +1296,6 @@ int __init amd_iommu_init(void)
 
 	amd_iommu_init_api();
 
-	enable_iommus();
-
 	if (iommu_pass_through)
 		goto out;
 
@@ -1314,6 +1314,8 @@ out:
 	return ret;
 
 free:
+	disable_iommus();
+
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
 		   get_order(MAX_DOMAIN_ID/8));
 


