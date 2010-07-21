Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977Ab0GUApX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:45:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761501Ab0GUApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:45:20 -0400
Date: Tue, 20 Jul 2010 17:44:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-Id: <20100720174424.12a4bf64.akpm@linux-foundation.org>
In-Reply-To: <20100720224525.GO32635@dastard>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
	<20100720033656.0ce6356f.akpm@linux-foundation.org>
	<20100720224525.GO32635@dastard>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 08:45:25 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jul 20, 2010 at 03:36:56AM -0700, Andrew Morton wrote:
> > On Tue, 20 Jul 2010 16:41:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Al,
> > > 
> > > All of my PowerPC boot tests are getting this after getting to user mode
> > > (sometimes several times):
> > > 
> > > ------------[ cut here ]------------
> > > kernel BUG at fs/inode.c:1244!
> > > Oops: Exception in kernel mode, sig: 5 [#1]
> > > SMP NR_CPUS=128 NUMA pSeries
> > > last sysfs file: /sys/kernel/uevent_seqnum
> > > Modules linked in: ehea xt_tcpudp iptable_filter ip_tables nfnetlink nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT x_tables dm_mirror dm_region_hash dm_log dm_zero dm_snapshot parport_pc parport dm_multipath autofs4
> > > NIP: c000000000168074 LR: c000000000168064 CTR: 0000000000000000
> > > REGS: c0000000063d39f0 TRAP: 0700   Not tainted  (2.6.35-rc5-autokern1)
> > > MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 22008422  XER: 20000001
> > > TASK = c000000003a25840[4995] 'rm' THREAD: c0000000063d0000 CPU: 2
> > > GPR00: 0000000000000001 c0000000063d3c70 c000000000bfdea0 c0000000015f2090 
> > > GPR04: 0000000000000003 0000000000000001 c0000000063d3bd0 c000000000c5a388 
> > > GPR08: 80c0000000000000 0000000000000006 6000000000000000 8000000000000000 
> > > GPR12: c0000000056c0598 c0000000074d6400 0000000003100000 0000000000779b68 
> > > GPR16: 00000000007782f0 0000000010018875 00000000ff9c74b8 0000000000000000 
> > > GPR20: 0000000000000000 0000000000000000 0000000010010000 0000000010010000 
> > > GPR24: 0000000000000001 00000000fffba994 0000000000000002 000000001001a038 
> > > GPR28: c000000006617800 c000000000aefd40 c000000000b586b8 c0000000056c0748 
> > > NIP [c000000000168074] .iput+0x288/0x2d0
> > > LR [c000000000168064] .iput+0x278/0x2d0
> > > Call Trace:
> > > [c0000000063d3c70] [c000000000168064] .iput+0x278/0x2d0 (unreliable)
> > > [c0000000063d3d00] [c00000000015e964] .do_unlinkat+0x124/0x1b8
> > > [c0000000063d3e30] [c000000000008554] syscall_exit+0x0/0x40
> > > Instruction dump:
> > > 38000000 f81f0008 f81f0000 e87e8090 48457d8d 60000000 7fe3fb78 4bfff339 
> > > e81f03b0 68000060 3120ffff 7c090110 <0b000000> 38210090 7fe3fb78 e8010010 
> > > ---[ end trace 9ace9d3884bc0aac ]---
> > > Trace/breakpoint trap
> > > ------------[ cut here ]------------
> > > 
> > > This is:
> > > 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> > > in iput_final().
> > > 
> > > That BUG_ON was added by commit c0ae81f2 ("Make ->drop_inode() just
> > > return whether inode needs to be dropped").

That patch simply moved the BUG_ON around.  It still triggers with that
patch reverted.


> > > Has anyone seen this or something similar?
> > 
> > I get it all the time.  See the thread "Subject: Re: linux-next: Tree for
> > July 7".
> 
> Yet nobody else seems to be able to reproduce it. Given that powerPC
> is good at triggering reace conditions, maybe there is one that
> only you are unlucky eough to trigger.
> 
> Rather than just commenting out the BUG_ON() and ignoring the
> problem, can you print out the inode state (and enough information
> to identify the filesystem the inode belongs to) before triggering
> the BUG_ON() so we can get some idea of how this is triggering?

Already did.  ext3.  I_DIRTY_SYNC, I_DIRTY_DATASYNC and I_DIRTY_PAGES
are set (i_state=0x67).

A bit of poking around indicates that these inodes always have zero
attached pages, and they were dirtied within dquot_free_space().

[  304.460188] iput_final: 67
[  304.460357] type: ext3
[  304.460518] pages:0
[  304.460679] dirtied:include/linux/quotaops.h:330
[  304.460842] ------------[ cut here ]------------
[  304.461006] WARNING: at fs/inode.c:1250 iput+0x285/0x292()
[  304.467256] Modules linked in: autofs4 sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_multipath dm_mod video output sbs sbshc battery ac lp parport sg ide_cd_mod cdrom option usb_wwan usbserial serio_raw floppy snd_hda_intel snd_hda_codec button snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss i2c_i801 i2c_core snd_pcm snd_timer snd soundcore snd_page_alloc shpchp pcspkr ehci_hcd ohci_hcd uhci_hcd
[  304.470029] Pid: 4297, comm: rm Tainted: G        W   2.6.35-rc5 #3
[  304.470196] Call Trace:
[  304.470360]  [<ffffffff810ceb59>] ? iput+0x1fe/0x292
[  304.470527]  [<ffffffff810cebe0>] ? iput+0x285/0x292
[  304.470695]  [<ffffffff81036283>] warn_slowpath_common+0x7e/0x97
[  304.470864]  [<ffffffff810362b1>] warn_slowpath_null+0x15/0x17
[  304.471030]  [<ffffffff810cebe0>] iput+0x285/0x292
[  304.471198]  [<ffffffff810c587d>] do_unlinkat+0x104/0x15a
[  304.471364]  [<ffffffff81376ee9>] ? retint_swapgs+0xe/0x13
[  304.471531]  [<ffffffff8107225e>] ? audit_syscall_entry+0x183/0x1b6
[  304.471700]  [<ffffffff810c58e4>] sys_unlink+0x11/0x13
[  304.471869]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
[  304.472035] ---[ end trace 750102f49dbda08a ]---



 fs/anon_inodes.c    |    2 ++
 fs/buffer.c         |    7 +++++++
 fs/fs-writeback.c   |    8 ++++++++
 fs/inode.c          |    9 ++++++++-
 fs/pipe.c           |    2 ++
 include/linux/fs.h  |   11 ++++++++++-
 mm/page-writeback.c |    5 +++++
 7 files changed, 42 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~a fs/inode.c
--- a/fs/inode.c~a
+++ a/fs/inode.c
@@ -1241,7 +1241,14 @@ static void iput_final(struct inode *ino
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	if (inode->i_state != (I_FREEING | I_CLEAR)) {
+		printk("iput_final: %lx\n", inode->i_state);
+		printk("type: %s\n", inode->i_sb->s_type->name);
+		printk("pages:%lu\n", inode->i_mapping->nrpages);
+		printk("dirtied:%s:%d\n", inode->i_where_file,
+			inode->i_where_line);
+		WARN_ON(1);
+	}
 	destroy_inode(inode);
 }
 
diff -puN fs/anon_inodes.c~a fs/anon_inodes.c
--- a/fs/anon_inodes.c~a
+++ a/fs/anon_inodes.c
@@ -205,6 +205,8 @@ static struct inode *anon_inode_mkinode(
 	 * that it already _is_ on the dirty list.
 	 */
 	inode->i_state = I_DIRTY;
+	inode->i_where_file = __FILE__;
+	inode->i_where_line = __LINE__;
 	inode->i_mode = S_IRUSR | S_IWUSR;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
diff -puN fs/buffer.c~a fs/buffer.c
--- a/fs/buffer.c~a
+++ a/fs/buffer.c
@@ -663,6 +663,8 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static void __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
+	struct inode *inode;
+
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
@@ -671,6 +673,11 @@ static void __set_page_dirty(struct page
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
 	spin_unlock_irq(&mapping->tree_lock);
+	inode = mapping->host;
+	if (!(inode->i_state & I_DIRTY_PAGES)) {
+		inode->i_where_file = __FILE__;
+		inode->i_where_line = __LINE__;
+	}
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 }
 
diff -puN fs/fs-writeback.c~a fs/fs-writeback.c
--- a/fs/fs-writeback.c~a
+++ a/fs/fs-writeback.c
@@ -399,6 +399,10 @@ writeback_single_inode(struct inode *ino
 				 * to b_more_io so it will get more writeout as
 				 * soon as the queue becomes uncongested.
 				 */
+				if (!(inode->i_state & I_DIRTY_PAGES)) {
+					inode->i_where_file = __FILE__;
+					inode->i_where_line = __LINE__;
+				}
 				inode->i_state |= I_DIRTY_PAGES;
 select_queue:
 				if (wbc->nr_to_write <= 0) {
@@ -420,6 +424,10 @@ select_queue:
 				 * file would indefinitely suspend writeout of
 				 * all the other files.
 				 */
+				if (!(inode->i_state & I_DIRTY_PAGES)) {
+					inode->i_where_file = __FILE__;
+					inode->i_where_line = __LINE__;
+				}
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
diff -puN fs/libfs.c~a fs/libfs.c
diff -puN fs/pipe.c~a fs/pipe.c
--- a/fs/pipe.c~a
+++ a/fs/pipe.c
@@ -968,6 +968,8 @@ static struct inode * get_pipe_inode(voi
 	 * list because "mark_inode_dirty()" will think
 	 * that it already _is_ on the dirty list.
 	 */
+	inode->i_where_file = __FILE__;
+	inode->i_where_line = __LINE__;
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
 	inode->i_uid = current_fsuid();
diff -puN mm/page-writeback.c~a mm/page-writeback.c
--- a/mm/page-writeback.c~a
+++ a/mm/page-writeback.c
@@ -1137,7 +1137,12 @@ int __set_page_dirty_nobuffers(struct pa
 		}
 		spin_unlock_irq(&mapping->tree_lock);
 		if (mapping->host) {
+			struct inode *inode = mapping->host;
 			/* !PageAnon && !swapper_space */
+			if (!(inode->i_state & I_DIRTY_PAGES)) {
+				inode->i_where_file = __FILE__;
+				inode->i_where_line = __LINE__;
+			}
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
 		return 1;
diff -puN include/linux/fs.h~a include/linux/fs.h
--- a/include/linux/fs.h~a
+++ a/include/linux/fs.h
@@ -775,6 +775,8 @@ struct inode {
 
 	unsigned long		i_state;
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	char			*i_where_file;
+	int			i_where_line;
 
 	unsigned int		i_flags;
 
@@ -1640,11 +1642,18 @@ struct super_operations {
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
 extern void __mark_inode_dirty(struct inode *, int);
-static inline void mark_inode_dirty(struct inode *inode)
+static inline void xxmark_inode_dirty(struct inode *inode, char *file, int line)
 {
+	if (!(inode->i_state & I_DIRTY)) {
+		inode->i_where_file = file;
+		inode->i_where_line = line;
+	}
+
 	__mark_inode_dirty(inode, I_DIRTY);
 }
 
+#define mark_inode_dirty(inode) xxmark_inode_dirty(inode, __FILE__, __LINE__)
+
 static inline void mark_inode_dirty_sync(struct inode *inode)
 {
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
_


This isn't necessarily a problem in the quota code (setting aside the
question: why the heck does dquot_free_space() set I_DIRTY_PAGES??). 
If the vfs is asked to kill off a dirty inode, it should at least clean
the thing first.

I dunno.  That fs/inode.c patch series from Viro looks fishy.  I guess
I get to bisect it tomorrow.
