Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1CUXQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:16:12 -0400
Received: from kroah.org ([198.145.64.141]:49496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab1CUXPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:14 2011
Message-Id: <20110321230714.577012682@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [52/87] NFS: Fix a decoding problem in nfs3_decode_dirent
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

[This needs to be applied to 2.6.37 only. The bug in question was
inadvertently fixed by a series of cleanups in 2.6.38, but the patches
in question are too large to be backported. This patch is a minimal fix
that serves the same purpose.]

When we decode a filename followed by an 8-byte cookie, we need to
consider the fact that the filename and cookie are 32-bit word aligned.
Presently, we may end up copying insufficient amounts of data when
xdr_inline_decode() needs to invoke xdr_copy_to_scratch to deal
with a page boundary.

The following patch fixes the issue by first decoding the filename, and
then decoding the cookie.

Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs2xdr.c |    6 ++++--
 fs/nfs/nfs3xdr.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -477,11 +477,13 @@ nfs_decode_dirent(struct xdr_stream *xdr
 	entry->ino	  = ntohl(*p++);
 	entry->len	  = ntohl(*p++);
 
-	p = xdr_inline_decode(xdr, entry->len + 4);
+	p = xdr_inline_decode(xdr, entry->len);
 	if (unlikely(!p))
 		goto out_overflow;
 	entry->name	  = (const char *) p;
-	p		 += XDR_QUADLEN(entry->len);
+	p = xdr_inline_decode(xdr, 4);
+	if (unlikely(!p))
+		goto out_overflow;
 	entry->prev_cookie	  = entry->cookie;
 	entry->cookie	  = ntohl(*p++);
 
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -614,11 +614,13 @@ nfs3_decode_dirent(struct xdr_stream *xd
 	p = xdr_decode_hyper(p, &entry->ino);
 	entry->len  = ntohl(*p++);
 
-	p = xdr_inline_decode(xdr, entry->len + 8);
+	p = xdr_inline_decode(xdr, entry->len);
 	if (unlikely(!p))
 		goto out_overflow;
 	entry->name = (const char *) p;
-	p += XDR_QUADLEN(entry->len);
+	p = xdr_inline_decode(xdr, 8);
+	if (unlikely(!p))
+		goto out_overflow;
 	entry->prev_cookie = entry->cookie;
 	p = xdr_decode_hyper(p, &entry->cookie);
 


