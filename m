Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0LUVjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:39:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25209 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0LUViK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [RFC PATCH v1] Consider void entries in the P2M as 1-1 mapping.
Date: Tue, 21 Dec 2010 16:37:30 -0500
Message-Id: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see attached an RFC of first set of patches that augments
how Xen MMU deals with PFNs that point to physical devices.

Short summary: No need to troll through code to add VM_IO on mmap paths
anymore.

Long summary:
Under Xen MMU we would distinguish two different types of PFNs in
the P2M tree: real MFN, INVALID_P2M_ENTRY (missing PFN - used for ballooning).
If there was a device which PCI BAR was within the P2M, we would look
at the flags and if _PAGE_IOMAP was passed we would just return the PFN without
consulting the P2M. We have a patch (and some auxilary for other subsystems)
that sets this:
 x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas

This patchset proposes a different way of doing this where the patch
above and the other auxilary ones will not be neccessary.

This different is the one that H. Peter Anvin and Jeremy Fitzhardinge
suggested. The mechanism is to think of the void entries (so not filled) in the
P2M tree structure as identity (1-1) mapping. In the past we used to think of
those regions as "missing" and under the ownership of the balloon code. But
the balloon code only operates on a specific region. This region is in last
E820 RAM page (basically any region past nr_pages is considered balloon
type page).

Gaps in the E820 (which are usually considered to PCI BAR spaces) would end up
with the void entries and point to the "missing" pages.

This patchset considers the void entries as "identity" and for balloon pages
you have to set the PFNs to be "missing". This means that the void entries
are now considered 1-1, so for PFNs which exist in large gaps of the P2M space
will return the same PFN. Since the E820 gaps could cross boundary (keep in
mind that the P2M structure is a 3-level tree) in the P2M regions we go
through the E820 gaps and reserved E820 regions and set those to be
identity. For large regions we just hook up the top (or middle) pointer
to shared "identity" pages. For smaller regions we set the MFN wherein
pfn_to_mfn(pfn)==pfn.

For the case of the balloon pages, the setting of the "missing" pages
is mostly already done. The initial case of carving the last E820 region for
balloon ownership is augmented to set those PFNs to missing.


This patchset is also available under git:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/p2m-identity

Further work:
The xen/mmu.c code where it deals with _PAGE_IOMAP can be removed, but
to guard against regressions or bugs lets take it one patchset at a time.

Also filter out _PAGE_IOMAP on entries that are System RAM (which is wrong).
With this P2M to lookup we can make this determination easily.

P.S.
You might wonder why the IDENTITY_P2M_ENTRY value is not used when writting
to the P2M, but only used as flag. That is b/c the toolset does not consider
that value to be correct so instead we use the INVALID_P2M_ENTRY.
In-Reply-To: 

