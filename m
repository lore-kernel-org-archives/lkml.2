Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2BUUCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:02:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2BUTxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/73] union-mount: Add two superblock fields for union mounts
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:19 +0000
Message-ID: <20120221180018.25235.59663.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Add two fields to struct super_block to support union mounts:

 (*) s_union_lower_mnts

     A pointer to a cloned vfsmount tree of all the lower (read-only) mounts
     unioned with the topmost (read-write) vfsmount.  These mounts may have
     submounts which will also be unioned; hence we copy the entire vfsmount
     tree, not just the root vfsmounts.

 (*) s_union_count

     The number of lower mounts unioned at the root of the file system.  This
     count is the maximum number of directories that will ever be unioned with
     a single directory.  We use it to allocate a union stack of the correct
     size for each directory.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/fs.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a014f0f..f19772c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1509,6 +1509,16 @@ struct super_block {
 	 * free_vfsmnt() if MNT_HARD_READONLY is set.
 	 */
 	int s_hard_readonly_users;
+
+	/* Root of the private cloned vfsmount tree of the read-only
+	 * mounts in this union (set in topmost vfsmount only)
+	 */
+	struct vfsmount *s_union_lower_mnts;
+
+	/* Number of layers in this union, not counting the topmost or
+	 * submounts.
+	 */
+	unsigned int s_union_count;
 };
 
 /* superblock cache pruning functions */

