Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2KMBKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:10:37 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34144 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2KMBKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:10:36 -0500
Date: Mon, 12 Nov 2012 20:10:27 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/4] bootmem: fix wrong call parameter for free_bootmem()
Message-ID: <20121113011027.GE10092@cmpxchg.org>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
 <1352737915-30906-4-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352737915-30906-4-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:31:55AM +0900, Joonsoo Kim wrote:
> It is somehow strange that alloc_bootmem return virtual address
> and free_bootmem require physical address.
> Anyway, free_bootmem()'s first parameter should be physical address.
> 
> There are some call sites for free_bootmem() with virtual address.
> So fix them.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Found another one, attached below.  The free_bootmem() in
arch/powerpc/platforms/82xx/pq2ads-pci-pic.c looks also fishy, since
it's applied to memory from kzalloc().  Ben?

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 7d5a6b4..1963680 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -565,7 +565,7 @@ int __init smu_init (void)
 fail_db_node:
 	of_node_put(smu->db_node);
 fail_bootmem:
-	free_bootmem((unsigned long)smu, sizeof(struct smu_device));
+	free_bootmem(__pa(smu), sizeof(struct smu_device));
 	smu = NULL;
 fail_np:
 	of_node_put(np);
