Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2GZVUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:20:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2GZVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:20:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jian Li <jiali@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 04/23] cifs: on CONFIG_HIGHMEM machines, limit the rsize/wsize to the kmap space
Date: Thu, 26 Jul 2012 14:19:43 -0700
Message-Id: <20120726211406.233551780@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3ae629d98bd5ed77585a878566f04f310adbc591 upstream.

We currently rely on being able to kmap all of the pages in an async
read or write request. If you're on a machine that has CONFIG_HIGHMEM
set then that kmap space is limited, sometimes to as low as 512 slots.

With 512 slots, we can only support up to a 2M r/wsize, and that's
assuming that we can get our greedy little hands on all of them. There
are other users however, so it's possible we'll end up stuck with a
size that large.

Since we can't handle a rsize or wsize larger than that currently, cap
those options at the number of kmap slots we have. We could consider
capping it even lower, but we currently default to a max of 1M. Might as
well allow those luddites on 32 bit arches enough rope to hang
themselves.

A more robust fix would be to teach the send and receive routines how
to contend with an array of pages so we don't need to marshal up a kvec
array at all. That's a fairly significant overhaul though, so we'll need
this limit in place until that's ready.

Reported-by: Jian Li <jiali@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3348,6 +3348,18 @@ void cifs_setup_cifs_sb(struct smb_vol *
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
 #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
+/*
+ * On hosts with high memory, we can't currently support wsize/rsize that are
+ * larger than we can kmap at once. Cap the rsize/wsize at
+ * LAST_PKMAP * PAGE_SIZE. We'll never be able to fill a read or write request
+ * larger than that anyway.
+ */
+#ifdef CONFIG_HIGHMEM
+#define CIFS_KMAP_SIZE_LIMIT	(LAST_PKMAP * PAGE_CACHE_SIZE)
+#else /* CONFIG_HIGHMEM */
+#define CIFS_KMAP_SIZE_LIMIT	(1<<24)
+#endif /* CONFIG_HIGHMEM */
+
 static unsigned int
 cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 {
@@ -3378,6 +3390,9 @@ cifs_negotiate_wsize(struct cifs_tcon *t
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
+	/* limit to the amount that we can kmap at once */
+	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
+
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
 
@@ -3419,6 +3434,9 @@ cifs_negotiate_rsize(struct cifs_tcon *t
 	if (!(server->capabilities & CAP_LARGE_READ_X))
 		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
 
+	/* limit to the amount that we can kmap at once */
+	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
+
 	/* hard limit of CIFS_MAX_RSIZE */
 	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
 


