Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0HRPIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:08:46 -0400
Received: from kroah.org ([198.145.64.141]:47468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab0HRPHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:07:36 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 08:05:57 2010
Message-Id: <20100818150557.276273181@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 08:01:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [2/6] mm: fix missing page table unmap for stack guard page failure case
In-Reply-To: <20100818150615.GA4752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5528f9132cf65d4d892bcbc5684c61e7822b21e9 upstream.

.. which didn't show up in my tests because it's a no-op on x86-64 and
most other architectures.  But we enter the function with the last-level
page table mapped, and should unmap it at exit.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2428,8 +2428,10 @@ static int do_anonymous_page(struct mm_s
 	spinlock_t *ptl;
 	pte_t entry;
 
-	if (check_stack_guard_page(vma, address) < 0)
+	if (check_stack_guard_page(vma, address) < 0) {
+		pte_unmap(page_table);
 		return VM_FAULT_SIGBUS;
+	}
 
 	/* Allocate our own private page. */
 	pte_unmap(page_table);


