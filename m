Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab0JHNx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:53:59 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:41560 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757676Ab0JHNx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:53:57 -0400
X-Greylist: delayed 2005 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2010 09:53:57 EDT
Message-ID: <4CAF2275.7010500@panasas.com>
Date: Fri, 08 Oct 2010 09:53:57 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH 1/2] exofs: Fix double page_unlock BUG in write_begin/end
References: <4CAF1AA1.1090801@panasas.com>
In-Reply-To: <4CAF1AA1.1090801@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2010 13:53:56.0099 (UTC) FILETIME=[3FEECD30:01CB66F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This BUG is there since the first submit of the code, but only triggered
in last Kernel. It's timing related do to the asynchronous object-creation
behaviour of exofs. (Which should be investigated farther)

The bug is obvious hence the fixed.

Signed-off-by: Boaz Harrosh <Boaz Harrosh bharrosh@panasas.com>
---
 fs/exofs/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 2f623ac..1cf2286 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -54,6 +54,9 @@ struct page_collect {
 	unsigned nr_pages;
 	unsigned long length;
 	loff_t pg_first; /* keep 64bit also in 32-arches */
+	bool read_4_write; /* This means two things: that the read is sync
+			    * And the pages should not be unlocked.
+			    */
 };
 
 static void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
@@ -71,6 +74,7 @@ static void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
 	pcol->nr_pages = 0;
 	pcol->length = 0;
 	pcol->pg_first = -1;
+	pcol->read_4_write = false;
 }
 
 static void _pcol_reset(struct page_collect *pcol)
@@ -347,7 +351,8 @@ static int readpage_strip(void *data, struct page *page)
 		if (PageError(page))
 			ClearPageError(page);
 
-		unlock_page(page);
+		if (!pcol->read_4_write)
+			unlock_page(page);
 		EXOFS_DBGMSG("readpage_strip(0x%lx, 0x%lx) empty page,"
 			     " splitting\n", inode->i_ino, page->index);
 
@@ -428,6 +433,7 @@ static int _readpage(struct page *page, bool is_sync)
 	/* readpage_strip might call read_exec(,is_sync==false) at several
 	 * places but not if we have a single page.
 	 */
+	pcol.read_4_write = is_sync;
 	ret = readpage_strip(&pcol, page);
 	if (ret) {
 		EXOFS_ERR("_readpage => %d\n", ret);
-- 
1.7.2

