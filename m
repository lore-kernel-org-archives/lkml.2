Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1AFAr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:47:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42174 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1AFArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:47:23 -0500
Date: Thu, 6 Jan 2011 11:47:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the nfsd tree with Linus' tree
Message-Id: <20110106114717.32cd3a25.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the nfsd tree got a conflict in
Documentation/filesystems/Locking between commit
b83be6f20a0e468f715b14225c9f897538dfe5ad ("update
Documentation/filesystems/Locking") from Linus' tree and commit
e63eb9375089f9d2041305d04c3f33a194e0e014 ("nfsd4: eliminate lease delete
callback") from the nfsd tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/filesystems/Locking
index 33fa3e5,075be12..0000000
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@@ -337,22 -327,17 +337,20 @@@ fl_release_private:	maybe		n
  prototypes:
  	int (*fl_compare_owner)(struct file_lock *, struct file_lock *);
  	void (*fl_notify)(struct file_lock *);  /* unblock callback */
 +	int (*fl_grant)(struct file_lock *, struct file_lock *, int);
- 	void (*fl_release_private)(struct file_lock *);
  	void (*fl_break)(struct file_lock *); /* break_lease callback */
 +	int (*fl_mylease)(struct file_lock *, struct file_lock *);
 +	int (*fl_change)(struct file_lock **, int);
  
  locking rules:
 -			BKL	may block
 -fl_compare_owner:	yes	no
 -fl_notify:		yes	no
 -fl_break:		yes	no
 -
 -	Currently only NFSD and NLM provide instances of this class. None of the
 -them block. If you have out-of-tree instances - please, show up. Locking
 -in that area will change.
 +			file_lock_lock	may block
 +fl_compare_owner:	yes		no
 +fl_notify:		yes		no
 +fl_grant:		no		no
- fl_release_private:	maybe		no
 +fl_break:		yes		no
 +fl_mylease:		yes		no
 +fl_change		yes		no
 +
  --------------------------- buffer_head -----------------------------------
  prototypes:
  	void (*b_end_io)(struct buffer_head *bh, int uptodate);
