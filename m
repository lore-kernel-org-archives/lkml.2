Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2LLXVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:21:43 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:34675 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2LLXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:21:42 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 18:21:41 EST
Date: Thu, 13 Dec 2012 00:14:37 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFSv4: Check for buffer length in __nfs4_get_acl_uncached
Message-ID: <alpine.LNX.2.02.1212130009400.10324@titan.int.lan.stealer.net>
User-Agent: Alpine 2.02 (LNX 1266 2009-07-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.1
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.3.2 2011-06-06 on smtp1.stealer.net at Wed, 12 Dec 2012 23:14:40 +0000
 Bayes: 0.0012 Tokens: new, 201; hammy, 6; neutral, 2; spammy, 0.
 AutoLearn: no
 * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
 *      [score: 0.0012]
 *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
X-Spam-Signature: a6c69d01118797b332f0bb4181808824d25aabc3
X-DomainKey-Status: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1f1ea6c "NFSv4: Fix buffer overflow checking in
__nfs4_get_acl_uncached" accidently dropped the checking for too small
result buffer length.

If someone uses getxattr on "system.nfs4_acl" on an NFSv4 mount
supporting ACLs, the ACL has not been cached and the buffer suplied is
too short, we still copy the complete ACL, resulting in kernel and user
space memory corruption.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: stable@kernel.org
---
 fs/nfs/nfs4proc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Resending, because it did not get any response.

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7bff871..f15be6b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3831,8 +3831,13 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 		goto out_free;
 	}
 	nfs4_write_cached_acl(inode, pages, res.acl_data_offset, res.acl_len);
-	if (buf)
+	if (buf) {
+		if (res.acl_len > buflen) {
+			ret = -ERANGE;
+			goto out_free;
+		}
 		_copy_from_pages(buf, pages, res.acl_data_offset, res.acl_len);
+	}
 out_ok:
 	ret = res.acl_len;
 out_free:
