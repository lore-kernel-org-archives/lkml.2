Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab0DVUAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:00:20 -0400
Received: from kroah.org ([198.145.64.141]:59615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab0DVUAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:08 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:09 2010
Message-Id: <20100422195408.939041767@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <sfrench@us.ibm.com>
Subject: [042/139] cifs: Fix a kernel BUG with remote OS/2 server (try #3)
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1517,6 +1517,14 @@ CIFSSMBWrite(const int xid, struct cifsT
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
@@ -1605,6 +1613,14 @@ CIFSSMBWrite2(const int xid, struct cifs
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


