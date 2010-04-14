Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0DNO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:59:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59977 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0DNO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Efs6lYTGE0C3YwU40NzecNlt3HDvoUD4sxf2m7VtTO/ZHmvCqM9y+p3loEn7XeNQzW
         EPYH66I3akdkyGRkdCJ3ZBpQK9iYdbpT/s7GEzlBxYYIesbwVCI+h08/Vkal+aXXT1jl
         9A596IereNUQPNyZxMRSDexdwBRtdOwX4r0TI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] change alloc function in pcpu_alloc_pages
Date: Wed, 14 Apr 2010 23:58:35 +0900
Message-Id: <1271257119-30117-2-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
References: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
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

