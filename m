Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2FNX7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2FNX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:34 -0400
Message-Id: <20120614235625.252160757@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: [ 15/42] Btrfs: fall back to non-inline if we dont have enough space
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 2adcac1a7331d93a17285804819caa96070b231f upstream.

If cow_file_range_inline fails with ENOSPC we abort the transaction which
isn't very nice.  This really shouldn't be happening anyways but there's no
sense in making it a horrible error when we can easily just go allocate
normal data space for this stuff.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Acked-by: Chris Mason <chris.mason@fusionio.com>
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -257,10 +257,13 @@ static noinline int cow_file_range_inlin
 	ret = insert_inline_extent(trans, root, inode, start,
 				   inline_len, compressed_size,
 				   compress_type, compressed_pages);
-	if (ret) {
+	if (ret && ret != -ENOSPC) {
 		btrfs_abort_transaction(trans, root, ret);
 		return ret;
+	} else if (ret == -ENOSPC) {
+		return 1;
 	}
+
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;


