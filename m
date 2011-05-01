Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1EAKqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 06:46:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53916 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1EAKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 06:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KOWNFbE/XihlY5mLTxWKqsett9omXfcrS/G5YlOgYA3HNcnVB7iz35rvLbCCdT6SMM
         1kxc/NMSU2mi2mhL5EOXcyolebl+ZuHlrTWaQ5jMUSzp7arwL18ZJlJQg3llbjuyruhI
         M+6FaEy4usHTc8A23+BU0atJUdK3DWAIwqAJ8=
Date: Sun, 1 May 2011 12:45:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH tip:x86/urgent] x86, NUMA: Fix empty memblk detection in
 numa_cleanup_meminfo()
Message-ID: <20110501104555.GN29280@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Fix it by using >= instead of ==.

tj: Extracted the actual fix from the original patch and rewrote patch
    description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Ingo, can you please push this to mainline?  Once it hits x86/urgent,
I'll regenerate the 32bit NUMA unification branch on top of it with
Yinghai's other patches and send pull request for x86/mm.

Thank you.

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
