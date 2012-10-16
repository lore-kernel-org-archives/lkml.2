Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2JPR62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:58:28 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:46070 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2JPR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:58:26 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, rmk+kernel@arm.linux.org.uk
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] ARM: kexec: fix segment memory addresses check
Date: Tue, 16 Oct 2012 20:57:24 +0300
Message-Id: <1350410244-12240-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c564df4db85aac8d1d65a56176a0a25f46138064 (ARM: 7540/1: kexec:
Check segment memory addresses) added a safety check with accidentally
reversed condition, and broke kexec functionality on ARM. Fix this.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/arm/kernel/machine_kexec.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index e29c333..8ef8c93 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -45,10 +45,9 @@ int machine_kexec_prepare(struct kimage *image)
 	for (i = 0; i < image->nr_segments; i++) {
 		current_segment = &image->segment[i];
 
-		err = memblock_is_region_memory(current_segment->mem,
-						current_segment->memsz);
-		if (err)
-			return - EINVAL;
+		if (!memblock_is_region_memory(current_segment->mem,
+					       current_segment->memsz))
+			return -EINVAL;
 
 		err = get_user(header, (__be32*)current_segment->buf);
 		if (err)
-- 
1.7.2.5

