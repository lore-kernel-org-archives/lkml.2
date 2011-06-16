Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab1FPMRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:17:37 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab1FPMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:14:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8 v3] x86, UV: correct failed topology memory leak
Cc: mingo@elte.hu
Message-Id: <E1QXBUa-0004gg-4C@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Jun 2011 07:16:12 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Fix a memory leak in init_per_cpu() when the topology checks fail.

The leak should never occur in practice.  It would only occur in an
unexpected topology that would make the BAU unuseable as a result.  

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/platform/uv/tlb_uv.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1797,15 +1797,20 @@ static int __init init_per_cpu(int nuvhu
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
