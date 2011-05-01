Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab1EARML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:12:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1EARMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RA7b/HmICbtiiFji2Fx32veV4v3LHoDfnMj414YP73ERiU58EE9Gsy9cha9qf0a0Ng
         wp7/wK0m6WnLSA5BFiAqvUqnu4pJgCRCXeJp+z905R8pHRYCjjZAbBTA2P8ZQEEojcFp
         UmWvn0oHTg0Kec8syt/pKDl0Jo/3gsaFKirpY=
Date: Sun, 1 May 2011 19:12:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH REPOST tip:x86/urgent] x86, NUMA: Fix empty memblk
 detection in numa_cleanup_meminfo()
Message-ID: <20110501171204.GO29280@htj.dyndns.org>
References: <20110501104555.GN29280@htj.dyndns.org>
 <20110501165354.GC21833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501165354.GC21833@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

numa_cleanup_meminfo() trims each memblk between low (0) and high
(max_pfn) limits and discards empty ones.  However, the emptiness
detection incorrectly used equality test.  If the start of a memblk is
higher than max_pfn, it is empty but fails the equality test and
doesn't get discarded.

The condition triggers when max_pfn is lower than start of a NUMA node
and results in memory misconfiguration - leading to WARN_ON()s and
other funnies.  The bug was discovered in devel branch where 32bit too
uses this code path for NUMA init.  If a node is above the addressing
limit, max_pfn ends up lower than the node triggering this problem.

The failure hasn't been observed on x86-64 but is still possible with
broken hardware e820/NUMA info.  As the fix is very low risk, it would
be better to apply it even for 64bit.

Fix it by using >= instead of ==.

tj: Extracted the actual fix from the original patch and rewrote patch
    description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Here's the patch with updated description.  Thank you.

 arch/x86/mm/numa_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -191,7 +191,7 @@ int __init numa_cleanup_meminfo(struct n
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start == bi->end) {
+		if (bi->start >= bi->end) {
 			numa_remove_memblk_from(i--, mi);
 			continue;
 		}
