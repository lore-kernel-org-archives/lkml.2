Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0LABbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:31:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab0LABbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:31:48 -0500
Message-ID: <4CF5A5E5.5040404@cn.fujitsu.com>
Date: Wed, 01 Dec 2010 09:33:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] btrfs: Correct printing of sector_t
References: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 09:31:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 09:31:58
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> If CONFIG_LBDAF=y, `sector_t' becomes `u64' instead of `unsigned long':
> 
> fs/btrfs/inode.c: In function ¡btrfs_end_dio_bio¢:
> fs/btrfs/inode.c:5717: warning: format ¡%lu¢ expects type ¡long unsigned int¢, but argument 4 has type ¡sector_t¢
> 
> Hence always cast it to `unsigned long long' for printing.
> 
> Introduced by commit e65e1535542931e51189832264cd282e5899e4b9 ("btrfs: fix
> panic caused by direct IO")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

While we are at this..

===================

[PATCH] btrfs: Fix compile warning when CONFIG_MIGRATION is not set

Fix this newly introduced warning:

fs/btrfs/disk-io.c:699: warning: 'btree_migratepage' defined but not used

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 33b6d45..7648247 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -696,6 +696,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 				   __btree_submit_bio_done);
 }
 
+#ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page)
 {
@@ -712,12 +713,10 @@ static int btree_migratepage(struct address_space *mapping,
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-#ifdef CONFIG_MIGRATION
+
 	return migrate_page(mapping, newpage, page);
-#else
-	return -ENOSYS;
-#endif
 }
+#endif
 
 static int btree_writepage(struct page *page, struct writeback_control *wbc)
 {
-- 
1.6.3

