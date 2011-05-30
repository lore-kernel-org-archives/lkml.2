Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1E3RGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:06:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1E3RGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Jvr8zAv/w5lrPIJlUGVUcv9Kr9+t6Vr+w6Bn5lHaelIQDFWLkmwmvMmmYnE9lqHF7C
         Ts7fYW4g1XYsdiQ5/xmnrvnmddIULxbksMysoJ7rVm4f4BkBfXoXLc+jstxLsf5hTaAM
         F2/Hn9GF43mtse1+16qOHhVUTc6M/S/Tqp4cM=
Subject: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 22:59:04 +0600
Message-ID: <1306774744.4061.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 20c18b7..72cf857 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -461,7 +461,11 @@ void refresh_cpu_vm_stats(int cpu)
 				p->expire = 3;
 #endif
 			}
+
+#ifndef CONFIG_PREEMPT
 		cond_resched();
+#endif
+
 #ifdef CONFIG_NUMA
 		/*
 		 * Deal with draining the remote pageset of this


