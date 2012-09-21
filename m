Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2IUNOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:14:30 -0400
Received: from lola.svc-box.de ([82.149.231.63]:54135 "EHLO lola.svc-box.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab2IUNO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:14:28 -0400
Date: Fri, 21 Sep 2012 15:07:46 +0200
From: Tino Reichardt <list-jfs@mcmilk.de>
To: jfs-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs/jfs: Patch with various fixes for the JFS code.
Message-ID: <20120921130746.GB31284@mcmilk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is a list of the changed files and the reason of it.


fs/jfs/jfs_dmap.c:
- potential NULL dereference of 'mp' in dbUpdatePMap()

fs/jfs/jfs_dtree.c:
- potential NULL dereference of 'parent' dtExtendPage()
- potential NULL dereference of 'lh' in dtInsertEntry()
- potential NULL dereference of 'ih' in dtInsertEntry()
- potential NULL dereference of 'dlh' in dtMoveEntry()
- potential NULL dereference of 'dih' in dtMoveEntry()

fs/jfs/jfs_imap.c:
- potential NULL dereference of 'aiagp' in diNewExt()
- potential NULL dereference of 'biagp' in diNewExt()
- potential NULL dereference of 'ciagp' in diNewExt()

fs/jfs/jfs_incore.h:
- added a new struct slink within the union u of the struct jfs_inode_info
- this struct slink defines _inline data to be 256 byte, which was implicitly
  used already this way for symlinks
- the following files are affected:
  - jfs_imap.c in diWrite(), line 786 via 'jfs_ip->u.link._inline'
  - inode.c in jfs_iget(), line 69 via 'JFS_IP(inode)->u.link._inline'
  - namei.c in jfs_symlink(), line 951, via 'i_fastsymlink'

fs/jfs/jfs_txnmgr.c:
- TXN_SLEEP is changed from define to an inlined function
- as long, as it was a define, smatch complains about double locking of
  jfsTxnLock via spin_lock()
- fix potential NULL dereference of 'mp' in txUpdateMap()

fs/jfs/jfs_xtree.c:
- potential NULL dereference of 'rxtlck' in xtSplitPage()
- potential NULL dereference of 'sxtlck' in xtSplitPage()
- potential NULL dereference of 'xtlck' in xtExtend()
- potential NULL dereference of 'xtlck' in xtUpdate()
- potential NULL dereference of 'tblk' in xtTruncate()

fs/jfs/xattr.c:
- ealist in ea_write() line 303 could be NULL, this was not checked

I also changed the sysv unchar type to u8, cause u8 is used everywhere
but the unchar only 4 times.


Signed-off-by: Tino Reichardt <milky-kernel@mcmilk.de>


---
 fs/jfs/jfs_dmap.c   |  7 ++++---
 fs/jfs/jfs_dtree.c  | 15 +++++++++++----
 fs/jfs/jfs_imap.c   | 17 ++++++++++++-----
 fs/jfs/jfs_incore.h | 15 ++++++++++-----
 fs/jfs/jfs_txnmgr.c | 17 +++++++++--------
 fs/jfs/jfs_xtree.c  | 10 ++++++++++
 fs/jfs/namei.c      |  2 +-
 fs/jfs/xattr.c      |  1 +
 8 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 9a55f53..4027a7a 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -464,12 +464,13 @@ dbUpdatePMap(struct inode *ipbmap,
 				write_metapage(mp);
 			}
 
-			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE,
-					   0);
-			if (mp == NULL)
+			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
+			if (unlikely(mp == NULL))
 				return -EIO;
 			metapage_wait_for_io(mp);
 		}
+
+		BUG_ON(mp == NULL);
 		dp = (struct dmap *) mp->data;
 
 		/* determine the bit number and word within the dmap of
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 9197a1b..6c51cb0 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -1670,6 +1670,7 @@ static int dtExtendPage(tid_t tid,
 
 	/* get parent/root page */
 	parent = BT_POP(btstack);
+	BUG_ON(parent == NULL);
 	DT_GETPAGE(ip, parent->bn, pmp, PSIZE, pp, rc);
 	if (rc)
 		return (rc);
@@ -4005,10 +4006,13 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
 	/* terminate last/only segment */
 	if (h == t) {
 		/* single segment entry */
-		if (p->header.flag & BT_LEAF)
+		if (p->header.flag & BT_LEAF) {
+			BUG_ON(lh == NULL);
 			lh->next = -1;
-		else
+		} else {
+			BUG_ON(ih == NULL);
 			ih->next = -1;
+		}
 	} else
 		/* multi-segment entry */
 		t->next = -1;
@@ -4213,10 +4217,13 @@ static void dtMoveEntry(dtpage_t * sp, int si, dtpage_t * dp,
 		/* terminate dst last/only segment */
 		if (h == d) {
 			/* single segment entry */
-			if (dp->header.flag & BT_LEAF)
+			if (dp->header.flag & BT_LEAF) {
+				BUG_ON(dlh == NULL);
 				dlh->next = -1;
-			else
+			} else {
+				BUG_ON(dih == NULL);
 				dih->next = -1;
+			}
 		} else
 			/* multi-segment entry */
 			d->next = -1;
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 1b6f15f..41eec95 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -2316,12 +2316,15 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 	 * iag from the ag free extent list.
 	 */
 	if (iagp->nfreeexts == cpu_to_le32(1)) {
-		if (fwd >= 0)
+		if (fwd >= 0) {
+			BUG_ON(aiagp == NULL);
 			aiagp->extfreeback = iagp->extfreeback;
+		}
 
-		if (back >= 0)
+		if (back >= 0) {
+			BUG_ON(biagp == NULL);
 			biagp->extfreefwd = iagp->extfreefwd;
-		else
+		} else
 			imap->im_agctl[agno].extfree =
 			    le32_to_cpu(iagp->extfreefwd);
 
@@ -2331,8 +2334,10 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 		 * add the iag to the ag free extent list.
 		 */
 		if (iagp->nfreeexts == cpu_to_le32(EXTSPERIAG)) {
-			if (fwd >= 0)
+			if (fwd >= 0) {
+				BUG_ON(aiagp == NULL);
 				aiagp->extfreeback = cpu_to_le32(iagno);
+			}
 
 			iagp->extfreefwd = cpu_to_le32(fwd);
 			iagp->extfreeback = cpu_to_le32(-1);
@@ -2344,8 +2349,10 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 	 * ag free inode list.
 	 */
 	if (iagp->nfreeinos == 0) {
-		if (freei >= 0)
+		if (freei >= 0) {
+			BUG_ON(ciagp == NULL);
 			ciagp->inofreeback = cpu_to_le32(iagno);
+		}
 
 		iagp->inofreefwd =
 		    cpu_to_le32(imap->im_agctl[agno].inofree);
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index 4fa958a..019e44e 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -52,7 +52,7 @@ struct jfs_inode_info {
 	unsigned long cflag;	/* commit flags		*/
 	u64	agstart;	/* agstart of the containing IAG */
 	u16	bxflag;		/* xflag of pseudo buffer?	*/
-	unchar	pad;
+	u8	pad;
 	signed char active_ag;	/* ag currently allocating from	*/
 	lid_t	blid;		/* lid of pseudo buffer?	*/
 	lid_t	atlhead;	/* anonymous tlock list head	*/
@@ -85,14 +85,19 @@ struct jfs_inode_info {
 			dtroot_t _dtroot;	/* 288: dtree root */
 		} dir;
 		struct {
-			unchar _unused[16];	/* 16: */
+			u8 _unused[16];		/* 16: */
 			dxd_t _dxd;		/* 16: */
-			unchar _inline[128];	/* 128: inline symlink */
+			u8 _inline[128];	/* 128: inline symlink */
 			/* _inline_ea may overlay the last part of
 			 * file._xtroot if maxentry = XTROOTINITSLOT
 			 */
-			unchar _inline_ea[128];	/* 128: inline extended attr */
+			u8 _inline_ea[128];	/* 128: inline extended attr */
 		} link;
+		struct {
+			u8 _unused[16];	/* 16: */
+			dxd_t _dxd;	/* 16: */
+			u8 _inline[256];/* 256: inline symlink only */
+		} slink;
 	} u;
 	u32 dev;	/* will die when we get wide dev_t */
 	struct inode	vfs_inode;
@@ -101,7 +106,7 @@ struct jfs_inode_info {
 #define i_imap u.file._imap
 #define i_dirtable u.dir._table
 #define i_dtroot u.dir._dtroot
-#define i_inline u.link._inline
+#define i_inline u.slink._inline
 #define i_inline_ea u.link._inline_ea
 
 #define IREAD_LOCK(ip, subclass) \
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 5fcc02e..2d00fee 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -115,11 +115,11 @@ struct tlock *TxLock;	/* transaction lock table */
  */
 static DEFINE_SPINLOCK(jfsTxnLock);
 
-#define TXN_LOCK()		spin_lock(&jfsTxnLock)
-#define TXN_UNLOCK()		spin_unlock(&jfsTxnLock)
+#define TXN_LOCK()	spin_lock(&jfsTxnLock)
+#define TXN_UNLOCK()	spin_unlock(&jfsTxnLock)
 
-#define LAZY_LOCK_INIT()	spin_lock_init(&TxAnchor.LazyLock);
-#define LAZY_LOCK(flags)	spin_lock_irqsave(&TxAnchor.LazyLock, flags)
+#define LAZY_LOCK_INIT()   spin_lock_init(&TxAnchor.LazyLock);
+#define LAZY_LOCK(flags)   spin_lock_irqsave(&TxAnchor.LazyLock, flags)
 #define LAZY_UNLOCK(flags) spin_unlock_irqrestore(&TxAnchor.LazyLock, flags)
 
 static DECLARE_WAIT_QUEUE_HEAD(jfs_commit_thread_wait);
@@ -140,10 +140,10 @@ static inline void TXN_SLEEP_DROP_LOCK(wait_queue_head_t * event)
 	remove_wait_queue(event, &wait);
 }
 
-#define TXN_SLEEP(event)\
-{\
-	TXN_SLEEP_DROP_LOCK(event);\
-	TXN_LOCK();\
+static inline void TXN_SLEEP(wait_queue_head_t *event)
+{
+	TXN_SLEEP_DROP_LOCK(event);
+	TXN_LOCK();
 }
 
 #define TXN_WAKEUP(event) wake_up_all(event)
@@ -2381,6 +2381,7 @@ static void txUpdateMap(struct tblock * tblk)
 			}
 		}
 		if (tlck->flag & tlckFREEPAGE) {
+			BUG_ON(mp == NULL);
 			if (!(tblk->flag & tblkGC_LAZY)) {
 				/* This is equivalent to txRelease */
 				ASSERT(mp->lid == lid);
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 6c50871..d8ff7a8 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -1066,6 +1066,8 @@ xtSplitPage(tid_t tid, struct inode *ip,
 		rp->header.nextindex = cpu_to_le16(XTENTRYSTART + 1);
 
 		if (!test_cflag(COMMIT_Nolink, ip)) {
+			BUG_ON(rxtlck == NULL);
+
 			/* rxtlck->lwm.offset = XTENTRYSTART; */
 			rxtlck->lwm.length = 1;
 		}
@@ -1137,6 +1139,7 @@ xtSplitPage(tid_t tid, struct inode *ip,
 		/* update page header */
 		sp->header.nextindex = cpu_to_le16(middle + 1);
 		if (!test_cflag(COMMIT_Nolink, ip)) {
+			BUG_ON(sxtlck == NULL);
 			sxtlck->lwm.offset = (sxtlck->lwm.offset) ?
 			    min(skip, (int)sxtlck->lwm.offset) : skip;
 		}
@@ -1167,6 +1170,7 @@ xtSplitPage(tid_t tid, struct inode *ip,
 		/* update page header */
 		sp->header.nextindex = cpu_to_le16(middle);
 		if (!test_cflag(COMMIT_Nolink, ip)) {
+			BUG_ON(sxtlck == NULL);
 			sxtlck->lwm.offset = (sxtlck->lwm.offset) ?
 			    min(middle, (int)sxtlck->lwm.offset) : middle;
 		}
@@ -1176,6 +1180,7 @@ xtSplitPage(tid_t tid, struct inode *ip,
 	}
 
 	if (!test_cflag(COMMIT_Nolink, ip)) {
+		BUG_ON(sxtlck == NULL);
 		sxtlck->lwm.length = le16_to_cpu(sp->header.nextindex) -
 		    sxtlck->lwm.offset;
 
@@ -1492,6 +1497,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 		xad->flag |= XAD_EXTENDED;
 
 	if (!test_cflag(COMMIT_Nolink, ip)) {
+		BUG_ON(xtlck == NULL);
 		xtlck->lwm.offset =
 		    (xtlck->lwm.offset) ? min(index,
 					      (int)xtlck->lwm.offset) : index;
@@ -2005,6 +2011,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 	if (newpage) {
 		/* close out old page */
 		if (!test_cflag(COMMIT_Nolink, ip)) {
+			BUG_ON(xtlck == NULL);
 			xtlck->lwm.offset = (xtlck->lwm.offset) ?
 			    min(index0, (int)xtlck->lwm.offset) : index0;
 			xtlck->lwm.length =
@@ -2137,6 +2144,7 @@ printf("xtUpdate.updateLeft.split p:0x%p\n", p);
 
       out:
 	if (!test_cflag(COMMIT_Nolink, ip)) {
+		BUG_ON(xtlck == NULL);
 		xtlck->lwm.offset = (xtlck->lwm.offset) ?
 		    min(index0, (int)xtlck->lwm.offset) : index0;
 		xtlck->lwm.length = le16_to_cpu(p->header.nextindex) -
@@ -3540,6 +3548,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
 	 * quickly remove it and add it to the end.
 	 */
 
+	BUG_ON(tblk == NULL);
+
 	/*
 	 * Move parent page's tlock to the end of the tid's tlock list
 	 */
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 3b91a7a..bbade01 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -881,7 +881,7 @@ static int jfs_symlink(struct inode *dip, struct dentry *dentry,
 	int ssize;		/* source pathname size */
 	struct btstack btstack;
 	struct inode *ip = dentry->d_inode;
-	unchar *i_fastsymlink;
+	u8 *i_fastsymlink;
 	s64 xlen = 0;
 	int bmask = 0, xsize;
 	s64 xaddr;
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 26683e1..e5f9add 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -256,6 +256,7 @@ static int ea_write(struct inode *ip, struct jfs_ea_list *ealist, int size,
 	 * loop over the FEALIST copying data into the buffer one page at
 	 * a time.
 	 */
+	BUG_ON(ealist == NULL);
 	cp = (char *) ealist;
 	nbytes = size;
 	for (i = 0; i < nblocks; i += sbi->nbperpage) {
-- 
1.7.12.1

-- 
regards, TR
