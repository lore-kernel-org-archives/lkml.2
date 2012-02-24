Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2BXTT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:19:29 -0500
Received: from gw.danplanet.com ([50.43.125.66]:45296 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709Ab2BXTT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:19:28 -0500
From: Dan Smith <danms@us.ibm.com>
To: akpm@linux-foundation.org
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	<87zkcm23az.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
Date: Fri, 24 Feb 2012 11:19:25 -0800
Message-ID: <87obsoxcn6.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DR> but it doesn't "ensure" walk_page_range() always has start and end
DR> addresses that are page aligned

Below is a changed version of the patch which always does the
check. Since failing that condition indicates a kernel bug, WARN_ON()
makes sure it gets some visibility.

Andrew, can you take this?

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

commit b06c2032d63f20d5a5513b3890776aeead397aa5
Author: Dan Smith <danms@us.ibm.com>
Date:   Fri Feb 24 11:07:05 2012 -0800

    Ensure that walk_page_range()'s start and end are page-aligned
    
    The inner function walk_pte_range() increments "addr" by PAGE_SIZE after
    each pte is processed, and only exits the loop if the result is equal to
    "end". Current, if either (or both of) the starting or ending addresses
    passed to walk_page_range() are not page-aligned, then we will never
    satisfy that exit condition and begin calling the pte_entry handler with
    bad data.
    
    To be sure that we will land in the right spot, this patch checks that
    both "addr" and "end" are page-aligned in walk_page_range() before starting
    the traversal.
    
    Signed-off-by: Dan Smith <danms@us.ibm.com>
    Cc: linux-mm@kvack.org
    Cc: linux-kernel@vger.kernel.org

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 2f5cf10..97ee963 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -196,6 +196,11 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	if (addr >= end)
 		return err;
 
+	if (WARN_ONCE((addr & ~PAGE_MASK) || (end & ~PAGE_MASK),
+		      "address range is not page-aligned")) {
+		return -EINVAL;
+	}
+
 	if (!walk->mm)
 		return -EINVAL;
 
