Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2CLAxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:53:31 -0400
Received: from 1wt.eu ([62.212.114.60]:63120 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2CLAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:49:03 -0400
Message-Id: <20120312004411.523884993@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Wang <liwang@nudt.edu.cn>, Yunchuan Wen <wenyunchuan@kylinos.com.cn>,
        Tyler Hicks <tyhicks@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 05/13] eCryptfs: Infinite loop due to overflow in ecryptfs_write()
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@nudt.edu.cn>

commit 684a3ff7e69acc7c678d1a1394fe9e757993fd34 upstream.

ecryptfs_write() can enter an infinite loop when truncating a file to a
size larger than 4G. This only happens on architectures where size_t is
represented by 32 bits.

This was caused by a size_t overflow due to it incorrectly being used to
store the result of a calculation which uses potentially large values of
type loff_t.

[tyhicks@canonical.com: rewrite subject and commit message]
Signed-off-by: Li Wang <liwang@nudt.edu.cn>
Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/read_write.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 6b78546..0404659 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -134,7 +134,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
 		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (fatal_signal_pending(current)) {
 			rc = -EINTR;
@@ -145,7 +145,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
 			/* remaining zeros to write, up to destination offset */
-			size_t total_remaining_zeros = (offset - pos);
+			loff_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;
-- 
1.7.2.1.45.g54fbc



