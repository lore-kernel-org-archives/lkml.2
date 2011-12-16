Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab1LPTvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:51:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab1LPTuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:01 2011
Message-Id: <20111216194601.431539642@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [45/53] ext4: handle EOF correctly in ext4_bio_write_page()
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit 5a0dc7365c240795bf190766eba7a27600be3b3e upstream.

We need to zero out part of a page which beyond EOF before setting uptodate,
otherwise, mapread or write will see non-zero data beyond EOF.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/page-io.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -401,6 +401,18 @@ int ext4_bio_write_page(struct ext4_io_s
 
 		block_end = block_start + blocksize;
 		if (block_start >= len) {
+			/*
+			 * Comments copied from block_write_full_page_endio:
+			 *
+			 * The page straddles i_size.  It must be zeroed out on
+			 * each and every writepage invocation because it may
+			 * be mmapped.  "A file is mapped in multiples of the
+			 * page size.  For a file that is not a multiple of
+			 * the  page size, the remaining memory is zeroed when
+			 * mapped, and writes to that region are not written
+			 * out to the file."
+			 */
+			zero_user_segment(page, block_start, block_end);
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;


