Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0G3R3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:29:50 -0400
Received: from kroah.org ([198.145.64.141]:52053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab0G3RTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171510.776261539@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikanth Karthikesan <knikanth@suse.de>, Amit Arora <aarora@in.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [123/165] ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 6d19c42b7cf81c39632b6d4dbc514e8449bcd346 upstream (as of v2.6.34-git13)

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for that.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3607,6 +3607,11 @@ long ext4_fallocate(struct inode *inode,
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (len + offset));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;


