Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1LUBgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:36:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45579 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab1LUBgi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:36:38 -0500
Message-ID: <1324431393.2844.153.camel@deadeye>
Subject: [PATCH 6/8] uio: Pass pointers to virt_to_page(), not integers
From: Ben Hutchings <ben@decadent.org.uk>
To: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:36:33 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
It might be clearer to assign:

	addr = (void *)((unsigned long)idev->info->mem[mi].addr + offset);

since arithmetic on void pointers is weird.  Either way should work though.

Ben.

 drivers/uio/uio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a783d53..1ff7927 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -620,6 +620,7 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;
+	void *addr;
 
 	int mi = uio_find_mem_index(vma);
 	if (mi < 0)
@@ -631,10 +632,11 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
 
+	addr = (void *)(unsigned long)idev->info->mem[mi].addr + offset;
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(idev->info->mem[mi].addr + offset);
+		page = virt_to_page(addr);
 	else
-		page = vmalloc_to_page((void *)(unsigned long)idev->info->mem[mi].addr + offset);
+		page = vmalloc_to_page(addr);
 	get_page(page);
 	vmf->page = page;
 	return 0;
-- 
1.7.7.3



