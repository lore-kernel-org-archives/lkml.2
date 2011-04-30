Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab1D3Mdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:33:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40284 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1D3Mde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C6I+F41mJ1HP8+a3MjicA3Rv8QkgI3vRzCXE2iyUkH1+wqVIZsShncochJkIh4ULoc
         WSl9c3uRSoMGpm8c8giJuniu8demGHOlvqrBxofXFhbX1f3WqosXjQGCXRlPth8tsLBF
         Hf+1qDM7Uk45yRwVpLW6zC5GVh2DiVGndPF70=
Date: Sat, 30 Apr 2011 14:33:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, NUMA: Fix empty memblk detection in
 numa_cleanup_meminfo()
Message-ID: <20110430123330.GG29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <4DBB1C16.3070307@kernel.org>
 <20110430121734.GF29280@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430121734.GF29280@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

numa_cleanup_meminfo() trims each memblk between low (0) and high
(max_pfn) limits and discard empty ones.  However, the emptiness
detection incorrectly used equality test.  If the start of a memblk is
higher than max_pfn, it is empty but fails the equality test and
doesn't get discarded.

Fix it by using >= instead of ==.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
So, something like this.  Does this fix the problem you see?

Thanks.

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
