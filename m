Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0L3TuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:50:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38875 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0L3TuQ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:50:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC v2] Consider E820 non-RAM and E820 gaps as 1-1 mappings.
Date: Thu, 30 Dec 2010 14:48:29 -0500
Message-Id: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see attached an RFC of second set of patches that augments
how Xen MMU deals with PFNs that point to physical devices. This
patchset is still a development type so sharp edges present.

Changelog: [since v1 https://lkml.org/lkml/2010/12/21/255]:
 - Diagrams of P2M included.
 - More conservative approach used (memory that is not populated or 
   identity is considered "missing", instead of as identity).
 - Added IDENTITY_PAGE_FRAME bit to uniquely identify 1-1 mappings.
 - Optional debugfs file (xen/mmu/p2m) to print out the level and types in
   the P2M tree.
 - Lots of comments - if I missed any please prompt me.

Short summary: No need to troll through code to add VM_IO on mmap paths
anymore.

Long summary:
Under Xen MMU we would distinguish two different types of PFNs in
the P2M tree: real MFN, INVALID_P2M_ENTRY (missing PFN - used for ballooning).
If there was a device which PCI BAR was within the P2M, we would look
at the flags and if _PAGE_IOMAP was passed we would just return the PFN without
consulting the P2M. We have a patch (and some auxiliary for other subsystems)
that sets this:
 x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas

This patchset proposes a different way of doing this where the patch
above and the other auxiliary ones will not be necessary.

This approach is the one that H. Peter Anvin, Jeremy Fitzhardinge, Ian Campbell
suggested. The mechanism is to think of the E820 non-RAM entries and E820 gaps
in the P2M tree structure as identity (1-1) mapping.

In the past we used to think of those regions as "missing" and under the ownership
of the balloon code. But the balloon code only operates on a specific region. This
region is in last E820 RAM page (basically any region past nr_pages is considered balloon
type page).

Gaps in the E820 (which are usually considered to PCI BAR spaces) would end up
with the void entries and point to the "missing" pages.

This patchset iterates over the E820 and finds the gaps and non-RAM E820 and
marks them as as "identity".

Since the E820 gaps could cross boundary (keep in mind that the P2M structure
is a 3-level tree) in the P2M regions we go through the E820 gaps and reserved
E820 regions and set those to be identity. For large regions we just hook up
the top (or middle) pointer to shared "identity" pages. For smaller regions
we set the MFN wherein pfn_to_mfn(pfn)==pfn.

The two attached diagrams crudely explain how we are doing this. "P2M story"
(https://docs.google.com/drawings/edit?id=1LQy0np2GCkFtspoucgs5Y_TILI8eceY6rikXwtPqlTI&hl=en&authkey=CO_yv_cC)
is how the P2M is constructed and setup with balloon pages. The "P2M with 1-1.."
(https://docs.google.com/drawings/edit?id=1smqIRPYq2mSxmvpabuk_Ap6bQAW_aaZnOnjzqlcmxKc&hl=en&authkey=CI2iwKcE)
is how we insert the identity mappings in the P2M tree.

For the balloon pages, the setting of the "missing" pages is mostly already done.
The initial case of carving the last E820 region for balloon ownership is augmented
to set those PFNs to missing and we also change the balloon code to be more
aggressive.


This patchset is also available under git:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/p2m-identity.v4.2

Further work:
Also filter out _PAGE_IOMAP on entries that are System RAM (which is wrong).
With this P2M to lookup we can make this determination easily.

P.S.
Along with the devel/ttm.pci-api-v2, I've been able to boot Dom0 on a variety
of PCIe type graphics hardware with X working (G31M, ATI ES1000, GeForce 6150SE,
HD 4350 Radeon, HD 3200 Radeon, GeForce 8600 GT). That test branch is located
at devel/fix-amd-bootup if you are curious.


 arch/x86/include/asm/xen/page.h |    7 +-
 arch/x86/xen/mmu.c              |  222 +++++++++++++++++++++++++++++++++++----
 arch/x86/xen/setup.c            |   46 ++++++++-
 drivers/xen/balloon.c           |    2 +-
 4 files changed, 255 insertions(+), 22 deletions(-)
