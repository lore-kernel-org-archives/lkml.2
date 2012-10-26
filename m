Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2JZAn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:43:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:52661 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab2JZAGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 02/42] ext4: Avoid underflow in ext4_trim_fs()
Date: Thu, 25 Oct 2012 17:05:10 -0700
Message-Id: <20121026000125.040986206@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 5de35e8d5c02d271c20e18337e01bc20e6ef472e upstream.

Currently if len argument in ext4_trim_fs() is smaller than one block,
the 'end' variable underflow. Avoid that by returning EINVAL if len is
smaller than file system block.

Also remove useless unlikely().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4984,8 +4984,9 @@ int ext4_trim_fs(struct super_block *sb,
 	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 
-	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
-	    unlikely(start >= max_blks))
+	if (minlen > EXT4_CLUSTERS_PER_GROUP(sb) ||
+	    start >= max_blks ||
+	    range->len < sb->s_blocksize)
 		return -EINVAL;
 	if (end >= max_blks)
 		end = max_blks - 1;


