Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2GaOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:09:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46676 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2GaOJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:09:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        JBeulich@suse.com
Subject: [PATCH] Xen-SWIOTLB fixes (v2) for 3.7
Date: Tue, 31 Jul 2012 10:00:18 -0400
Message-Id: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original problem I mentioned in the above mentioned URL:
"if one boots a PV 64-bit guests with more than 4GB, the SWIOTLB [Xen]
gets turned on - and 64MB of precious low-memory gets used." was totally
bogus. The SWIOTLB that gets turned on is the *native* one - which does
not exhaust any low-memory of the host. But it does eat up perfectly
fine 64MB of the guest and never gets used.

So this patchset has some things I wanted to do for some time:
 [PATCH 1/5] xen/swiotlb: Simplify the logic.

Just so that next time I am not confused.
 [PATCH 2/5] xen/swiotlb: With more than 4GB on 64-bit, disable the

and don't turn the *native* SWIOTLB on PV guests and waste those 64MB.

Here are the exciting new patches - basically I want to emulate what
IA64 does which is to turn on the SWIOTLB late in the bootup cycle.
This means not using the alloc_bootmem and having a "late" variant
to initialize SWIOTLB. There is some surgery in the SWIOTLB library:
 [PATCH 3/5] swiotlb: add the late swiotlb initialization function

to allow it to use an io_tlb passed in. Note: I hadn't tested this
on IA64 and that is something I need to do.

And then the implementation in the Xen-SWIOTLB to use it:
 [PATCH 4/5] xen/swiotlb: Use the swiotlb_late_init_with_tbl to init
along with Xen PCI frontend to utilize it.
 [PATCH 5/5] xen/pcifront: Use Xen-SWIOTLB when initting if required.

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
