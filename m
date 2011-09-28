Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1I1DEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:04:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:5155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1I1DEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:04:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57356005"
Subject: [patch]ext4: add block plug for .writepages
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
In-Reply-To: <20110926094554.GA30827@infradead.org>
References: <1317004226.29510.172.camel@sli10-conroe>
	 <20110926073025.GB21079@infradead.org>
	 <1317022727.29510.175.camel@sli10-conroe>
	 <20110926094554.GA30827@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 11:09:40 +0800
Message-ID: <1317179380.22361.8.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 17:45 +0800, Christoph Hellwig wrote:
> On Mon, Sep 26, 2011 at 03:38:47PM +0800, Shaohua Li wrote:
> > On Mon, 2011-09-26 at 15:30 +0800, Christoph Hellwig wrote:
> > > On Mon, Sep 26, 2011 at 10:30:26AM +0800, Shaohua Li wrote:
> > > > Some filesystems implement .writepages. We don't have blk plug
> > > > in such filesystems for .writepages.
> > > 
> > > Please add the plugging in the actual ->writepages instances.
> > there are several filesystems have ->writepages. Can you share an hint
> > why we don't add plugging in the do_writepages?
> 
> Because do_writepages is completely generic code with no knowledge of
> block I/O.  I really don't want to have block plugging be intimately
> tied into core VM/writeback code all over.  We've been there with
> ->sync_page, and it was a major pain - nevermind the additional (small)
> overhead for the not block based filesystems.
I searched a little bit, looks only ext4 need it. here is the patch.


Add block plug for ext4 .writepages. Though ext4 .writepages
already handles request merge very well, block plug is still
helpful to reduce block lock contention.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/ext4/inode.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/fs/ext4/inode.c
===================================================================
--- linux.orig/fs/ext4/inode.c	2011-09-28 10:13:50.000000000 +0800
+++ linux/fs/ext4/inode.c	2011-09-28 10:23:31.000000000 +0800
@@ -2046,6 +2046,7 @@ static int ext4_da_writepages(struct add
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	pgoff_t done_index = 0;
 	pgoff_t end;
+	struct blk_plug plug;
 
 	trace_ext4_da_writepages(inode, wbc);
 
@@ -2124,6 +2125,7 @@ retry:
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag_pages_for_writeback(mapping, index, end);
 
+	blk_start_plug(&plug);
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2188,6 +2190,7 @@ retry:
 			 */
 			break;
 	}
+	blk_finish_plug(&plug);
 	if (!io_done && !cycled) {
 		cycled = 1;
 		index = 0;


