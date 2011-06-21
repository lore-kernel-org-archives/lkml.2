Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1FUMYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:24:03 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51712 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab1FUMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:43 -0400
Message-Id: <20110621122242.981533045@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:32 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 7/8 v5] x86, UV: correct failed topology memory leak
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_sanitymemleak
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak in init_per_cpu() when the topology check fails.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

The leak should never occur after development.  It would only occur in an
unexpected topology that would make the BAU unuseable as a result.  

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

