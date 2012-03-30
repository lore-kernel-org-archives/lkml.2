Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240Ab2C3VHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:07:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935162Ab2C3VHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:32 -0400
Message-Id: <20120330195734.352859498@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michel Lespinasse <walken@google.com>
Subject: [ 085/108] vfs: fix d_ancestor() case in d_materialize_unique
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Lespinasse <walken@google.com>

commit b18dafc86bb879d2f38a1743985d7ceb283c2f4d upstream.

In d_materialise_unique() there are 3 subcases to the 'aliased dentry'
case; in two subcases the inode i_lock is properly released but this
does not occur in the -ELOOP subcase.

This seems to have been introduced by commit 1836750115f2 ("fix loop
checks in d_materialise_unique()").

Signed-off-by: Michel Lespinasse <walken@google.com>
[ Added a comment, and moved the unlock to where we generate the -ELOOP,
  which seems to be more natural.

  You probably can't actually trigger this without a buggy network file
  server - d_materialize_unique() is for finding aliases on non-local
  filesystems, and the d_ancestor() case is for a hardlinked directory
  loop.

  But we should be robust in the case of such buggy servers anyway. ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2433,6 +2433,7 @@ struct dentry *d_materialise_unique(stru
 			if (d_ancestor(alias, dentry)) {
 				/* Check for loops */
 				actual = ERR_PTR(-ELOOP);
+				spin_unlock(&inode->i_lock);
 			} else if (IS_ROOT(alias)) {
 				/* Is this an anonymous mountpoint that we
 				 * could splice into our tree? */
@@ -2442,7 +2443,7 @@ struct dentry *d_materialise_unique(stru
 				goto found;
 			} else {
 				/* Nope, but we must(!) avoid directory
-				 * aliasing */
+				 * aliasing. This drops inode->i_lock */
 				actual = __d_unalias(inode, dentry, alias);
 			}
 			write_sequnlock(&rename_lock);


