Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1BYLQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:16:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39255 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1BYLQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m34Xxinzj1Pj28iYEhwddK2uqoOs0++S7dSwmKrRE4QtdYBJ50lAJi0Pcoyoqf0AMi
         cD8M+odQdqsd8uUr33EjjXqmDguzLd1JS6gCKx1f/OEC9m+33vHJnCjg99RQ45MyRUgA
         RguwtW1l3XGo0JkRb4y16njYHEwbdR4LEspJI=
Date: Fri, 25 Feb 2011 12:16:06 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110225111606.GG24828@htj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D674A33.8000809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:20:35PM -0800, Yinghai Lu wrote:
> tj pointed out:
> 	when node does not have 1G aligned boundary, like 128M.
> init_memory_mapping_high() could render smaller mapping by 128M on one node,
> and 896M on next node with 2M pages instead of 1g page. that could increase
> TLB presure.
> 
> So if gb page is used, try to align the boundary to 1G before calling
> init_memory_mapping_ext(), to make sure only use one 1g entry for that cross
> node 1G.
> Need to init_meory_mapping_ext() to table tbl_end, to make sure pgtable is on
> previous node instead of next node.

I don't know, Yinghai.  The whole code seems overly complicated to me.
Just ignore e820 map when building linear mapping.  It doesn't matter.
Why not just do something like the following?  Also, can you please
add some comments explaining how the NUMA affine allocation actually
works for page tables?  Or better, can you please make that explicit?
It currently depends on memories being registered in ascending address
order, right?  The memblock code already is NUMA aware, I think it
would be far better to make the node affine part explicit.

Thanks.

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 46e684f..4fd0b59 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -966,6 +966,11 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 
 	/*
+	 * Add whole lot of comment explaining what's going on and WHY
+	 * because as it currently stands, it's frigging cryptic.
+	 */
+
+	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
 	 */
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7757d22..50ec03c 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -536,8 +536,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	init_memory_mapping_high();
-
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
 		u64 start = (u64)max_pfn << PAGE_SHIFT;
@@ -550,8 +548,12 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 			end = max(mi->blk[i].end, end);
 		}
 
-		if (start < end)
+		if (start < end) {
+			init_memory_mapping(
+			  ALIGN_DOWN_TO_MAX_MAP_SIZE_AND_CONVERT_TO_PFN(start),
+			  ALIGN_UP_SIMILARY_BUT_DONT_GO_OVER_MAX_PFN(end));
 			setup_node_bootmem(nid, start, end);
+		}
 	}
 
 	return 0;


-- 
tejun
