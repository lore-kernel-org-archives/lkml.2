Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1EJRNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 13:13:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60652 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1EJRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 13:13:13 -0400
Date: Tue, 10 May 2011 10:12:45 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCH 2/7] fs: block_page_mkwrite should wait for writeback
	to finish
Message-ID: <20110510171245.GF18929@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com> <20110509230334.19566.17603.stgit@elm3c44.beaverton.ibm.com> <20110510124103.GC4402@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510124103.GC4402@quack.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
function to wait for pending writeback before allowing the page to become
writable.  This is needed to stabilize pages during writeback for those two
filesystems.

Slight rework based on Jan Kara's suggestion.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/buffer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..0e7fa16 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2367,8 +2367,10 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			ret = VM_FAULT_OOM;
 		else /* -ENOSPC, -EIO, etc */
 			ret = VM_FAULT_SIGBUS;
-	} else
+	} else {
+		wait_on_page_writeback(page);
 		ret = VM_FAULT_LOCKED;
+	}
 
 out:
 	return ret;
