Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3AIUiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:42354 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384Ab3AIUis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 045/123] NFS: Dont use SetPageError in the NFS writeback code
Date: Wed,  9 Jan 2013 12:34:44 -0800
Message-Id: <20130109201504.348455272@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ada8e20d044c0fa5610e504ce6fb4578ebd3edd9 upstream.

The writeback code is already capable of passing errors back to user space
by means of the open_context->error. In the case of ENOSPC, Neil Brown
is reporting seeing 2 errors being returned.

Neil writes:

"e.g. if /mnt2/ if an nfs mounted filesystem that has no space then

strace dd if=/dev/zero conv=fsync >> /mnt2/afile count=1

reported Input/output error and the relevant parts of the strace output are:

write(1, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
fsync(1)                                = -1 EIO (Input/output error)
close(1)                                = -1 ENOSPC (No space left on device)"

Neil then shows that the duplication of error messages appears to be due to
the use of the PageError() mechanism, which causes filemap_fdatawait_range
to return the extra EIO. The regression was introduced by
commit 7b281ee026552f10862b617a2a51acf49c829554 (NFS: fsync() must exit
with an error if page writeback failed).

Fix this by removing the call to SetPageError(), and just relying on
open_context->error reporting the ENOSPC back to fsync().

Reported-by: Neil Brown <neilb@suse.de>
Tested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -202,7 +202,6 @@ out:
 /* A writeback failed: mark the page as bad, and invalidate the page cache */
 static void nfs_set_pageerror(struct page *page)
 {
-	SetPageError(page);
 	nfs_zap_mapping(page_file_mapping(page)->host, page_file_mapping(page));
 }
 


