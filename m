Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1GHFD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1GHFDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.062981271@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peng Tao <peng_tao@emc.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [055/107] NFS41: do not update isize if inode needs layoutcommit
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit 0f66b5984df2fe1617c05900a39a7ef493ca9de9 upstream.

nfs_update_inode will update isize if there is no queued pages. For pNFS,
layoutcommit is supposed to change file size on server, the same effect as queued
pages. nfs_update_inode may be called when dirty pages are written back (nfsi->npages==0)
but layoutcommit is not sent, and it will change client file size according to server
file size. Then client ends up losing what it just writes back in pNFS path.
So we should skip updating client file size if file needs layoutcommit.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1294,7 +1294,8 @@ static int nfs_update_inode(struct inode
 		if (new_isize != cur_isize) {
 			/* Do we perhaps have any outstanding writes, or has
 			 * the file grown beyond our last write? */
-			if (nfsi->npages == 0 || new_isize > cur_isize) {
+			if ((nfsi->npages == 0 && !test_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags)) ||
+			     new_isize > cur_isize) {
 				i_size_write(inode, new_isize);
 				invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
 			}


