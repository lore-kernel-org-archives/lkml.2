Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1DSUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:24:34 -0400
Received: from kroah.org ([198.145.64.141]:35615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab1DSUR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:47 2011
Message-Id: <20110419201047.770546869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: [43/70] vfs: Fix absolute RCU path walk failures due to uninitialized seq number
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit c1530019e311c91d14b24d8e74d233152d806e45 upstream.

During RCU walk in path_lookupat and path_openat, the rcu lookup
frequently failed if looking up an absolute path, because when root
directory was looked up, seq number was not properly set in nameidata.

We dropped out of RCU walk in nameidata_drop_rcu due to mismatch in
directory entry's seq number.  We reverted to slow path walk that need
to take references.

With the following patch, I saw a 50% increase in an exim mail server
benchmark throughput on a 4-socket Nehalem-EX system.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -712,6 +712,7 @@ static __always_inline void set_root_rcu
 		do {
 			seq = read_seqcount_begin(&fs->seq);
 			nd->root = fs->root;
+			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
 		} while (read_seqcount_retry(&fs->seq, seq));
 	}
 }


