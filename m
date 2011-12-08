Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1LHWdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:33:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36246 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1LHWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:33:32 -0500
Date: Thu, 8 Dec 2011 14:33:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Subrata Modak <subrata@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>, Manas k Nayak <maknayak@in.ibm.com>,
        Mark Wizner <markwiz@us.ibm.com>, Pavaman <pavsubra@in.ibm.com>,
        Naveed <naveedaus@in.ibm.com>, "divya.vikas" <divya.vikas@in.ibm.com>,
        Vishu <svishuku@in.ibm.com>
Subject: [patch] powerpc, mm: fix section mismatch for
 mark_reserved_regions_for_nid
In-Reply-To: <1323371433.23534.8.camel@subratamodak.linux.ibm.com>
Message-ID: <alpine.DEB.2.00.1112081428290.28693@chino.kir.corp.google.com>
References: <1323371433.23534.8.camel@subratamodak.linux.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Subrata Modak wrote:

> WARNING: vmlinux.o(.text+0x4c760): Section mismatch in reference from
> the function .mark_reserved_regions_for_nid() to the
> function .meminit.text:.early_pfn_to_nid()
> The function .mark_reserved_regions_for_nid() references
> the function __meminit .early_pfn_to_nid().
> This is often because .mark_reserved_regions_for_nid lacks a __meminit 
> annotation or the annotation of .early_pfn_to_nid is wrong.
> 
> WARNING: vmlinux.o(.text+0x4c780): Section mismatch in reference from
> the function .mark_reserved_regions_for_nid() to the
> function .init.text:.work_with_active_regions()
> The function .mark_reserved_regions_for_nid() references
> the function __init .work_with_active_regions().
> This is often because .mark_reserved_regions_for_nid lacks a __init 
> annotation or the annotation of .work_with_active_regions is wrong.
> 
> WARNING: vmlinux.o(.text+0x4c7d4): Section mismatch in reference from
> the function .mark_reserved_regions_for_nid() to the
> function .meminit.text:.early_pfn_to_nid()
> The function .mark_reserved_regions_for_nid() references
> the function __meminit .early_pfn_to_nid().
> This is often because .mark_reserved_regions_for_nid lacks a __meminit 
> annotation or the annotation of .early_pfn_to_nid is wrong.
> 
> WARNING: vmlinux.o(.text+0x4c7f0): Section mismatch in reference from
> the function .mark_reserved_regions_for_nid() to the
> function .init.text:.work_with_active_regions()
> The function .mark_reserved_regions_for_nid() references
> the function __init .work_with_active_regions().
> This is often because .mark_reserved_regions_for_nid lacks a __init 
> annotation or the annotation of .work_with_active_regions is wrong.
> 
> WARNING: vmlinux.o(.text+0x4c828): Section mismatch in reference from
> the function .mark_reserved_regions_for_nid() to the
> function .init.text:.reserve_bootmem_node()
> The function .mark_reserved_regions_for_nid() references
> the function __init .reserve_bootmem_node().
> This is often because .mark_reserved_regions_for_nid lacks a __init 
> annotation or the annotation of .reserve_bootmem_node is wrong.
> 

Wow, lots of ibm folks on the cc :)  I can only talk about the mm related 
section mismatches, but these five can easily be solved with the 
following.


powerpc, mm: fix section mismatch for mark_reserved_regions_for_nid

mark_reserved_regions_for_nid() is only called from do_init_bootmem(), 
which is in .init.text, so it must be in the same section to avoid a 
section mismatch warning.

Reported-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/powerpc/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -969,7 +969,7 @@ static struct notifier_block __cpuinitdata ppc64_numa_nb = {
 	.priority = 1 /* Must run before sched domains notifier. */
 };
 
-static void mark_reserved_regions_for_nid(int nid)
+static void __init mark_reserved_regions_for_nid(int nid)
 {
 	struct pglist_data *node = NODE_DATA(nid);
 	struct memblock_region *reg;
