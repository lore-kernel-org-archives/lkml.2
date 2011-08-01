Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1HAX2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:28:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab1HAX2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:28:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:57 2011
Message-Id: <20110801232057.441308252@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-commits@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: [68/70] cifs: lower default and max wsize to what 2.6.39 can handle
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

This patch is intended for 2.6.39-stable kernels only and is needed to
fix a regression introduced in 2.6.39. Prior to 2.6.39, when signing was
enabled on a socket the client only sent single-page writes. This
changed with commit ca83ce3, which made signed and unsigned connections
use the same codepaths for write calls.

This caused a regression when working with windows servers. Windows
machines will reject writes larger than the MaxBufferSize when signing
is active, but do not clear the CAP_LARGE_WRITE_X flag in the protocol
negotiation. The upshot is that when signing is active, windows servers
often reject large writes from the client in 2.6.39.

Because 3.0 adds support for larger wsize values, simply cherry picking
the upstream patches that fix the wsize negotiation isn't sufficient to
fix this issue. We also need to alter the maximum and default values to
something suitable for 2.6.39.

This patch also accounts for the change in field name from sec_mode to
secMode that went into 3.0.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/connect.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2648,16 +2648,8 @@ static void setup_cifs_sb(struct smb_vol
 			   "mount option supported");
 }
 
-/*
- * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not including
- * the RFC1001 length.
- *
- * Note that this might make for "interesting" allocation problems during
- * writeback however as we have to allocate an array of pointers for the
- * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
- */
-#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
+/* Prior to 3.0, cifs couldn't handle writes larger than this */
+#define CIFS_MAX_WSIZE (PAGEVEC_SIZE * PAGE_CACHE_SIZE)
 
 /*
  * When the server doesn't allow large posix writes, only allow a wsize of
@@ -2666,12 +2658,8 @@ static void setup_cifs_sb(struct smb_vol
  */
 #define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
 
-/*
- * The default wsize is 1M. find_get_pages seems to return a maximum of 256
- * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
- * a single wsize request with a single call.
- */
-#define CIFS_DEFAULT_WSIZE (1024 * 1024)
+/* Make the default the same as the max */
+#define CIFS_DEFAULT_WSIZE CIFS_MAX_WSIZE
 
 static unsigned int
 cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)


