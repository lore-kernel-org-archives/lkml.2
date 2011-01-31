Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1AaXJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22691 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1AaXJO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com
Subject: [PATCH v4] Consider E820 non-RAM and E820 gaps as 1-1 mappings.
Date: Mon, 31 Jan 2011 17:44:25 -0500
Message-Id: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D474112.0173:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing this for 2.6.39.

This series augments how Xen MMU deals with PFNs that point to physical
devices (PCI BARs, and such).

Reason for this: No need to troll through code to add VM_IO on mmap paths
anymore.

Long summary:
Under Xen MMU we would distinguish three different types of PFNs in
the P2M tree: real MFN, INVALID_P2M_ENTRY (missing PFN - used for ballooning)
and foreign MFNs (the one in the guest).

If there was a device which PCI BAR was within the P2M, we would look
at the PTE flags and if the _PAGE_IOMAP was passed we would just return
the PFN without consulting the P2M. We have a patch
(and some auxiliary for other subsystems) that sets this:
 x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas

This patchset proposes a different way of doing this where the patch
above and the other auxiliary ones will not be necessary.

This approach is the one that H. Peter Anvin, Jeremy Fitzhardinge, Ian Campbell
suggested. The mechanism is to think of the E820 non-RAM entries and E820 gaps
in the P2M tree structure as identity (1-1) mapping. Many thanks to Ian Campbell
and Stefano Stabellini for looking in details at the patches and asking quite
difficult questions.

In the past we used to think of those regions as "missing" and under the ownership
of the balloon code. But the balloon code only operates on a specific regions. This
region is in last E820 RAM page (basically any region past nr_pages is considered balloon
type page). [Honesty compels me to say that during run-time the balloon code
could own pages in different regions, but we do not have to worry about that as that 
works OK and we only have to worry about the bootup-case]

Gaps in the E820 (which are usually considered to PCI BAR spaces) would end up
with the void entries and point to the "missing" pages.

This patchset finds the ranges of non-RAM E820 entries and gaps and
marks them as as "identity". So for example, for this E820:

                    1GB                                           2GB
 /-------------------+---------\/----\         /----------\    /---+-----\
 | System RAM        | Sys RAM ||ACPI|         | reserved |    | Sys RAM |
 \-------------------+---------/\----/         \----------/    \---+-----/
                               ^- 1029MB                       ^- 2001MB

The identity range would be from 1029MB to 2001MB.

Since the E820 gaps could cross P2M level boundaries (keep in mind that the
P2M structure is a 3-level tree, first level covers 1GB, next down 4MB,
and then each page) we might have to allocate extra pages to handle those
violators.  For large regions (1GB) we create a
page which holds pointers to a shared "p2m_identity" page. For smaller regions
if necessary we create pages wherein we can mark PFNs as 1-1 mapping, so:
 pfn_to_mfn(pfn)==pfn.

The two attached diagrams crudely explain how we are doing this. "P2M story"
(https://docs.google.com/drawings/edit?id=1LQy0np2GCkFtspoucgs5Y_TILI8eceY6rikXwtPqlTI&hl=en&authkey=CO_yv_cC)
is how the P2M is constructed and setup with balloon pages. The "P2M with 1-1.."
(https://docs.google.com/drawings/edit?id=1smqIRPYq2mSxmvpabuk_Ap6bQAW_aaZnOnjzqlcmxKc&hl=en&authkey=CI2iwKcE)
is how we insert the identity mappings in the P2M tree.

Also, the first patch "xen/mmu: Add the notion of identity (1-1) mapping."
has an exhaustive explanation.

For the balloon pages, the setting of the "missing" pages is mostly already done.
The initial case of carving the last E820 region for balloon ownership is augmented
to set those PFNs to missing and we also change the balloon code to be more
aggressive.

This patchset is also available under git:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/p2m-identity.v4.7

The diffstat:

 arch/x86/include/asm/xen/page.h |   24 ++++-
 arch/x86/xen/Kconfig            |    8 ++
 arch/x86/xen/mmu.c              |   72 +++++++++++++-
 arch/x86/xen/p2m.c              |  202 +++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/setup.c            |  107 ++++++++++++++++++++-
 drivers/xen/balloon.c           |    2 +-
 6 files changed, 400 insertions(+), 15 deletions(-)

And the shortlog:
Konrad Rzeszutek Wilk (10):
      xen: Mark all initial reserved pages for the balloon as INVALID_P2M_ENTRY.
      xen/mmu: Add the notion of identity (1-1) mapping.
      xen/mmu: Set _PAGE_IOMAP if PFN is an identity PFN.
      xen/mmu: BUG_ON when racing to swap middle leaf.
      xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
      xen/setup: Skip over 1st gap after System RAM.
      x86/setup: Consult the raw E820 for zero sized E820 RAM regions.
      xen/debugfs: Add 'p2m' file for printing out the P2M layout.
      xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set.
      xen/m2p: No need to catch exceptions when we know that there is no RAM

Stefano Stabellini (1):
      xen/m2p: Check whether the MFN has IDENTITY_FRAME bit set..


----
Changelog: [since v4, not posted]
 - Fixed corner-cases bugs on machines with swiss-cheese type E820 regions.

[since v3, not posted]
 - Made the passing of identity PFNs much simpler and cleaner.
 - Expanded the commit description.

[since v2 https://lkml.org/lkml/2010/12/30/163]
 - Added Reviewed-by.
 - Squashed some patches together..
 - Replaced p2m_mid_identity with using reserved_brk to allocate top
   identity entries. This protects us from non 1GB boundary conditions.
 - Expanded the commit descriptions.

[since v1 https://lkml.org/lkml/2010/12/21/255]:
 - Diagrams of P2M included.
 - More conservative approach used (memory that is not populated or 
   identity is considered "missing", instead of as identity).
 - Added IDENTITY_PAGE_FRAME bit to uniquely identify 1-1 mappings.
 - Optional debugfs file (xen/mmu/p2m) to print out the level and types in
   the P2M tree.
 - Lots of comments - if I missed any please prompt me.

P.S.
Along with the stable/ttm.pci-api.v4, I've been able to boot Dom0 on a variety
of PCIe type graphics hardware with X working (G31M, ATI ES1000, GeForce 6150SE,
HD 4350 Radeon, HD 3200 Radeon, GeForce 8600 GT). That test branch is located
at #master if you are curious.

