Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0KIM7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:59:00 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28490 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab0KIM67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:58:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHDU2Ex5LcZK/2dsb2JhbACiH3K/QYVKBIUQ
Date: Tue, 9 Nov 2010 23:58:54 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 3/6] fs: dcache documentation cleanup
Message-ID: <20101109125854.GD11477@amd>
References: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109124610.GB11477@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to get the following 3 patches merged soon, because they
touch a lot of filesystems but quite trivially. (this clashes trivially
with rcu patches if taken out of order, but easily fixable).

Where are we going?

http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=blob;f=Documentation/filesystems/path-lookup.txt;h=5435c136d0307854761e9aaaa9886e282d67a881;hb=refs/heads/vfs-scale

So please review that if you still have doubts about the overall design.

I have been toying with pulling rcu-walk first, before dcache scaling.
I'm not really happy with it, because the property that d_lock protects
d_count and d_seq and all other elements of the dentry really help make
it easy to see that concurrency isn't a problem when doing tricky things
like converting rcu-and-seqlock based walking into lock-and-refcount
based walking mid-way through a path lookup.

So while it is _possible_ to use dcache_lock and careful use of
atomic_inc_not_zero etc. for these things, that really sucks and is
going in totally the wrong direction (rcu-walk dropping is not a
completely rare event, so we could end up with more dcache_lock locking
in path walk than we have now).

--

Remove redundant (actually incorrect, since dcache RCU lookup) dentry
locking documentation and point to the canonical document.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/dcache.h |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-09 22:11:00.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-09 23:22:52.000000000 +1100
@@ -141,22 +141,16 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 };
 
-/* the dentry parameter passed to d_hash and d_compare is the parent
+/*
+ * Locking rules for dentry_operations callbacks are to be found in
+ * Documentation/filesystems/Locking. Keep it updated!
+ *
+ * the dentry parameter passed to d_hash and d_compare is the parent
  * directory of the entries to be compared. It is used in case these
  * functions need any directory specific information for determining
  * equivalency classes.  Using the dentry itself might not work, as it
  * might be a negative dentry which has no information associated with
- * it */
-
-/*
-locking rules:
-		big lock	dcache_lock	d_lock   may block
-d_revalidate:	no		no		no       yes
-d_hash		no		no		no       yes
-d_compare:	no		yes		yes      no
-d_delete:	no		yes		no       no
-d_release:	no		no		no       yes
-d_iput:		no		no		no       yes
+ * it.
  */
 
 /* d_flags entries */
