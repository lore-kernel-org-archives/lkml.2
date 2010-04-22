Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0DVUR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:17:59 -0400
Received: from kroah.org ([198.145.64.141]:59797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab0DVUAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:45 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:12 2010
Message-Id: <20100422195412.048276476@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [072/139] x86/amd-iommu: Pt mode fix for domain_destroy
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 04e856c072b84042bb56c487c2868638bb3f78db upstream.

After a guest is shutdown, assigned devices are not properly
returned to the pt domain.  This can leave the device using
stale cached IOMMU data, and result in a non-functional
device after it's re-bound to the host driver.  For example,
I see this upon rebinding:

 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8000 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8040 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8080 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a80c0 flags=0x0050]
 0000:02:00.0: eth2: Detected Hardware Unit Hang:
 ...

The amd_iommu_destroy_domain() function calls do_detach()
which doesn't reattach the pt domain to the device.
Use __detach_device() instead.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2298,7 +2298,7 @@ static void cleanup_domain(struct protec
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
 		struct device *dev = dev_data->dev;
 
-		do_detach(dev);
+		__detach_device(dev);
 		atomic_set(&dev_data->bind, 0);
 	}
 


