Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab2K3TfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:35:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:57329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031594Ab2K3StQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michel Lespinasse <walken@google.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 13/37] PARISC: fix virtual aliasing issue in get_shared_area()
Date: Fri, 30 Nov 2012 10:46:00 -0800
Message-Id: <20121130183858.649363838@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/sys_parisc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -73,6 +73,8 @@ static unsigned long get_shared_area(str
 	struct vm_area_struct *vma;
 	int offset = mapping ? get_offset(mapping) : 0;
 
+	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+
 	addr = DCACHE_ALIGN(addr - offset) + offset;
 
 	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {


