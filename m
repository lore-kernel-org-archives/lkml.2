Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0IWA4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:56:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab0IWA4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:56:05 -0400
Date: Thu, 23 Sep 2010 10:56:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Farnum <gregf@hq.newdream.net>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100923105602.d5425e32.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/mds_client.c between commit
3612abbd5df6baa9ca3e0777c6c8646e202d3f66 ("ceph: fix reconnect encoding
for old servers") from Linus' tree and commit
20d5970378f075f8f567b92bd2c16373fbe09b72 ("ceph: preallocate flock state
without locks held") from the ceph tree.

I fixed it up (I think - see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/mds_client.c
index fad95f8,9c648ed..0000000
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@@ -2361,21 -2365,35 +2365,37 @@@ static int encode_caps_cb(struct inode 
  
  	if (recon_state->flock) {
  		int num_fcntl_locks, num_flock_locks;
- 
- 		lock_kernel();
- 		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
- 		rec.v2.flock_len = (2*sizeof(u32) +
- 				    (num_fcntl_locks+num_flock_locks) *
- 				    sizeof(struct ceph_filelock));
- 
- 		err = ceph_pagelist_append(pagelist, &rec, reclen);
- 		if (!err)
- 			err = ceph_encode_locks(inode, pagelist,
- 						num_fcntl_locks,
- 						num_flock_locks);
- 		unlock_kernel();
+ 		struct ceph_pagelist_cursor trunc_point;
+ 
+ 		ceph_pagelist_set_cursor(pagelist, &trunc_point);
+ 		do {
+ 			lock_kernel();
+ 			ceph_count_locks(inode, &num_fcntl_locks,
+ 					 &num_flock_locks);
+ 			rec.v2.flock_len = (2*sizeof(u32) +
+ 					    (num_fcntl_locks+num_flock_locks) *
+ 					    sizeof(struct ceph_filelock));
+ 			unlock_kernel();
+ 
+ 			/* pre-alloc pagelist */
+ 			ceph_pagelist_truncate(pagelist, &trunc_point);
+ 			err = ceph_pagelist_append(pagelist, &rec, reclen);
+ 			if (!err)
+ 				err = ceph_pagelist_reserve(pagelist,
+ 							    rec.v2.flock_len);
+ 
+ 			/* encode locks */
+ 			if (!err) {
+ 				lock_kernel();
+ 				err = ceph_encode_locks(inode,
+ 							pagelist,
+ 							num_fcntl_locks,
+ 							num_flock_locks);
+ 				unlock_kernel();
+ 			}
+ 		} while (err == -ENOSPC);
 +	} else {
 +		err = ceph_pagelist_append(pagelist, &rec, reclen);
  	}
  
  out_free:
