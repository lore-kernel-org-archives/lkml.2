Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0IGTdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:33:50 -0400
Received: from ns2.cypress.com ([157.95.67.5]:40863 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925Ab0IGTdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:33:47 -0400
Subject: Re: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge
 related
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: dhowells@redhat.com
Cc: linux-cachefs@redhat.com, greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Tue, 07 Sep 2010 12:33:31 -0700
Message-Id: <1283888011.7250.17.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mpage_cleardirty function to the cachefiles implementation in the kernel.
The purpose behind this patch is to allow for file based DMA through an external DMA engine
without the data ever going through the process. The procedure for the usage of this function 
is as follows:
1) User space allocates and maps a file
2) external DMA device transfers the data to non-volatile storage directly without it going through 
   the processor
3) the "dirty" pages must be cleared and invalidated as they do not contain correct information.

I believe that David is the correct maintainer and am hoping that he is willing to ACK this change. Please let me know 
if there are any issues or concerns with this patch or if I should be
asking a different maintainer to ack.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/fs/mpage.c linux-next-incl-sdk/fs/mpage.c
--- linux-next-vanilla/fs/mpage.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/fs/mpage.c	2010-09-07 11:52:39.000000000 -0700
@@ -716,3 +716,50 @@ int mpage_writepage(struct page *page, g
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
+
+int mpage_cleardirty(struct address_space *mapping, int num_pages)
+{
+	int ret = 0;
+	int nr_pages;
+	struct pagevec pvec;
+	pgoff_t index = 0;
+	pgoff_t end;
+
+	pagevec_init(&pvec, 0);
+	index = mapping->writeback_index;
+	end = index + num_pages;
+
+	while ((index <= end) &&
+	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+				PAGECACHE_TAG_DIRTY, min(end - index,
+					(pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+		unsigned i;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			lock_page(page);
+			ret = clear_page_dirty_for_io(page);
+			if (page_has_private(page))
+				do_invalidatepage(page, 0);
+
+			cancel_dirty_page(page, PAGE_CACHE_SIZE);
+
+			remove_from_page_cache(page);
+			ClearPageMappedToDisk(page);
+			page_cache_release(page);	/* pagecache ref */
+			unlock_page(page);
+
+			if (!ret) {
+				printk(KERN_INFO "mpage_cleardirty: "
+				"clear_page_dirty_for_io returned %d\n", ret);
+				return ret;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(mpage_cleardirty);


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

