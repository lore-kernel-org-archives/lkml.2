Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0G3RDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:35 -0400
Received: from kroah.org ([198.145.64.141]:35505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0G3RDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:54 2010
Message-Id: <20100730165954.210931660@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steve French <sfrench@us.ibm.com>
Subject: [04/17] cifs: Fix a kernel BUG with remote OS/2 server (try #3)
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.de>

commit 6513a81e9325d712f1bfb9a1d7b750134e49ff18 upstream.

While chasing a bug report involving a OS/2 server, I noticed the server sets
pSMBr->CountHigh to a incorrect value even in case of normal writes. This
results in 'nbytes' being computed wrongly and triggers a kernel BUG at
mm/filemap.c.

void iov_iter_advance(struct iov_iter *i, size_t bytes)
{
        BUG_ON(i->count < bytes);    <--- BUG here

Why the server is setting 'CountHigh' is not clear but only does so after
writing 64k bytes. Though this looks like the server bug, the client side
crash may not be acceptable.

The workaround is to mask off high 16 bits if the number of bytes written as
returned by the server is greater than the bytes requested by the client as
suggested by Jeff Layton.

Reviewed-by: Jeff Layton <jlayton@samba.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifssmb.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1594,6 +1594,14 @@ CIFSSMBWrite(const int xid, struct cifsT
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
 		*nbytes += le16_to_cpu(pSMBr->Count);
+
+		/*
+		 * Mask off high 16 bits when bytes written as returned by the
+		 * server is greater than bytes requested by the client. Some
+		 * OS/2 servers are known to set incorrect CountHigh values.
+		 */
+		if (*nbytes > count)
+			*nbytes &= 0xFFFF;
 	}
 
 	cifs_buf_release(pSMB);
@@ -1679,6 +1687,14 @@ CIFSSMBWrite2(const int xid, struct cifs
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
 		*nbytes += le16_to_cpu(pSMBr->Count);
+
+		/*
+		 * Mask off high 16 bits when bytes written as returned by the
+		 * server is greater than bytes requested by the client. OS/2
+		 * servers are known to set incorrect CountHigh values.
+		 */
+		if (*nbytes > count)
+			*nbytes &= 0xFFFF;
 	}
 
 /*	cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */


