Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0DVURr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:17:47 -0400
Received: from kroah.org ([198.145.64.141]:59805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035Ab0DVUAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:47 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:12 2010
Message-Id: <20100422195412.305733741@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [074/139] x86/amd-iommu: enable iommu before attaching devices
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
 arch/x86/kernel/amd_iommu_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1288,6 +1288,8 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	enable_iommus();
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1300,8 +1302,6 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_notifier();
 
-	enable_iommus();
-
 	if (iommu_pass_through)
 		goto out;
 
@@ -1315,6 +1315,7 @@ out:
 	return ret;
 
 free:
+	disable_iommus();
 
 	amd_iommu_uninit_devices();
 


