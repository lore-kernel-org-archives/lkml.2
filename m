Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2AXCw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:52:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880Ab2AXCsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.781114748@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Shilovsky <piastry@etersoft.ru>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [122/129] cifs: lower default wsize when unix extensions are not used
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2260
Lines: 60

From: Jeff Layton <jlayton@redhat.com>

commit ce91acb3acae26f4163c5a6f1f695d1a1e8d9009 upstream.

We've had some reports of servers (namely, the Solaris in-kernel CIFS
server) that don't deal properly with writes that are "too large" even
though they set CAP_LARGE_WRITE_ANDX. Change the default to better
mirror what windows clients do.

Cc: Pavel Shilovsky <piastry@etersoft.ru>
Reported-by: Nick Davis <phireph0x@yahoo.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2914,18 +2914,33 @@ void cifs_setup_cifs_sb(struct smb_vol *
 #define CIFS_DEFAULT_IOSIZE (1024 * 1024)
 
 /*
- * Windows only supports a max of 60k reads. Default to that when posix
- * extensions aren't in force.
+ * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
+ * those values when posix extensions aren't in force. In actuality here, we
+ * use 65536 to allow for a write that is a multiple of 4k. Most servers seem
+ * to be ok with the extra byte even though Windows doesn't send writes that
+ * are that large.
+ *
+ * Citation:
+ *
+ * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
  */
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
+#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
 static unsigned int
 cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 {
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
-				CIFS_DEFAULT_IOSIZE;
+	unsigned int wsize;
+
+	/* start with specified wsize, or default */
+	if (pvolume_info->wsize)
+		wsize = pvolume_info->wsize;
+	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = CIFS_DEFAULT_IOSIZE;
+	else
+		wsize = CIFS_DEFAULT_NON_POSIX_WSIZE;
 
 	/* can server support 24-bit write sizes? (via UNIX extensions) */
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))


