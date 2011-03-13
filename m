Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1CMPs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:48:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1CMPsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l0MZajGyQzB1c1uW3FqlB8BLW80fW/K4ysNGNkTnE6hd9fu/AjE3dTQ2WeRsJajRml
         RuhLWdZRQqz8ZM98vVaot1aijIrcp8tEBTPCQVBpOXD5OuOZoC7cJG0cXTXTRgBxTaLh
         x5WyfVpUmm55jBiJHMBRPUChr9bWwM7PtyEk4=
MIME-Version: 1.0
Date: Sun, 13 Mar 2011 21:48:23 +0600
Message-ID: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
Subject: [PATCH] fs, coda: Fix compile warning when CONFIG_SYSCTL=n.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SYSCTL=n, we get the following warning:

fs/coda/sysctl.c:18: warning: ‘coda_table’ defined but not used

Following patches fixes the above warning by making sure coda_table
and it's callee
function are in the same context. It also cleans up the code by
removing extra #ifdef.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index c6405ce..d9cc2b3 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -13,7 +13,6 @@

 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
-#endif

 static ctl_table coda_table[] = {
 	{
@@ -40,7 +39,6 @@ static ctl_table coda_table[] = {
 	{}
 };

-#ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
@@ -49,22 +47,23 @@ static ctl_table fs_table[] = {
 	},
 	{}
 };
-#endif

 void coda_sysctl_init(void)
 {
-#ifdef CONFIG_SYSCTL
 	if ( !fs_table_header )
 		fs_table_header = register_sysctl_table(fs_table);
-#endif
 }

 void coda_sysctl_clean(void)
 {
-#ifdef CONFIG_SYSCTL
 	if ( fs_table_header ) {
 		unregister_sysctl_table(fs_table_header);
 		fs_table_header = NULL;
 	}
-#endif
 }
+#else
+
+#define	coda_sysctl_init()		do { }  while (0);
+#define	coda_sysctl_clean()		do { }	while (0);
+
+#endif
