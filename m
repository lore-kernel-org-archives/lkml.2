Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2LCOrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:47:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932322Ab2LCOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:35 -0500
Message-Id: <20121203143155.027542931@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Michel Lespinasse <walken@google.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 54/89] [PARISC] fix virtual aliasing issue in get_shared_area()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 949a05d03490e39e773e8652ccab9157e6f595b4 upstream.

On Thu, 2012-11-01 at 16:45 -0700, Michel Lespinasse wrote:
> Looking at the arch/parisc/kernel/sys_parisc.c implementation of
> get_shared_area(), I do have a concern though. The function basically
> ignores the pgoff argument, so that if one creates a shared mapping of
> pages 0-N of a file, and then a separate shared mapping of pages 1-N
> of that same file, both will have the same cache offset for their
> starting address.
>
> This looks like this would create obvious aliasing issues. Am I
> misreading this ? I can't understand how this could work good enough
> to be undetected, so there must be something I'm missing here ???

This turns out to be correct and we need to pay attention to the pgoff as
well as the address when creating the virtual address for the area.
Fortunately, the bug is rarely triggered as most applications which use pgoff
tend to use large values (git being the primary one, and it uses pgoff in
multiples of 16MB) which are larger than our cache coherency modulus, so the
problem isn't often seen in practise.

Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/kernel/sys_parisc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 7426e40..f76c108 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -73,6 +73,8 @@ static unsigned long get_shared_area(struct address_space *mapping,
 	struct vm_area_struct *vma;
 	int offset = mapping ? get_offset(mapping) : 0;
 
+	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+
 	addr = DCACHE_ALIGN(addr - offset) + offset;
 
 	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {


