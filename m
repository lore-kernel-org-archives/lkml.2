Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab1ESSJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47102 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934102Ab1ESSJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:10 -0400
X-Sasl-enc: pHEK5NnKtoU0r9bWkc8tZDzL2ZA637YPWJwT6hhiYAE6 1305828549
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.365562059@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [53/71] cifs: add fallback in is_path_accessible for old servers
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 221d1d797202984cb874e3ed9f1388593d34ee22 upstream.

The is_path_accessible check uses a QPathInfo call, which isn't
supported by ancient win9x era servers. Fall back to an older
SMBQueryInfo call if it fails with the magic error codes.

Reported-and-Tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2657,6 +2657,11 @@ is_path_accessible(int xid, struct cifsT
 			      0 /* not legacy */, cifs_sb->local_nls,
 			      cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+				  CIFS_MOUNT_MAP_SPECIAL_CHR);
 	kfree(pfile_info);
 	return rc;
 }


