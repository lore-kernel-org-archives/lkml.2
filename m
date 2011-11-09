Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab1KJDZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934557Ab1KJDZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:11 2011
Message-Id: <20111109212711.594973914@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [109/262] [S390] memory leak with RCU_TABLE_FREE
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit e73b7fffe487c315fd1a4fa22282e3362b440a06 upstream.

The rcu page table free code uses a couple of bits in the page table
pointer passed to tlb_remove_table to discern the different page table
types. __tlb_remove_table extracts the type with an incorrect mask which
leads to memory leaks. The correct mask is ((FRAG_MASK << 4) | FRAG_MASK).

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/mm/pgtable.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -291,8 +291,9 @@ void page_table_free_rcu(struct mmu_gath
 
 void __tlb_remove_table(void *_table)
 {
-	void *table = (void *)((unsigned long) _table & PAGE_MASK);
-	unsigned type = (unsigned long) _table & ~PAGE_MASK;
+	const unsigned long mask = (FRAG_MASK << 4) | FRAG_MASK;
+	void *table = (void *)((unsigned long) _table & ~mask);
+	unsigned type = (unsigned long) _table & mask;
 
 	if (type)
 		__page_table_free_rcu(table, type);


