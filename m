Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2GFTco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:32:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36343 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2GFTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:32:40 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Joe Perches <joe@perches.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 2/2,resend] sunrpc/cache.h: replace simple_strtoul
Date: Fri,  6 Jul 2012 21:31:57 +0200
Message-Id: <1341603117-13064-2-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341603117-13064-1-git-send-email-eldad@fogrefinery.com>
References: <1341603117-13064-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the usage of simple_strtoul with kstrtoint in
get_int(), since the simple_str* family doesn't account for overflow
and is deprecated.
Also, in this specific case, the long from strtol is silently converted
to an int by the caller.

As Joe Perches <joe@perches.com> suggested, this patch also removes
the redundant temporary variable rv, since kstrtoint() will not write to
anint unless it's successful.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
Resent to include improvements from Joe Perches and proper changelog as
J. Bruce Fields kindly pointed out.
 include/linux/sunrpc/cache.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 6def1f6..af42596 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -217,8 +217,6 @@ extern int qword_get(char **bpp, char *dest, int bufsize);
 static inline int get_int(char **bpp, int *anint)
 {
 	char buf[50];
-	char *ep;
-	int rv;
 	int len = qword_get(bpp, buf, sizeof(buf));
 
 	if (len < 0)
@@ -226,11 +224,9 @@ static inline int get_int(char **bpp, int *anint)
 	if (len == 0)
 		return -ENOENT;
 
-	rv = simple_strtol(buf, &ep, 0);
-	if (*ep)
+	if (kstrtoint(buf, 0, anint))
 		return -EINVAL;
 
-	*anint = rv;
 	return 0;
 }
 
-- 
1.7.10

