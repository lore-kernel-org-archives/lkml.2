Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1C0H6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 03:58:22 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35773 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1C0H6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 03:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SLiIA/rwsBs0XVe9cCFholohFeanVTCigzlw+TrnewKe7/lGcgCzv+5StfwGNtylS2
         YVOwXTYKYfkUzmwxNSNXB8Swy69Nk6/1ICj+zt61lG/8uiOTnm5mlTzb16NYIMQjCzku
         9Zkb7Wg0yp0JGkAmCwlgh6fjut2SDSxpdHoJo=
MIME-Version: 1.0
Date: Sun, 27 Mar 2011 15:58:19 +0800
Message-ID: <AANLkTim3jJi4ZMZHGztyS==wCJ5C-tLbRe99Qj0YnDe3@mail.gmail.com>
Subject: [PATCH] uio: fix finding mm index for vma
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When finding mm index for vma it looks more flexible that the mm could
be sparse, and
both the size of mm and the pgoff of vma could give correct selection.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
+++ b/drivers/uio/uio.c	2011-03-27 14:33:02.000000000 +0800
@@ -587,14 +587,12 @@ static ssize_t uio_write(struct file *fi

 static int uio_find_mem_index(struct vm_area_struct *vma)
 {
-	int mi;
 	struct uio_device *idev = vma->vm_private_data;

-	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
-		if (idev->info->mem[mi].size == 0)
+	if (vma->vm_pgoff < MAX_UIO_MAPS) {
+		if (idev->info->mem[vma->vm_pgoff].size == 0)
 			return -1;
-		if (vma->vm_pgoff == mi)
-			return mi;
+		return (int)vma->vm_pgoff;
 	}
 	return -1;
 }
