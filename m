Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3AIUjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:42458 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933418Ab3AIUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sven Wegener <sven.wegener@stealer.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 041/123] NFSv4: Check for buffer length in __nfs4_get_acl_uncached
Date: Wed,  9 Jan 2013 12:34:40 -0800
Message-Id: <20130109201503.819033406@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

commit 7d3e91a89b7adbc2831334def9e494dd9892f9af upstream.

Commit 1f1ea6c "NFSv4: Fix buffer overflow checking in
__nfs4_get_acl_uncached" accidently dropped the checking for too small
result buffer length.

If someone uses getxattr on "system.nfs4_acl" on an NFSv4 mount
supporting ACLs, the ACL has not been cached and the buffer suplied is
too short, we still copy the complete ACL, resulting in kernel and user
space memory corruption.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3937,8 +3937,13 @@ static ssize_t __nfs4_get_acl_uncached(s
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


