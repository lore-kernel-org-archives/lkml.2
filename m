Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1BFNbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:31:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60246 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1BFNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hG3ZCEyhJsPyR+Yt0ml46/iIYFX7qawF6S124JiEYqQHlLTh04GD2+ygZm3ntWZV07
         f5NUusSMS509eZgshB26Nqf77z9zEdY9n/9YOZHB/6NZk9IOLaJl2bEAdJU+JWPocHZt
         Js4zsvw7yBX54Wb+9er65QGz5eYTPNdQbzR+E=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] memblock: Fix error path in memblock_add_region()
Date: Sun,  6 Feb 2011 22:31:15 +0900
Message-Id: <1296999075-8022-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@type->regions should be restored if memblock_double_array() fails.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index bdba245d8afd..49284f9f99a6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -379,6 +379,10 @@ static long __init_memblock memblock_add_region(struct memblock_type *type, phys
 	 */
 	if (type->cnt == type->max && memblock_double_array(type)) {
 		type->cnt--;
+		for (++i; i < type->cnt; i++) {
+			type->regions[i].base = type->regions[i+1].base;
+			type->regions[i].size = type->regions[i+1].size;
+		}
 		return -1;
 	}
 
-- 
1.7.3.4.600.g982838b0

