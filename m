Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1H0O6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab1H0O6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.831900648@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiaying Zhang <jiayingz@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [19/35] ext4: call ext4_ioend_wait and ext4_flush_completed_IO in ext4_evict_inode
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiaying Zhang <jiayingz@google.com>

commit 2581fdc810889fdea97689cb62481201d579c796 upstream.

Flush inode's i_completed_io_list before calling ext4_io_wait to
prevent the following deadlock scenario: A page fault happens while
some process is writing inode A. During page fault,
shrink_icache_memory is called that in turn evicts another inode
B. Inode B has some pending io_end work so it calls ext4_ioend_wait()
that waits for inode B's i_ioend_count to become zero. However, inode
B's ioend work was queued behind some of inode A's ioend work on the
same cpu's ext4-dio-unwritten workqueue. As the ext4-dio-unwritten
thread on that cpu is processing inode A's ioend work, it tries to
grab inode A's i_mutex lock. Since the i_mutex lock of inode A is
still hold before the page fault happened, we enter a deadlock.

Also moves ext4_flush_completed_IO and ext4_ioend_wait from
ext4_destroy_inode() to ext4_evict_inode(). During inode deleteion,
ext4_evict_inode() is called before ext4_destroy_inode() and in
ext4_evict_inode(), we may call ext4_truncate() without holding
i_mutex lock. As a result, there is a race between flush_completed_IO
that is called from ext4_ext_truncate() and ext4_end_io_work, which
may cause corruption on an io_end structure. This change moves
ext4_flush_completed_IO and ext4_ioend_wait from ext4_destroy_inode()
to ext4_evict_inode() to resolve the race between ext4_truncate() and
ext4_end_io_work during inode deletion.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    6 ++++++
 fs/ext4/super.c |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -189,6 +189,12 @@ void ext4_evict_inode(struct inode *inod
 	int err;
 
 	trace_ext4_evict_inode(inode);
+
+	mutex_lock(&inode->i_mutex);
+	ext4_flush_completed_IO(inode);
+	mutex_unlock(&inode->i_mutex);
+	ext4_ioend_wait(inode);
+
 	if (inode->i_nlink) {
 		truncate_inode_pages(&inode->i_data, 0);
 		goto no_delete;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -892,7 +892,6 @@ static void ext4_i_callback(struct rcu_h
 
 static void ext4_destroy_inode(struct inode *inode)
 {
-	ext4_ioend_wait(inode);
 	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
 		ext4_msg(inode->i_sb, KERN_ERR,
 			 "Inode %lu (%p): orphan list check failed!",


