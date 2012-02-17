Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab2BQBCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:02:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58885 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756988Ab2BQBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:28 -0500
X-Sasl-enc: U8+/rhbJTe+YeOu9PgcrwVVsw6s363OUUtkFWYiHZh7H 1329440427
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:34 2012
Message-Id: <20120217005534.217306619@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ahern <daahern@cisco.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Robert E Garrett <robertX.e.garrett@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [01/28] ixgbe: fix vf lookup
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Rose <gregory.v.rose@intel.com>

commit a4b08329c74985e5cc3a44b6d2b2c59444ed8079 upstream.

Recent addition of code to find already allocated VFs failed to take
account that systems with 2 or more multi-port SR-IOV capable controllers
might have already enabled VFs.  Make sure that the VFs the function is
finding are actually subordinate to the particular instance of the adapter
that is looking for them and not subordinate to some device that has
previously enabled SR-IOV.

This bug exists in 3.2 stable as well as 3.3 release candidates.

Reported-by: David Ahern <daahern@cisco.com>
Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Tested-by: Robert E Garrett <robertX.e.garrett@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -67,7 +67,8 @@ static int ixgbe_find_enabled_vfs(struct
 	vf_devfn = pdev->devfn + 0x80;
 	pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID, device_id, NULL);
 	while (pvfdev) {
-		if (pvfdev->devfn == vf_devfn)
+		if (pvfdev->devfn == vf_devfn &&
+		    (pvfdev->bus->number >= pdev->bus->number))
 			vfs_found++;
 		vf_devfn += 2;
 		pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID,


