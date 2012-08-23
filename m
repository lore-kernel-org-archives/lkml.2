Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2HWMe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:34:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56620 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390Ab2HWMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:34:26 -0400
Date: Thu, 23 Aug 2012 16:34:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 4/9] fs, exportfs: Fix nil dereference if no s_export_op
 present
Message-ID: <20120823123422.GB9112@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.830795272@openvz.org>
 <20120823121230.GC29943@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823121230.GC29943@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 08:12:30AM -0400, J. Bruce Fields wrote:
> On Thu, Aug 23, 2012 at 02:43:27PM +0400, Cyrill Gorcunov wrote:
> > If there is no s_export_op present in a target superblock
> > we might have nil dereference.
> 
> Is that NULL dereference possible with current code, or is it a check
> you're adding to account for a new caller that you're about to add?
> 
> I believe it's the latter, but this would be a good thing to make clear
> in the changelog.

With the current code it seems to be impossible (well, i can't be sure
about nfs caller) because do_sys_name_to_handle does check for s_export_op
to exist. Updated changelog below. After all I think not checking
s_export_op was a mistake in general -- this routine is exported to
other modules but has no a single line of comment about possibility
of nil dereference.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, exportfs: Escape nil dereference if no s_export_op present

This routine will be used to generate a file handle in fdinfo
output for inotify subsystem, where if no s_export_op present
the general export_encode_fh should be used. Thus add
a test if s_export_op present inside exportfs_encode_fh itself.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/exportfs/expfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.git.orig/fs/exportfs/expfs.c
+++ linux-2.6.git/fs/exportfs/expfs.c
@@ -357,7 +357,7 @@ int exportfs_encode_fh(struct dentry *de
 		 */
 		parent = p->d_inode;
 	}
-	if (nop->encode_fh)
+	if (nop && nop->encode_fh)
 		error = nop->encode_fh(inode, fid->raw, max_len, parent);
 	else
 		error = export_encode_fh(inode, fid, max_len, parent);
