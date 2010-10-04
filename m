Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0JDMc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:32:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33128 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab0JDMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tlPXCHHmwnAJsdQsxXu4DUVSESD/+Cj6iu01+kaZtZkoOPQ9073jxTTOzwZ6Nq9So2
         55C+hIGVlFDlJ2cnvxpaJvaMm27fWSb4RhxSvn+5nd3SfZTUZpjteLqrZA6A79FXkQdV
         jPgKkRcjT1FX/2wJ7paVfH6zCu3T/9dIDxHpY=
MIME-Version: 1.0
Date: Mon, 4 Oct 2010 19:43:53 +0800
Message-ID: <AANLkTimFqQ=FRVtPZT2B6TSbugE_+Wh6TRGzck5Wf8xr@mail.gmail.com>
Subject: Ask For Comment: add offset_in_sg parameter for data copy in scatter list
From: Hillf Danton <dhillf@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, robert.w.love@intel.com,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two routines, modeled from sg_copy_from/to_buffer, are added for cases that
offset_in_sg has to be taken as a parameter.

Then it seems that the procedure of sg_miter_start/next/stop in
sg_copy_buffer()
will no longer be modeled, and all __xyz elements of miter are
untouched as well,
outside scatter list.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/include/linux/scatterlist.h	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/include/linux/scatterlist.h	2010-10-04
18:56:00.000000000 +0800
@@ -217,6 +217,12 @@ size_t sg_copy_from_buffer(struct scatte
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
+size_t sg_copy_from_buffer_offset(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen,
+			   unsigned int offset_in_sg);
+size_t sg_copy_to_buffer_offset(struct scatterlist *sgl, unsigned int nents,
+			 void *buf, size_t buflen,
+			 unsigned int offset_in_sg);

 /*
  * Maximum number of entries that will be allocated in one piece, if
--- o/linux-2.6.36-rc4/lib/scatterlist.c	2010-09-13 07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/lib/scatterlist.c	2010-10-04 19:14:10.000000000 +0800
@@ -449,7 +449,8 @@ EXPORT_SYMBOL(sg_miter_stop);
  *
  **/
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, int to_buffer)
+			     void *buf, size_t buflen, int to_buffer,
+			     unsigned int offset_in_sg)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -462,6 +463,7 @@ static size_t sg_copy_buffer(struct scat
 		sg_flags |= SG_MITER_TO_SG;

 	sg_miter_start(&miter, sgl, nents, sg_flags);
+	miter.__offset = offset_in_sg;

 	local_irq_save(flags);

@@ -497,7 +499,7 @@ static size_t sg_copy_buffer(struct scat
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, 0);
 }
 EXPORT_SYMBOL(sg_copy_from_buffer);

@@ -514,6 +516,28 @@ EXPORT_SYMBOL(sg_copy_from_buffer);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 1, 0);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+/*
+ * Like the above, and with parameter offset_in_sg
+ */
+
+size_t
+sg_copy_from_buffer_offset(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen,
+			   unsigned int offset_in_sg)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, offset_in_sg);
+}
+EXPORT_SYMBOL(sg_copy_from_buffer_offset);
+
+size_t
+sg_copy_to_buffer_offset(struct scatterlist *sgl, unsigned int nents,
+			 void *buf, size_t buflen,
+			 unsigned int offset_in_sg);
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, 1, offset_in_sg);
+}
+EXPORT_SYMBOL(sg_copy_to_buffer_offset);
