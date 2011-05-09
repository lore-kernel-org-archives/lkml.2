Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1EIXDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:03:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40881 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1EIXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:03:44 -0400
Subject: [PATCH 2/7] fs: block_page_mkwrite should wait for writeback to finish
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Date: Mon, 09 May 2011 16:03:34 -0700
Message-ID: <20110509230334.19566.17603.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
function to wait for pending writeback before allowing the page to become
writable.  This is needed to stabilize pages during writeback for those two
filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..cf9a795 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2361,6 +2361,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
 
+	wait_on_page_writeback(page);
 	if (unlikely(ret)) {
 		unlock_page(page);
 		if (ret == -ENOMEM)

