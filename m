Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab2EJRdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217Ab2EJRdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:36 -0400
Message-Id: <20120510173133.337962395@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 04/52] xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit b7e5ffe5d83fa40d702976d77452004abbe35791 upstream.

If I try to do "cat /sys/kernel/debug/kernel_page_tables"
I end up with:

BUG: unable to handle kernel paging request at ffffc7fffffff000
IP: [<ffffffff8106aa51>] ptdump_show+0x221/0x480
PGD 0
Oops: 0000 [#1] SMP
CPU 0
.. snip..
RAX: 0000000000000000 RBX: ffffc00000000fff RCX: 0000000000000000
RDX: 0000800000000000 RSI: 0000000000000000 RDI: ffffc7fffffff000

which is due to the fact we are trying to access a PFN that is not
accessible to us. The reason (at least in this case) was that
PGD[256] is set to __HYPERVISOR_VIRT_START which was setup (by the
hypervisor) to point to a read-only linear map of the MFN->PFN array.
During our parsing we would get the MFN (a valid one), try to look
it up in the MFN->PFN tree and find it invalid and return ~0 as PFN.
Then pte_mfn_to_pfn would happilly feed that in, attach the flags
and return it back to the caller. 'ptdump_show' bitshifts it and
gets and invalid value that it tries to dereference.

Instead of doing all of that, we detect the ~0 case and just
return !_PAGE_PRESENT.

This bug has been in existence .. at least until 2.6.37 (yikes!)

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/mmu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -353,8 +353,13 @@ static pteval_t pte_mfn_to_pfn(pteval_t
 {
 	if (val & _PAGE_PRESENT) {
 		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		unsigned long pfn = mfn_to_pfn(mfn);
+
 		pteval_t flags = val & PTE_FLAGS_MASK;
-		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+		if (unlikely(pfn == ~0))
+			val = flags & ~_PAGE_PRESENT;
+		else
+			val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
 	}
 
 	return val;


