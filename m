Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0IRTUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:20:03 -0400
Received: from kroah.org ([198.145.64.141]:43877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab0IRTQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:21 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:06 2010
Message-Id: <20100918191306.741787724@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [110/129] cifs: fix potential double put of TCP session reference
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 460cf3411b858ad509d5255e0dfaf862a83c0299 upstream.

cifs_get_smb_ses must be called on a server pointer on which it holds an
active reference. It first does a search for an existing SMB session. If
it finds one, it'll put the server reference and then try to ensure that
the negprot is done, etc.

If it encounters an error at that point then it'll return an error.
There's a potential problem here though. When cifs_get_smb_ses returns
an error, the caller will also put the TCP server reference leading to a
double-put.

Fix this by having cifs_get_smb_ses only put the server reference if
it found an existing session that it could use and isn't returning an
error.

Reviewed-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1647,9 +1647,6 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	if (ses) {
 		cFYI(1, "Existing smb sess found (status=%d)", ses->status);
 
-		/* existing SMB ses has a server reference already */
-		cifs_put_tcp_session(server);
-
 		mutex_lock(&ses->session_mutex);
 		rc = cifs_negotiate_protocol(xid, ses);
 		if (rc) {
@@ -1672,6 +1669,9 @@ cifs_get_smb_ses(struct TCP_Server_Info
 			}
 		}
 		mutex_unlock(&ses->session_mutex);
+
+		/* existing SMB ses has a server reference already */
+		cifs_put_tcp_session(server);
 		FreeXid(xid);
 		return ses;
 	}


