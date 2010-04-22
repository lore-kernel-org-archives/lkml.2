Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0DVUAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:00:13 -0400
Received: from kroah.org ([198.145.64.141]:59622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958Ab0DVUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:07 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:08 2010
Message-Id: <20100422195408.840018528@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [041/139] [S390] s390: disable change bit override
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 6af7eea2aee57b869f34eba0a94ef122fe90fbfd upstream.

commit 6a985c6194017de2c062916ad1cd00dee0302c40
([S390] s390: use change recording override for kernel mapping)
deactivated the change bit recording for the kernel mapping to
improve the performance. This works most of the time, but there
are cases (e.g. kernel runs in home space, futex atomic compare xcmg)
where we modify user memory with the kernel mapping instead of the
user mapping.
Instead of fixing these cases, this patch just deactivates change bit
override to avoid future problems with other kernel code that might
use the kernel mapping for user memory.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/mm/vmem.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -70,12 +70,8 @@ static pte_t __ref *vmem_pte_alloc(void)
 		pte = alloc_bootmem(PTRS_PER_PTE * sizeof(pte_t));
 	if (!pte)
 		return NULL;
-	if (MACHINE_HAS_HPAGE)
-		clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY | _PAGE_CO,
-			    PTRS_PER_PTE * sizeof(pte_t));
-	else
-		clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY,
-			    PTRS_PER_PTE * sizeof(pte_t));
+	clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY,
+		    PTRS_PER_PTE * sizeof(pte_t));
 	return pte;
 }
 
@@ -116,8 +112,7 @@ static int vmem_add_mem(unsigned long st
 		if (MACHINE_HAS_HPAGE && !(address & ~HPAGE_MASK) &&
 		    (address + HPAGE_SIZE <= start + size) &&
 		    (address >= HPAGE_SIZE)) {
-			pte_val(pte) |= _SEGMENT_ENTRY_LARGE |
-					_SEGMENT_ENTRY_CO;
+			pte_val(pte) |= _SEGMENT_ENTRY_LARGE;
 			pmd_val(*pm_dir) = pte_val(pte);
 			address += HPAGE_SIZE - PAGE_SIZE;
 			continue;


