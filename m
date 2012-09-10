Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2IJT46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:56:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17194 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2IJT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Subject: [PATCH] Xen-SWIOTLB fixes (v4) for v3.7
Date: Mon, 10 Sep 2012 15:45:57 -0400
Message-Id: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original problem was:
<begin>
"if one boots a PV 64-bit guests with more than 4GB, the SWIOTLB [Xen]
gets turned on - and 64MB of precious low-memory gets used." was totally
bogus. The SWIOTLB that gets turned on is the *native* one - which does
not exhaust any low-memory of the host. But it does eat up perfectly
fine 64MB of the guest and never gets used.

So this patchset has some things I wanted to do for some time:
 [PATCH 01/10] xen/swiotlb: Simplify the logic.

Just so that next time I am not confused.

 [PATCH 02/10] xen/swiotlb: With more than 4GB on 64-bit, disable the

and don't turn the *native* SWIOTLB on PV guests and waste those 64MB.
<end>


The rest are  exciting new patches - basically I want to emulate what
IA64 does which is to turn on the SWIOTLB late in the bootup cycle.
This means not using the alloc_bootmem and having a "late" variant
to initialize SWIOTLB. There is some surgery in the SWIOTLB library:
 [PATCH 03/10] swiotlb: add the late swiotlb initialization function

to allow it to use an io_tlb passed in. Note: I hadn't tested this
on IA64 and that is something I need to do.

And then the implementation in the Xen-SWIOTLB to use it:
 [PATCH 06/10] xen/swiotlb: Use the swiotlb_late_init_with_tbl to
along with Xen PCI frontend to utilize it.
 [PATCH 07/10] xen/pcifront: Use Xen-SWIOTLB when initting if

The end result is that a PV guest can now dynamically(*) deal with
PCI passthrough cards. I say "dynamically" b/c if one boots a PV guest
with more than 3GB without using 'e820_hole' (or is it called 'e820_host'
now?) the PCI subsystem won't be able to squeeze the BARs as they
are RAM occupied. The workaround is to boot with 'e820_hole' or some
new work where we manipulate at boot time the E820 to leave a nice
big 1GB hole under 4G - and with all the work on the P2M tree that
should be fairly easy actually.

Note: If one uses 'iommu=soft' on the Linux command line, the Xen-SWIOTLB
still gets turned on.
