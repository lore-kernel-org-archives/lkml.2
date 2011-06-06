Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1FFElH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:41:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1FFElC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PJlWQWcGlKFkE//WO9fMLPP/X4+dCzFxQEi1N8S7N5EYl61WuvaWoX1p8hgNCKyEfr
         nLWrPT2oMPGX3LTTSIOQ==
Date: Sun, 5 Jun 2011 21:40:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 13/14] mm: pincer in truncate_inode_pages_range
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052139460.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

truncate_inode_pages_range()'s final loop has a nice pincer property,
bringing start and end together, squeezing out the last pages.  But
the range handling missed out on that, just sliding up the range,
perhaps letting pages come in behind it.  Add one more test to give
it the same pincer effect.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/truncate.c	2011-06-05 19:25:13.112013371 -0700
+++ linux/mm/truncate.c	2011-06-05 19:27:12.244611885 -0700
@@ -269,7 +269,7 @@ void truncate_inode_pages_range(struct a
 			index = start;
 			continue;
 		}
-		if (pvec.pages[0]->index > end) {
+		if (index == start && pvec.pages[0]->index > end) {
 			pagevec_release(&pvec);
 			break;
 		}
