Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1DATQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:16:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1DATQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kV+PZoLZr1fsrzrawI+/ENu1wvAeKOndxnUi3DPjOJxeNnyknt7yIXIPDa7WK0wRyJ
         jnadYD/78chJ1yRtsq2NDyLPBtZiDkTu4RmyQc48tZI87QyirS2kGKHoM/jBPRQg47uf
         b+oOdhI9MNDWAToyKaF9IhmGUGGjLEJE7ufLs=
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: mingo@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, Maksym Planeta <mcsim.planeta@gmail.com>
Subject: [PATCH] page: get_order() optimization
Date: Fri,  1 Apr 2011 22:18:13 +0300
Message-Id: <1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loop was repalaced with __builtin_clz(). This still allows to precompute
constants, but on some architectures it uses special instruction to
calculate order.

Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
---
 include/asm-generic/getorder.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index 67e7245..fe8020c 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -11,11 +11,9 @@ static inline __attribute_const__ int get_order(unsigned long size)
 	int order;
 
 	size = (size - 1) >> (PAGE_SHIFT - 1);
-	order = -1;
-	do {
-		size >>= 1;
-		order++;
-	} while (size);
+	order = (__builtin_clzl(size) ^ (BITS_PER_LONG - 1));
+	if (size == 0)
+		order = 0;
 	return order;
 }
 
-- 
1.7.2.3

