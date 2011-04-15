Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1DOSjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:39:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:44674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1DOSjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,220,1301900400"; 
   d="scan'208";a="733978339"
Subject: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
Cc: Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com, alex.shi@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 11:39:29 -0700
Message-ID: <1302892769.2577.24.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During RCU walk in path_lookupat and path_openat, the rcu lookup
frequently failed because when root directory was looked up, seq number
was not properly set in nameidata.  We dropped out of RCU walk in
nameidata_drop_rcu due to mismatch in directory entry's seq number.  We
reverted to slow path walk that need to take references.

With the following patch, I saw a 50% increase in an exim mail server
benchmark throughput on a 4-socket Nehalem-EX system.

Thanks.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/fs/namei.c b/fs/namei.c
index 3cb616d..e4b27a6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -697,6 +697,7 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
 		do {
 			seq = read_seqcount_begin(&fs->seq);
 			nd->root = fs->root;
+			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
 		} while (read_seqcount_retry(&fs->seq, seq));
 	}
 }


