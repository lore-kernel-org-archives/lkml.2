Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1HNQHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:07:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1HNQHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.203266380@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [35/90] cifs: convert prefixpath delimiters in
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 cifs_build_path_to_root

From: Jeff Layton <jlayton@redhat.com>

commit f9e8c45002cacad536b338dfa9e910e341a49c31 upstream.

Regression from 2.6.39...

The delimiters in the prefixpath are not being converted based on
whether posix paths are in effect. Fixes:

    https://bugzilla.redhat.com/show_bug.cgi?id=727834

Reported-and-Tested-by: Iain Arnell <iarnell@gmail.com>
Reported-by: Patrick Oltmann <patrick.oltmann@gmx.net>
Cc: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -764,20 +764,10 @@ char *cifs_build_path_to_root(struct smb
 	if (full_path == NULL)
 		return full_path;
 
-	if (dfsplen) {
+	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
-		/* switch slash direction in prepath depending on whether
-		 * windows or posix style path names
-		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
-			int i;
-			for (i = 0; i < dfsplen; i++) {
-				if (full_path[i] == '\\')
-					full_path[i] = '/';
-			}
-		}
-	}
 	strncpy(full_path + dfsplen, vol->prepath, pplen);
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	full_path[dfsplen + pplen] = 0; /* add trailing null */
 	return full_path;
 }


