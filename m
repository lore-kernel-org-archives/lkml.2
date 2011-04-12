Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1DLOi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:29 -0400
Received: from kroah.org ([198.145.64.141]:57627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab1DLOiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.600488407@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [062/105] UBIFS: fix debugging failure in dbg_check_space_info
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 7da6443aca9be29c6948dcbd636ad50154d0bc0c upstream.

This patch fixes a debugging failure with which looks like this:
UBIFS error (pid 32313): dbg_check_space_info: free space changed from 6019344 to 6022654

The reason for this failure is described in the comment this patch adds
to the code. But in short - 'c->freeable_cnt' may be different before
and after re-mounting, and this is normal. So the debugging code should
make sure that free space calculations do not depend on 'c->freeable_cnt'.

A similar issue has been reported here:
http://lists.infradead.org/pipermail/linux-mtd/2011-April/034647.html

This patch should fix it.

For the -stable guys: this patch is only relevant for kernels 2.6.30
onwards.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/debug.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -961,11 +961,39 @@ void dbg_dump_index(struct ubifs_info *c
 void dbg_save_space_info(struct ubifs_info *c)
 {
 	struct ubifs_debug_info *d = c->dbg;
-
-	ubifs_get_lp_stats(c, &d->saved_lst);
+	int freeable_cnt;
 
 	spin_lock(&c->space_lock);
+	memcpy(&d->saved_lst, &c->lst, sizeof(struct ubifs_lp_stats));
+
+	/*
+	 * We use a dirty hack here and zero out @c->freeable_cnt, because it
+	 * affects the free space calculations, and UBIFS might not know about
+	 * all freeable eraseblocks. Indeed, we know about freeable eraseblocks
+	 * only when we read their lprops, and we do this only lazily, upon the
+	 * need. So at any given point of time @c->freeable_cnt might be not
+	 * exactly accurate.
+	 *
+	 * Just one example about the issue we hit when we did not zero
+	 * @c->freeable_cnt.
+	 * 1. The file-system is mounted R/O, c->freeable_cnt is %0. We save the
+	 *    amount of free space in @d->saved_free
+	 * 2. We re-mount R/W, which makes UBIFS to read the "lsave"
+	 *    information from flash, where we cache LEBs from various
+	 *    categories ('ubifs_remount_fs()' -> 'ubifs_lpt_init()'
+	 *    -> 'lpt_init_wr()' -> 'read_lsave()' -> 'ubifs_lpt_lookup()'
+	 *    -> 'ubifs_get_pnode()' -> 'update_cats()'
+	 *    -> 'ubifs_add_to_cat()').
+	 * 3. Lsave contains a freeable eraseblock, and @c->freeable_cnt
+	 *    becomes %1.
+	 * 4. We calculate the amount of free space when the re-mount is
+	 *    finished in 'dbg_check_space_info()' and it does not match
+	 *    @d->saved_free.
+	 */
+	freeable_cnt = c->freeable_cnt;
+	c->freeable_cnt = 0;
 	d->saved_free = ubifs_get_free_space_nolock(c);
+	c->freeable_cnt = freeable_cnt;
 	spin_unlock(&c->space_lock);
 }
 
@@ -982,12 +1010,15 @@ int dbg_check_space_info(struct ubifs_in
 {
 	struct ubifs_debug_info *d = c->dbg;
 	struct ubifs_lp_stats lst;
-	long long avail, free;
+	long long free;
+	int freeable_cnt;
 
 	spin_lock(&c->space_lock);
-	avail = ubifs_calc_available(c, c->min_idx_lebs);
+	freeable_cnt = c->freeable_cnt;
+	c->freeable_cnt = 0;
+	free = ubifs_get_free_space_nolock(c);
+	c->freeable_cnt = freeable_cnt;
 	spin_unlock(&c->space_lock);
-	free = ubifs_get_free_space(c);
 
 	if (free != d->saved_free) {
 		ubifs_err("free space changed from %lld to %lld",


