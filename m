Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1LKBTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 20:19:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45020 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LKBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 20:19:14 -0500
MIME-Version: 1.0
Date: Sun, 11 Dec 2011 09:19:12 +0800
Message-ID: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
Subject: [PATCH] mm: memcg: keep root group unchanged if fail to create new
From: Hillf Danton <dhillf@gmail.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the request is not to create root group and we fail to meet it, we'd leave
the root unchanged.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/memcontrol.c	Fri Dec  9 21:57:40 2011
+++ b/mm/memcontrol.c	Sun Dec 11 09:04:48 2011
@@ -4849,8 +4849,10 @@ mem_cgroup_create(struct cgroup_subsys *
 		enable_swap_cgroup();
 		parent = NULL;
 		root_mem_cgroup = memcg;
-		if (mem_cgroup_soft_limit_tree_init())
+		if (mem_cgroup_soft_limit_tree_init()) {
+			root_mem_cgroup = NULL;
 			goto free_out;
+		}
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
 						&per_cpu(memcg_stock, cpu);
@@ -4888,7 +4890,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
-	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
