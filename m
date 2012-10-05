Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2JEO5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:57:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2JEO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Ben Blum <bblum@andrew.cmu.edu>
Subject: [PATCH 07/16] cgroup: fix warning when building without any subsys
Date: Fri,  5 Oct 2012 16:55:21 +0200
Message-Id: <1349448930-23976-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:LE5XuEYuxrwkJLoRKhGJEQRYTOsl099eovMV8WrcDl/
 FHv6vqGM707U3J7JNo/XoRUKO58d75UtmW6rAMQDN/LodvRRTq
 kpBZYhPK2nQ0WQ4vb0c0Tw0G8oQ36S/C8k7FzucW7URB1GwR+B
 8kjLiZ+FMen0JSLRtSU90ZVtRJWpr4wCCyvPHUKFHeqVKvivqA
 e2dn0y4pngBlMdGhWSJy3o5dJ2SA12W1muzfx3r1lJqmSJxtvA
 Ovux/4ohZ2tm1fGtufRKLV9W9wQ9z68LSzs/OFd/Ur2r0uSkPN
 DiSx0b/b8kqMlsiyMrK5q525tLEmwHHBTTKAd6IvI2rlblLNzE
 nryaVaNKeSYcL65s6MtTmZP3aNjgM6ns8PlB67O38OkqvIhibQ
 PQlkS1WC8rGxAUNiZR3AJaGg5DQyc/aH6E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a configuration where the base cgroup support is enabled but
every single cgroup subsys is turned off, CGROUP_BUILTIN_SUBSYS_COUNT
is zero, which causes the sanity check code in cgroup_load_subsys
to trigger:

       BUG_ON(ss->subsys_id >= CGROUP_BUILTIN_SUBSYS_COUNT);
       BUG_ON(subsys[ss->subsys_id] != ss);

Gcc first confirms that subsys_id cannot be 0 or larger and consequently
warns in the second line.

kernel/cgroup.c: In function 'cgroup_load_subsys':
kernel/cgroup.c:4326:38: warning: array subscript is below array bounds [-Warray-bounds]

Since the subsys_id can never be less than zero, we can just change the
type to an unsigned int, which makes the warning go away.

Found by building ARM cns3420vb_defconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>
---
 include/linux/cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c90eaa8..26b99df 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -475,7 +475,7 @@ struct cgroup_subsys {
 	void (*post_clone)(struct cgroup *cgrp);
 	void (*bind)(struct cgroup *root);
 
-	int subsys_id;
+	unsigned int subsys_id;
 	int active;
 	int disabled;
 	int early_init;
-- 
1.7.10

