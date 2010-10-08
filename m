Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0JHOEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:04:53 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:57591 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753391Ab0JHOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:04:51 -0400
Message-ID: <4CAF2503.6090703@panasas.com>
Date: Fri, 08 Oct 2010 10:04:51 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH 2/2] exofs: Cleaup read path in regard with read_for_write
References: <4CAF1AA1.1090801@panasas.com>
In-Reply-To: <4CAF1AA1.1090801@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2010 14:04:50.0250 (UTC) FILETIME=[C5D652A0:01CB66F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Last BUG fix added a flag to the the page_collect structure
to communicate with readpage_strip. This calls for a clean up
removing that flag's reincarnations in the read functions
parameters.

Signed-off-by: Boaz Harrosh <Boaz Harrosh bharrosh@panasas.com>
---
 fs/exofs/inode.c |   34 ++++++++++++++--------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 1cf2286..d339921 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -185,7 +185,7 @@ static void update_write_page(struct page *page, int ret)
 /* Called at the end of reads, to optionally unlock pages and update their
  * status.
  */
-static int __readpages_done(struct page_collect *pcol, bool do_unlock)
+static int __readpages_done(struct page_collect *pcol)
 {
 	int i;
 	u64 resid;
@@ -221,7 +221,7 @@ static int __readpages_done(struct page_collect *pcol, bool do_unlock)
 			  page_stat ? "bad_bytes" : "good_bytes");
 
 		ret = update_read_page(page, page_stat);
-		if (do_unlock)
+		if (!pcol->read_4_write)
 			unlock_page(page);
 		length += PAGE_SIZE;
 	}
@@ -236,7 +236,7 @@ static void readpages_done(struct exofs_io_state *ios, void *p)
 {
 	struct page_collect *pcol = p;
 
-	__readpages_done(pcol, true);
+	__readpages_done(pcol);
 	atomic_dec(&pcol->sbi->s_curr_pending);
 	kfree(pcol);
 }
@@ -257,7 +257,7 @@ static void _unlock_pcol_pages(struct page_collect *pcol, int ret, int rw)
 	}
 }
 
-static int read_exec(struct page_collect *pcol, bool is_sync)
+static int read_exec(struct page_collect *pcol)
 {
 	struct exofs_i_info *oi = exofs_i(pcol->inode);
 	struct exofs_io_state *ios = pcol->ios;
@@ -267,17 +267,14 @@ static int read_exec(struct page_collect *pcol, bool is_sync)
 	if (!pcol->pages)
 		return 0;
 
-	/* see comment in _readpage() about sync reads */
-	WARN_ON(is_sync && (pcol->nr_pages != 1));
-
 	ios->pages = pcol->pages;
 	ios->nr_pages = pcol->nr_pages;
 	ios->length = pcol->length;
 	ios->offset = pcol->pg_first << PAGE_CACHE_SHIFT;
 
-	if (is_sync) {
+	if (pcol->read_4_write) {
 		exofs_oi_read(oi, pcol->ios);
-		return __readpages_done(pcol, false);
+		return __readpages_done(pcol);
 	}
 
 	pcol_copy = kmalloc(sizeof(*pcol_copy), GFP_KERNEL);
@@ -303,7 +300,7 @@ static int read_exec(struct page_collect *pcol, bool is_sync)
 	return 0;
 
 err:
-	if (!is_sync)
+	if (!pcol->read_4_write)
 		_unlock_pcol_pages(pcol, ret, READ);
 
 	pcol_free(pcol);
@@ -356,7 +353,7 @@ static int readpage_strip(void *data, struct page *page)
 		EXOFS_DBGMSG("readpage_strip(0x%lx, 0x%lx) empty page,"
 			     " splitting\n", inode->i_ino, page->index);
 
-		return read_exec(pcol, false);
+		return read_exec(pcol);
 	}
 
 try_again:
@@ -366,7 +363,7 @@ try_again:
 	} else if (unlikely((pcol->pg_first + pcol->nr_pages) !=
 		   page->index)) {
 		/* Discontinuity detected, split the request */
-		ret = read_exec(pcol, false);
+		ret = read_exec(pcol);
 		if (unlikely(ret))
 			goto fail;
 		goto try_again;
@@ -391,7 +388,7 @@ try_again:
 			  page, len, pcol->nr_pages, pcol->length);
 
 		/* split the request, and start again with current page */
-		ret = read_exec(pcol, false);
+		ret = read_exec(pcol);
 		if (unlikely(ret))
 			goto fail;
 
@@ -420,27 +417,24 @@ static int exofs_readpages(struct file *file, struct address_space *mapping,
 		return ret;
 	}
 
-	return read_exec(&pcol, false);
+	return read_exec(&pcol);
 }
 
-static int _readpage(struct page *page, bool is_sync)
+static int _readpage(struct page *page, bool read_4_write)
 {
 	struct page_collect pcol;
 	int ret;
 
 	_pcol_init(&pcol, 1, page->mapping->host);
 
-	/* readpage_strip might call read_exec(,is_sync==false) at several
-	 * places but not if we have a single page.
-	 */
-	pcol.read_4_write = is_sync;
+	pcol.read_4_write = read_4_write;
 	ret = readpage_strip(&pcol, page);
 	if (ret) {
 		EXOFS_ERR("_readpage => %d\n", ret);
 		return ret;
 	}
 
-	return read_exec(&pcol, is_sync);
+	return read_exec(&pcol);
 }
 
 /*
-- 
1.7.2


