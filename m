Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0GLPx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:53:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48668 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0GLPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hE1BeyQ77qhXu6ZxJqgOahleol0Rn2842AIEz8sSfmF1c3zVELSXd2Mn4c9hGwAg7c
         Mi62UGtHFr6Lrq1Y2EJ6Dhr1nLonkhf8D/38btQZJsyXpDAbiYelxEtCy5Ntoz0Mo3yZ
         Iflo+FH9/76m5aEUvPj88D+nq2tV76LYCaoiY=
Date: Tue, 13 Jul 2010 00:53:48 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: linux@arm.linux.org.uk, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100712155348.GA2815@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin, Could you test below patch?
I don't have any sparsemem system. Sorry. 

-- CUT DOWN HERE --

Kukjin reported oops happen while he change min_free_kbytes
http://www.spinics.net/lists/arm-kernel/msg92894.html
It happen by memory map on sparsemem. 

The system has a memory map following as. 
     section 0             section 1              section 2
0x20000000-0x25000000, 0x40000000-0x50000000, 0x50000000-0x58000000
SECTION_SIZE_BITS 28(256M)

It means section 0 is an incompletely filled section.
Nontheless, current pfn_valid of sparsemem checks pfn loosely. 

It checks only mem_section's validation.
So in above case, pfn on 0x25000000 can pass pfn_valid's validation check.
It's not what we want. 

The Following patch adds check valid pfn range check on pfn_valid of sparsemem.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Kukjin Kim <kgene.kim@samsung.com>

P.S) 
It is just RFC. If we agree with this, I will make the patch on mmotm.

--

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4d109e..6c2147a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -979,6 +979,8 @@ struct mem_section {
        struct page_cgroup *page_cgroup;
        unsigned long pad;
 #endif
+       unsigned long start_pfn;
+       unsigned long end_pfn;
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -1039,6 +1041,12 @@ static inline int valid_section(struct mem_section *section)
        return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
 
+static inline int valid_section_pfn(struct mem_section *section, unsigned long pfn)
+{
+       return ((section && (section->section_mem_map & SECTION_HAS_MEM_MAP)) &&
+               (section->start_pfn <= pfn && pfn < section->end_pfn));
+}
+
 static inline int valid_section_nr(unsigned long nr)
 {
        return valid_section(__nr_to_section(nr));
@@ -1053,7 +1061,7 @@ static inline int pfn_valid(unsigned long pfn)
 {
        if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
                return 0;
-       return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
+       return valid_section_pfn(__nr_to_section(pfn_to_section_nr(pfn)), pfn);
 }

diff --git a/mm/sparse.c b/mm/sparse.c
index 95ac219..bde9090 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -195,6 +195,8 @@ void __init memory_present(int nid, unsigned long start, unsigned long end)
                if (!ms->section_mem_map)
                        ms->section_mem_map = sparse_encode_early_nid(nid) |
                                                        SECTION_MARKED_PRESENT;
+               ms->start_pfn = start;
+               ms->end_pfn = end;
        }
 }



-- 
Kind regards,
Minchan Kim
