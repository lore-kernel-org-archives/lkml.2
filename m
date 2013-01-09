Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab3AIUjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:42479 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab3AIUjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eryu Guan <eguan@redhat.com>, Fred Isaman <iisaman@netapp.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 042/123] nfs: dont zero out the rest of the page if we hit the EOF on a DIO READ
Date: Wed,  9 Jan 2013 12:34:41 -0800
Message-Id: <20130109201503.951207894@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 67fad106a219e083c91c79695bd1807dde1bf7b9 upstream.

Eryu provided a test program that would segfault when attempting to read
past the EOF on file that was opened O_DIRECT. The buffer given to the
read() call was on the stack, and when he attempted to read past it it
would scribble over the rest of the stack page.

If we hit the end of the file on a DIO READ request, then we don't want
to zero out the rest of the buffer. These aren't pagecache pages after
all, and there's no guarantee that the buffers that were passed in
represent entire pages.

Reported-by: Eryu Guan <eguan@redhat.com>
Cc: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -266,14 +266,6 @@ static void nfs_direct_read_completion(s
 		struct nfs_page *req = nfs_list_entry(hdr->pages.next);
 		struct page *page = req->wb_page;
 
-		if (test_bit(NFS_IOHDR_EOF, &hdr->flags)) {
-			if (bytes > hdr->good_bytes)
-				zero_user(page, 0, PAGE_SIZE);
-			else if (hdr->good_bytes - bytes < PAGE_SIZE)
-				zero_user_segment(page,
-					hdr->good_bytes & ~PAGE_MASK,
-					PAGE_SIZE);
-		}
 		if (!PageCompound(page)) {
 			if (test_bit(NFS_IOHDR_ERROR, &hdr->flags)) {
 				if (bytes < hdr->good_bytes)


