Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab2BJWuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab2BJWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:33 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.790694638@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Wang <liwang@nudt.edu.cn>,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [11/21] eCryptfs: Infinite loop due to overflow in ecryptfs_write()
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -134,7 +134,7 @@ int ecryptfs_write(struct file *ecryptfs
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
 		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (fatal_signal_pending(current)) {
 			rc = -EINTR;
@@ -145,7 +145,7 @@ int ecryptfs_write(struct file *ecryptfs
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
 			/* remaining zeros to write, up to destination offset */
-			size_t total_remaining_zeros = (offset - pos);
+			loff_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;


