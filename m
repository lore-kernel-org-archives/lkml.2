Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0GWEqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:46:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0GWEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:46:08 -0400
Date: Fri, 23 Jul 2010 14:46:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Subject: linux-next: manual merge of the workqueues tree with the cifs tree
Message-Id: <20100723144608.435f7e40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/cifs/file.c between commit 7d4716ba25ecc032d83ec4fa231edfcef8e17b62
("cifs: FS-Cache page management") from the cifs tree and commit
9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs: use workqueue instead of
slow-work") from the workqueues tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/file.c
index fa04a00d,e767bfa..0000000
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@@ -2291,24 -2295,7 +2291,23 @@@ out
  	return rc;
  }
  
 +static int cifs_release_page(struct page *page, gfp_t gfp)
 +{
 +	if (PagePrivate(page))
 +		return 0;
 +
 +	return cifs_fscache_release_page(page, gfp);
 +}
 +
 +static void cifs_invalidate_page(struct page *page, unsigned long offset)
 +{
 +	struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);
 +
 +	if (offset == 0)
 +		cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
 +}
 +
- static void
- cifs_oplock_break(struct slow_work *work)
+ void cifs_oplock_break(struct work_struct *work)
  {
  	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
  						  oplock_break);
