Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab0EJXDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:03:31 -0400
Received: from kroah.org ([198.145.64.141]:45294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab0EJW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:22 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.701362816@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Kumar Gala <galak@kernel.crashing.org>, Wufei <fei.wu@windriver.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [70/98] kgdb: dont needlessly skip PAGE_USER test for Fsl booke
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wufei <fei.wu@windriver.com>

commit 56151e753468e34aeb322af4b0309ab727c97d2e upstream.

The bypassing of this test is a leftover from 2.4 vintage
kernels, and is no longer appropriate, or even used by KGDB.
Currently KGDB uses probe_kernel_write() for all access to
memory via the KGDB core, so it can simply be deleted.

This fixes CVE-2010-1446.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Wufei <fei.wu@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/fsl_booke_mmu.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -131,15 +131,10 @@ void settlbcam(int index, unsigned long
 	TLBCAM[index].MAS3 = (phys & PAGE_MASK) | MAS3_SX | MAS3_SR;
 	TLBCAM[index].MAS3 |= ((flags & _PAGE_RW) ? MAS3_SW : 0);
 
-#ifndef CONFIG_KGDB /* want user access for breakpoints */
 	if (flags & _PAGE_USER) {
 	   TLBCAM[index].MAS3 |= MAS3_UX | MAS3_UR;
 	   TLBCAM[index].MAS3 |= ((flags & _PAGE_RW) ? MAS3_UW : 0);
 	}
-#else
-	TLBCAM[index].MAS3 |= MAS3_UX | MAS3_UR;
-	TLBCAM[index].MAS3 |= ((flags & _PAGE_RW) ? MAS3_UW : 0);
-#endif
 
 	tlbcam_addrs[index].start = virt;
 	tlbcam_addrs[index].limit = virt + size - 1;


