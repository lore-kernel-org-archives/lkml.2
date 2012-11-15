Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2KOEVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:21:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:49823 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993270Ab2KOEMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [ 26/57] nfsd: add get_uint for u32s
Date: Wed, 14 Nov 2012 20:11:34 -0800
Message-Id: <20121115040934.837335930@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a007c4c3e943ecc054a806c259d95420a188754b upstream.

I don't think there's a practical difference for the range of values
these interfaces should see, but it would be safer to be unambiguous.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/export.c             |    6 +++---
 include/linux/sunrpc/cache.h |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -401,7 +401,7 @@ fsloc_parse(char **mesg, char *buf, stru
 	int migrated, i, err;
 
 	/* listsize */
-	err = get_int(mesg, &fsloc->locations_count);
+	err = get_uint(mesg, &fsloc->locations_count);
 	if (err)
 		return err;
 	if (fsloc->locations_count > MAX_FS_LOCATIONS)
@@ -459,7 +459,7 @@ static int secinfo_parse(char **mesg, ch
 		return -EINVAL;
 
 	for (f = exp->ex_flavors; f < exp->ex_flavors + listsize; f++) {
-		err = get_int(mesg, &f->pseudoflavor);
+		err = get_uint(mesg, &f->pseudoflavor);
 		if (err)
 			return err;
 		/*
@@ -468,7 +468,7 @@ static int secinfo_parse(char **mesg, ch
 		 * problem at export time instead of when a client fails
 		 * to authenticate.
 		 */
-		err = get_int(mesg, &f->flags);
+		err = get_uint(mesg, &f->flags);
 		if (err)
 			return err;
 		/* Only some flags are allowed to differ between flavors: */
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -228,6 +228,22 @@ static inline int get_int(char **bpp, in
 	return 0;
 }
 
+static inline int get_uint(char **bpp, unsigned int *anint)
+{
+	char buf[50];
+	int len = qword_get(bpp, buf, sizeof(buf));
+
+	if (len < 0)
+		return -EINVAL;
+	if (len == 0)
+		return -ENOENT;
+
+	if (kstrtouint(buf, 0, anint))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * timestamps kept in the cache are expressed in seconds
  * since boot.  This is the best for measuring differences in


