Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1AVNNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:13:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1AVNN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tpoJudmxXsLSi0ghdoL3TsqrjOsDivScqaA/fsEfXCNqPfodRqv9e6Bdxvby+2o3JG
         U7NYTaa0qqBKwfCw+ur1OOlQLsw2HXf+zwB4/OQtxYLDQlcBLKGW3Fl+5jg02o56RXNp
         FGtErkVh3b+rad81SvNqGG/nSNbYoLkaadanc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andy Grover <andy.grover@oracle.com>, rds-devel@oss.oracle.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v5 02/27] rds: stop including asm-generic/bitops/le.h directly
Date: Sat, 22 Jan 2011 22:13:34 +0900
Message-Id: <1295702039-23186-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/bitops/le.h is only intended to be included directly from
asm-generic/bitops/ext2-non-atomic.h or asm-generic/bitops/minix-le.h
which implements generic ext2 or minix bit operations.

This stops including asm-generic/bitops/le.h directly and use ext2
non-atomic bit operations instead.

It seems odd to use ext2_*_bit() on rds, but it will replaced with
__{set,clear,test}_bit_le() after introducing little endian bit operations
for all architectures.  This indirect step is necessary to maintain
bisectability for some architectures which have their own little-endian
bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: rds-devel@oss.oracle.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

Change from v4:
 - splitted into two patches to fix a bisection hole

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 net/rds/cong.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index 75ea686..8cc322b 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -33,8 +33,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
-
-#include <asm-generic/bitops/le.h>
+#include <linux/bitops.h>
 
 #include "rds.h"
 
@@ -285,7 +284,7 @@ void rds_cong_set_bit(struct rds_cong_map *map, __be16 port)
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___set_le_bit(off, (void *)map->m_page_addrs[i]);
+	ext2_set_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
@@ -299,7 +298,7 @@ void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___clear_le_bit(off, (void *)map->m_page_addrs[i]);
+	ext2_clear_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
@@ -310,7 +309,7 @@ static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	return generic_test_le_bit(off, (void *)map->m_page_addrs[i]);
+	return ext2_test_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_add_socket(struct rds_sock *rs)
-- 
1.7.3.4

