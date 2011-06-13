Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1FMCDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 22:03:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1FMCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 22:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Pob1xvCiycEXs4CDK5I7yZthCwGyE0EZmEMIA+ToOzZhhhXVlN56Bx/oIlvK1Y0PUi
         6cPDux2oXOzwmvlx5Vmw==
Date: Sun, 12 Jun 2011 19:03:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
Message-ID: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-rc won't boot with SLUB on my PowerPC G5: kernel BUG at mm/slub.c:1950!
Bisected to 1759415e630e "slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery".

After giving myself a medal for finding the BUG on line 1950 of mm/slub.c
(it's actually the
	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));
on line 268 of the morass that is include/linux/percpu.h)
I tried the following alignment patch and found it to work.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.0-rc2/include/linux/slub_def.h	2011-05-29 18:42:37.077880848 -0700
+++ linux/include/linux/slub_def.h	2011-06-12 17:17:51.000000000 -0700
@@ -43,7 +43,7 @@ struct kmem_cache_cpu {
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
-};
+} __attribute__((aligned(2 * sizeof(long))));
 
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
