Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2FXPDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2FXPD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:03:27 -0400
Date: Sun, 24 Jun 2012 17:01:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] uprobes: __replace_page() needs munlock_vma_page()
Message-ID: <20120624150111.GE23277@redhat.com>
References: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624145936.GA23269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like do_wp_page(), __replace_page() should do munlock_vma_page()
for the case when the old page still has other !VM_LOCKED mappings.
Unfortunately this needs mm/internal.h.

Also, move put_page() outside of ptl lock. This doesn't really
matter but looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5db150b..889c62b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
+#include "../../mm/internal.h"	/* munlock_vma_page */
 
 #include <linux/uprobes.h>
 
@@ -141,7 +142,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	pte_t *ptep;
 	int err;
 
-	/* freeze PageSwapCache() for try_to_free_swap() below */
+	/* For try_to_free_swap() and munlock_vma_page() below */
 	lock_page(page);
 
 	err = -EAGAIN;
@@ -164,9 +165,12 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	page_remove_rmap(page);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
-	put_page(page);
 	pte_unmap_unlock(ptep, ptl);
 
+	if (vma->vm_flags & VM_LOCKED)
+		munlock_vma_page(page);
+	put_page(page);
+
 	err = 0;
  unlock:
 	unlock_page(page);
-- 
1.5.5.1


