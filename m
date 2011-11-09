Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab1KJFUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:20:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934279Ab1KJDXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:08 2011
Message-Id: <20111109212708.167070317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [077/262] nfs: dont redirty inode when ncommit == 0 in nfs_commit_unstable_pages
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3236c3e1adc0c7ec83eaff1de2d06746b7c5bb28 upstream.

commit 420e3646 allowed the kernel to reduce the number of unnecessary
commit calls by skipping the commit when there are a large number of
outstanding pages.

However, the current test in nfs_commit_unstable_pages does not handle
the edge condition properly. When ncommit == 0, then that means that the
kernel doesn't need to do anything more for the inode. The current test
though in the WB_SYNC_NONE case will return true, and the inode will end
up being marked dirty. Once that happens the inode will never be clean
until there's a WB_SYNC_ALL flush.

Fix this by immediately returning from nfs_commit_unstable_pages when
ncommit == 0.

Mike noticed this problem initially in RHEL5 (2.6.18-based kernel) which
has a backported version of 420e3646. The inode cache there was growing
very large. The inode cache was unable to be shrunk since the inodes
were all marked dirty. Calling sync() would essentially "fix" the
problem -- the WB_SYNC_ALL flush would result in the inodes all being
marked clean.

What I'm not clear on is how big a problem this is in mainline kernels
as the writeback code there is very different. Either way, it seems
incorrect to re-mark the inode dirty in this case.

Reported-by: Mike McLean <mikem@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1526,6 +1526,10 @@ static int nfs_commit_unstable_pages(str
 	int flags = FLUSH_SYNC;
 	int ret = 0;
 
+	/* no commits means nothing needs to be done */
+	if (!nfsi->ncommit)
+		return ret;
+
 	if (wbc->sync_mode == WB_SYNC_NONE) {
 		/* Don't commit yet if this is a non-blocking flush and there
 		 * are a lot of outstanding writes for this mapping.


