Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936207Ab1KJD6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:58:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965965Ab1KJDrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213206.449167598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [238/264] powerpc: Fix deadlock in icswx code
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 8bdafa39a47265bc029838b35cc6585f69224afa upstream.

The icswx code introduced an A-B B-A deadlock:

     CPU0                    CPU1
     ----                    ----
lock(&anon_vma->mutex);
                             lock(&mm->mmap_sem);
                             lock(&anon_vma->mutex);
lock(&mm->mmap_sem);

Instead of using the mmap_sem to keep mm_users constant, take the
page table spinlock.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/mmu_context_hash64.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/mm/mmu_context_hash64.c
+++ b/arch/powerpc/mm/mmu_context_hash64.c
@@ -136,8 +136,8 @@ int use_cop(unsigned long acop, struct m
 	if (!mm || !acop)
 		return -EINVAL;
 
-	/* We need to make sure mm_users doesn't change */
-	down_read(&mm->mmap_sem);
+	/* The page_table_lock ensures mm_users won't change under us */
+	spin_lock(&mm->page_table_lock);
 	spin_lock(mm->context.cop_lockp);
 
 	if (mm->context.cop_pid == COP_PID_NONE) {
@@ -164,7 +164,7 @@ int use_cop(unsigned long acop, struct m
 
 out:
 	spin_unlock(mm->context.cop_lockp);
-	up_read(&mm->mmap_sem);
+	spin_unlock(&mm->page_table_lock);
 
 	return ret;
 }
@@ -185,8 +185,8 @@ void drop_cop(unsigned long acop, struct
 	if (WARN_ON_ONCE(!mm))
 		return;
 
-	/* We need to make sure mm_users doesn't change */
-	down_read(&mm->mmap_sem);
+	/* The page_table_lock ensures mm_users won't change under us */
+	spin_lock(&mm->page_table_lock);
 	spin_lock(mm->context.cop_lockp);
 
 	mm->context.acop &= ~acop;
@@ -213,7 +213,7 @@ void drop_cop(unsigned long acop, struct
 	}
 
 	spin_unlock(mm->context.cop_lockp);
-	up_read(&mm->mmap_sem);
+	spin_unlock(&mm->page_table_lock);
 }
 EXPORT_SYMBOL_GPL(drop_cop);
 


