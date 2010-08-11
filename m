Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0HKKLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:11:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41260 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab0HKKLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:11:44 -0400
Date: Wed, 11 Aug 2010 12:11:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] fs/ecryptfs: Return -ENOMEM on memory allocation failure
Message-ID: <Pine.LNX.4.64.1008111211240.8669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ecryptfs/keystore.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 89c5476..73811cf 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -515,6 +515,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
 		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
+		rc = -ENOMEM;
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -806,6 +807,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
 		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
+		rc = -ENOMEM;
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
