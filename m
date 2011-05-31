Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1EaAfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:35:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7546 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1EaAfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sfgvysmVPo6nIHOtKEtc7FDYAxH/AquqM59ONuftu9QuxD6IpX5wog9fwyfLeIstdr
         TvHU/e16zFD8xDrAaYiw==
Date: Mon, 30 May 2011 17:35:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301733500.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

truncate_inode_pages_range() and invalidate_inode_pages2_range()
call cleancache_flush_inode(mapping) before and after: shouldn't
invalidate_mapping_pages() be doing the same?

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 mm/truncate.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux.orig/mm/truncate.c	2011-05-30 13:56:10.416798124 -0700
+++ linux/mm/truncate.c	2011-05-30 14:08:46.612547848 -0700
@@ -333,6 +333,7 @@ unsigned long invalidate_mapping_pages(s
 	unsigned long count = 0;
 	int i;
 
+	cleancache_flush_inode(mapping);
 	pagevec_init(&pvec, 0);
 	while (next <= end &&
 			pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
@@ -373,6 +374,7 @@ unsigned long invalidate_mapping_pages(s
 		mem_cgroup_uncharge_end();
 		cond_resched();
 	}
+	cleancache_flush_inode(mapping);
 	return count;
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
