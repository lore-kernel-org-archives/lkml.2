Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab2EJS2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:28:51 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45798 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760708Ab2EJS2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:28:50 -0400
Date: Thu, 10 May 2012 13:32:45 -0500
From: Ben Myers <bpm@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20120510183245.GL3963@sgi.com>
References: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 01:01:34PM +1000, Stephen Rothwell wrote:
> After merging the xfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".xfs_extent_busy_trim" [fs/xfs/xfs.ko] undefined!
> 
> Caused by commit e459df5b5b93 ("xfs: move busy extent handling to it's
> own file") (and aided by 425dcd6c2289 "xfs: clean up busy extent naming").
> 
> I have used the xfs tree from next-20120508 for today.

Thanks Stephen.  The following should resolve the issue.

Regards,
	Ben



xfs: make xfs_extent_busy_trim not static

Commit e459df5, 'xfs: move busy extent handling to it's own file'
moved some code from xfs_alloc.c into xfs_extent_busy.c for
convenience in userspace code merges.  One of the functions moved is
xfs_extent_busy_trim (formerly xfs_alloc_busy_trim) which is defined
STATIC.  Unfortunately this function is still used in xfs_alloc.c, and
this results in an undefined symbol in xfs.ko.

Make xfs_extent_busy_trim not static and add its prototype to
xfs_extent_busy.h.

Signed-off-by: Ben Myers <bpm@sgi.com>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c
+++ xfs/fs/xfs/xfs_alloc.c
@@ -47,8 +47,6 @@ STATIC int xfs_alloc_ag_vextent_near(xfs
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
-STATIC void xfs_extent_busy_trim(struct xfs_alloc_arg *,
-		xfs_agblock_t, xfs_extlen_t, xfs_agblock_t *, xfs_extlen_t *);
 
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
Index: xfs/fs/xfs/xfs_extent_busy.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extent_busy.c
+++ xfs/fs/xfs/xfs_extent_busy.c
@@ -345,7 +345,7 @@ restart:
  * args->minlen no suitable extent could be found, and the higher level
  * code needs to force out the log and retry the allocation.
  */
-STATIC void
+void
 xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
 	xfs_agblock_t		bno,
Index: xfs/fs/xfs/xfs_extent_busy.h
===================================================================
--- xfs.orig/fs/xfs/xfs_extent_busy.h
+++ xfs/fs/xfs/xfs_extent_busy.h
@@ -54,6 +54,10 @@ void
 xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 
+void
+xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t bno,
+	xfs_extlen_t len, xfs_agblock_t *rbno, xfs_extlen_t *rlen);
+
 int
 xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
 
