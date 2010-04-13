Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0DMPZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:25:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51859 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0DMPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bnRIBADG4y1ipNRa0pj8eG7Wab0U0eqbbpK6JFRZqeXs/0cHd8glOmPRgjaUetR2Ti
         V+5AtlV1L+2N/M353qZ4vjG9YR9WmVyXoR/fpOvCWFZDy/nnPRLoOkunfcxm80GlSw2c
         fjuxJ6PNXC81pU9jlIN0V4RoxQY9bhf7KrqDs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 2/6] change alloc function in pcpu_alloc_pages
Date: Wed, 14 Apr 2010 00:24:59 +0900
Message-Id: <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pages_node is called with cpu_to_node(cpu).
I think cpu_to_node(cpu) never returns -1.
(But I am not sure we need double check.)

So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 768419d..ec3e671 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -720,7 +720,7 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 		for (i = page_start; i < page_end; i++) {
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			*pagep = alloc_pages_exact_node(cpu_to_node(cpu), gfp, 0);
 			if (!*pagep) {
 				pcpu_free_pages(chunk, pages, populated,
 						page_start, page_end);
-- 
1.7.0.5

