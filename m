Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab1EATpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 15:45:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22484 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761349Ab1EATp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 15:45:26 -0400
Message-ID: <4DBDB839.2030308@kernel.org>
Date: Sun, 01 May 2011 12:44:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, mingo@redhat.com, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, numa: Trim numa meminfo with max_pfn in separated loop
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <4DBB1C16.3070307@kernel.org> <20110430121734.GF29280@htj.dyndns.org> <20110430123330.GG29280@htj.dyndns.org> <4DBCACAA.2080902@kernel.org> <20110501102040.GM29280@htj.dyndns.org>
In-Reply-To: <20110501102040.GM29280@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DBDB846.005B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During testing 32bit numa unifying code from tj, found one system with more than
64g fail to use numa.
It turns out we do not trim that numa meminfo correctly with max_pfn. Because
start could be bigger than 64g too.
Bug fix (checking correctly) already made it to tip tree.

This one move the checking and trimming to separated loop.
So We don't need to compare low/high in following merge loops.
It makes the code more readable.

Also make one 512g numa system with 32bit get not strange print out.
befrore:
> NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
> NUMA: Node 0 [0,80000000) + [100000000,1080000000) -> [0,1000000000)

after:
> NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
> NUMA: Node 0 [0,80000000) + [100000000,1000000000) -> [0,1000000000)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/mm/numa.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa.c
+++ linux-2.6/arch/x86/mm/numa.c
@@ -272,6 +272,7 @@ int __init numa_cleanup_meminfo(struct n
 	const u64 high = PFN_PHYS(max_pfn);
 	int i, j, k;
 
+	/* Trim all entries at first */
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *bi = &mi->blk[i];
 
@@ -280,10 +281,12 @@ int __init numa_cleanup_meminfo(struct n
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start >= bi->end) {
+		if (bi->start >= bi->end)
 			numa_remove_memblk_from(i--, mi);
-			continue;
-		}
+	}
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
 
 		for (j = i + 1; j < mi->nr_blks; j++) {
 			struct numa_memblk *bj = &mi->blk[j];
@@ -313,8 +316,8 @@ int __init numa_cleanup_meminfo(struct n
 			 */
 			if (bi->nid != bj->nid)
 				continue;
-			start = max(min(bi->start, bj->start), low);
-			end = min(max(bi->end, bj->end), high);
+			start = min(bi->start, bj->start);
+			end = max(bi->end, bj->end);
 			for (k = 0; k < mi->nr_blks; k++) {
 				struct numa_memblk *bk = &mi->blk[k];
 
