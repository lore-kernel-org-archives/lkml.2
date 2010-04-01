Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0DAALS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:11:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27652 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0DAALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:11:17 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADeBs0urR7Ht/2dsb2JhbACDEpgocZwMiEOQVIErgmtqBIMj
X-IronPort-AV: E=Sophos;i="4.51,344,1267401600"; 
   d="scan'208";a="506391334"
From: Tom Lyon <pugs@lyon-about.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Wed, 31 Mar 2010 17:08:38 -0700
User-Agent: KMail/1.9.9
Cc: mst@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003311708.38961.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uio_pci_generic has previously been discussed on the KVM list, but this patch 
has nothing to do with KVM, so it is also going to LKML.

The point of this patch is to beef up the uio_pci_generic driver so that a 
non-privileged user process can run a user level driver for most PCIe 
devices. This can only be safe if there is an IOMMU in the system with 
per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if there is 
no IOMMU.

Specifically, I seek to allow low-latency user level network drivers (non 
tcp/ip) which directly access SR-IOV style virtual network adapters, for use 
with packages such as OpenMPI.

Key areas of change:
- ioctl extensions to allow registration and dma mapping of memory regions, 
with lock accounting
- support for mmu notifier driven de-mapping
- support for MSI and MSI-X interrupts (the intel 82599 VFs support only 
MSI-X)
- allowing interrupt enabling and device register mapping all 
through /dev/uio* so that  permissions may be granted just by chmod 
on /dev/uio*
