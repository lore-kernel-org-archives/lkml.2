Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2KNFuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54911 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab2KNFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:56 -0500
Message-Id: <20121114053934.636292242@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 06/82] nfsd: add get_uint for u32s
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a007c4c3e943ecc054a806c259d95420a188754b upstream.

I don't think there's a practical difference for the range of values
these interfaces should see, but it would be safer to be unambiguous.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/export.c             |    6 +++---
 include/linux/sunrpc/cache.h |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index ba23349..1114463 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -398,7 +398,7 @@ fsloc_parse(char **mesg, char *buf, struct nfsd4_fs_locations *fsloc)
 	int migrated, i, err;
 
 	/* listsize */
-	err = get_int(mesg, &fsloc->locations_count);
+	err = get_uint(mesg, &fsloc->locations_count);
 	if (err)
 		return err;
 	if (fsloc->locations_count > MAX_FS_LOCATIONS)
@@ -456,7 +456,7 @@ static int secinfo_parse(char **mesg, char *buf, struct svc_export *exp)
 		return -EINVAL;
 
 	for (f = exp->ex_flavors; f < exp->ex_flavors + listsize; f++) {
-		err = get_int(mesg, &f->pseudoflavor);
+		err = get_uint(mesg, &f->pseudoflavor);
 		if (err)
 			return err;
 		/*
@@ -465,7 +465,7 @@ static int secinfo_parse(char **mesg, char *buf, struct svc_export *exp)
 		 * problem at export time instead of when a client fails
 		 * to authenticate.
 		 */
-		err = get_int(mesg, &f->flags);
+		err = get_uint(mesg, &f->flags);
 		if (err)
 			return err;
 		/* Only some flags are allowed to differ between flavors: */
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index af42596..f792794 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -230,6 +230,22 @@ static inline int get_int(char **bpp, int *anint)
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


