Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1HAX3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:29:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab1HAX2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:28:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:57 2011
Message-Id: <20110801232057.327161857@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [67/70] cifs: fix wsize negotiation to respect max buffer size and
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 active signing (try #4)

From: Jeff Layton <jlayton@redhat.com>

commit 1190f6a067bf27b2ee7e06ec0776a17fe0f6c4d8 upstream.

Hopefully last version. Base signing check on CAP_UNIX instead of
tcon->unix_ext, also clean up the comments a bit more.

According to Hongwei Sun's blog posting here:

    http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx

CAP_LARGE_WRITEX is ignored when signing is active. Also, the maximum
size for a write without CAP_LARGE_WRITEX should be the maxBuf that
the server sent in the NEGOTIATE request.

Fix the wsize negotiation to take this into account. While we're at it,
alter the other wsize definitions to use sizeof(WRITE_REQ) to allow for
slightly larger amounts of data to potentially be written per request.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2650,21 +2650,21 @@ static void setup_cifs_sb(struct smb_vol
 
 /*
  * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24 - PAGE_CACHE_SIZE.
+ * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not including
+ * the RFC1001 length.
  *
  * Note that this might make for "interesting" allocation problems during
- * writeback however (as we have to allocate an array of pointers for the
- * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
+ * writeback however as we have to allocate an array of pointers for the
+ * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
  */
-#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
+#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
 
 /*
- * When the server doesn't allow large posix writes, default to a wsize of
- * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame size
- * described in RFC1001. This allows space for the header without going over
- * that by default.
+ * When the server doesn't allow large posix writes, only allow a wsize of
+ * 128k minus the size of the WRITE_AND_X header. That allows for a write up
+ * to the maximum size described by RFC1002.
  */
-#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
+#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
 
 /*
  * The default wsize is 1M. find_get_pages seems to return a maximum of 256
@@ -2683,11 +2683,18 @@ cifs_negotiate_wsize(struct cifsTconInfo
 
 	/* can server support 24-bit write sizes? (via UNIX extensions) */
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
-		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1001_WSIZE);
+		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1002_WSIZE);
 
-	/* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
-	if (!(server->capabilities & CAP_LARGE_WRITE_X))
-		wsize = min_t(unsigned int, wsize, USHRT_MAX);
+	/*
+	 * no CAP_LARGE_WRITE_X or is signing enabled without CAP_UNIX set?
+	 * Limit it to max buffer offered by the server, minus the size of the
+	 * WRITEX header, not including the 4 byte RFC1001 length.
+	 */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
+	    (!(server->capabilities & CAP_UNIX) &&
+	     (server->secMode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
+		wsize = min_t(unsigned int, wsize,
+				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);


