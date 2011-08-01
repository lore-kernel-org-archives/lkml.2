Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1HAX2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:28:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1HAX1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.712213193@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, xfs-oss <xfs@oss.sgi.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>
Subject: [61/70] xfs [stable only]: restart busy extent search after node removal
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

A user on #xfs reported that a log replay was oopsing in
__rb_rotate_left() with a null pointer deref, and provided
an xfs_metadump image for reproduction and testing.

I traced this down to the fact that in xfs_alloc_busy_insert(),
we erased a node with rb_erase() when the new node overlapped,
but left the erased node specified as the parent node for the
new insertion.

So when we try to insert a new node with an erased node as
its parent, obviously things go very wrong.

Upstream,
97d3ac75e5e0ebf7ca38ae74cebd201c09b97ab2 xfs: exact busy extent tracking
actually fixed this, but as part of a much larger change.  Here's
the relevant code from that commit:

                * We also need to restart the busy extent search from the
                * tree root, because erasing the node can rearrange the
                * tree topology.
                */
               rb_erase(&busyp->rb_node, &pag->pagb_tree);
               busyp->length = 0;
               return false;

We can do essentially the same thing to older codebases by restarting
the tree search after the erase.

This should apply to .35.y through .39.y, and was tested on .39
with the oopsing replay reproducer.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 fs/xfs/xfs_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2610,6 +2610,12 @@ restart:
 					new->bno + new->length) -
 				min(busyp->bno, new->bno);
 		new->bno = min(busyp->bno, new->bno);
+		/*
+		 * Start the search over from the tree root, because
+		 * erasing the node can rearrange the tree topology.
+		 */
+		spin_unlock(&pag->pagb_lock);
+		goto restart;
 	} else
 		busyp = NULL;
 


