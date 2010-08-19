Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0HSOuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:50:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0HSOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:50:07 -0400
Subject: [PATCH] percpu: Fix memory leak from percpu_init_late()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Date: Thu, 19 Aug 2010 15:49:56 +0100
Message-ID: <20100819144956.27058.69126.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2010 14:49:57.0129 (UTC) FILETIME=[CA9BC790:01CB3FAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chunk->map memory block allocated in percpu_init_late() (as of
commit 099a19d9) is later overridden in pcpu_extend_area_map(). The
patch frees this existing block in the latter function. Found by
kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index e61dc2c..c0d3329 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -394,6 +394,7 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk, int new_alloc)
 
 	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
 	memcpy(new, chunk->map, old_size);
+	pcpu_mem_free(chunk->map, old_size);
 
 	chunk->map_alloc = new_alloc;
 	chunk->map = new;

