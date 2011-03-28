Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1C1N51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:57:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60471 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab1C1N5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=C5rokN5NCve5dfkE+FUz7AejcoWDzdarSt2z5Oeou3390fAY/wpO8LevUISVXGgAOM
         JfbawMz/ygSQ+edLtG9Or5GxrdxWds/JYjQVS1dPpy5DgSEBMYtqKIzHXzloOZ+iqR0t
         e8DzXRRfbWt2KzQWN00D1X7jL5SXcKAaxmxP4=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] nommu: fix a compile warning in do_mmap_pgoff()
Date: Mon, 28 Mar 2011 22:56:47 +0900
Message-Id: <1301320607-7259-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because 'ret' is declared as int, not unsigned long, no need to cast the
error contants into unsigned long. If you compile this code on a 64-bit
machine somehow, you'll see following warning:

  CC      mm/nommu.o
mm/nommu.c: In function ‘do_mmap_pgoff’:
mm/nommu.c:1411: warning: overflow in implicit constant conversion

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/nommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 662fd46449a6..c7af249076ac 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1400,15 +1400,15 @@ unsigned long do_mmap_pgoff(struct file *file,
 		if (capabilities & BDI_CAP_MAP_DIRECT) {
 			addr = file->f_op->get_unmapped_area(file, addr, len,
 							     pgoff, flags);
-			if (IS_ERR((void *) addr)) {
+			if (IS_ERR_VALUE(addr)) {
 				ret = addr;
-				if (ret != (unsigned long) -ENOSYS)
+				if (ret != -ENOSYS)
 					goto error_just_free;
 
 				/* the driver refused to tell us where to site
 				 * the mapping so we'll have to attempt to copy
 				 * it */
-				ret = (unsigned long) -ENODEV;
+				ret = -ENODEV;
 				if (!(capabilities & BDI_CAP_MAP_COPY))
 					goto error_just_free;
 
-- 
1.7.4

