Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2GIOiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab2GIOiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:09 -0400
Message-Id: <20120709143122.690073244@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        "David H. Durgee" <dhdurgee@acm.org>
Subject: [ 42/48] cifs: when server doesnt set CAP_LARGE_READ_X, cap default rsize at
 MaxBufferSize
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit ec01d738a1691dfc85b96b9f796020267a7be577 upstream.

When the server doesn't advertise CAP_LARGE_READ_X, then MS-CIFS states
that you must cap the size of the read at the client's MaxBufferSize.
Unfortunately, testing with many older servers shows that they often
can't service a read larger than their own MaxBufferSize.

Since we can't assume what the server will do in this situation, we must
be conservative here for the default. When the server can't do large
reads, then assume that it can't satisfy any read larger than its
MaxBufferSize either.

Luckily almost all modern servers can do large reads, so this won't
affect them. This is really just for older win9x and OS/2 era servers.
Also, note that this patch just governs the default rsize. The admin can
always override this if he so chooses.

Reported-by: David H. Durgee <dhdurgee@acm.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steven French <sfrench@w500smf.(none)>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/connect.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5b38407..0ae86dd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3495,18 +3495,15 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	 * MS-CIFS indicates that servers are only limited by the client's
 	 * bufsize for reads, testing against win98se shows that it throws
 	 * INVALID_PARAMETER errors if you try to request too large a read.
+	 * OS/2 just sends back short reads.
 	 *
-	 * If the server advertises a MaxBufferSize of less than one page,
-	 * assume that it also can't satisfy reads larger than that either.
-	 *
-	 * FIXME: Is there a better heuristic for this?
+	 * If the server doesn't advertise CAP_LARGE_READ_X, then assume that
+	 * it can't handle a read request larger than its MaxBufferSize either.
 	 */
 	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
 		defsize = CIFS_DEFAULT_IOSIZE;
 	else if (server->capabilities & CAP_LARGE_READ_X)
 		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
-	else if (server->maxBuf >= PAGE_CACHE_SIZE)
-		defsize = CIFSMaxBufSize;
 	else
 		defsize = server->maxBuf - sizeof(READ_RSP);
 


