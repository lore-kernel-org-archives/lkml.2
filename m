Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1FNXGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:06:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624Ab1FNXGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:06:07 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5 of 6] x86, UV: correct UV2 BAU destination timeout
Cc: mingo@elte.hu
Message-Id: <E1QWchY-0004NU-7b@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Jun 2011 18:07:16 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Fix a memory leak in init_per_cpu() when the topology checks fail.

(applies with fuzz if not after earlier patches)

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/platform/uv/tlb_uv.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1799,15 +1799,20 @@ static int __init init_per_cpu(int nuvhu
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 
 	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
-		return 1;
+		goto fail;
 
 	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask))
-		return 1;
+		goto fail;
 
 	kfree(uvhub_descs);
 	kfree(uvhub_mask);
 	init_per_cpu_tunables();
 	return 0;
+
+fail:
+	kfree(uvhub_descs);
+	kfree(uvhub_mask);
+	return 1;
 }
 
 /*
