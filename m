Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0DADrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:47:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:51261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0DADrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:47:16 -0400
Message-ID: <4BB416D7.6090203@kernel.org>
Date: Wed, 31 Mar 2010 20:45:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v4 2/2] bootmem, x86: Fix 32bit numa system without RAM on
 Node0
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com> <4BB3E0CA.5060405@kernel.org> <4BB3EA55.50505@zytor.com> <4BB3FEA6.8030309@kernel.org> <ca9eedfe-479e-4ccf-9663-66afcd2bbd69@email.android.com> <4BB41689.9090502@kernel.org>
In-Reply-To: <4BB41689.9090502@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When 32bit numa is used, free_all_bootmem() will still only go over with
node id 0.

If node 0 doesn't have RAM installed, We need to go with node1
because early_node_map still use 1 for all ranges, and ram from node1
become low ram.

this one fixes BOOTMEM path by loop bdata_list.

-v3: add more comments, and fix bootmem path too.
-v4: seperate from one big patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/bootmem.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -312,7 +312,13 @@ unsigned long __init free_all_bootmem(vo
 	 */
 	return free_all_memory_core_early(MAX_NUMNODES);
 #else
-	return free_all_bootmem_core(NODE_DATA(0)->bdata);
+	unsigned long total_pages = 0;
+	bootmem_data_t *bdata;
+
+	list_for_each_entry(bdata, &bdata_list, list)
+		total_pages += free_all_bootmem_core(bdata);
+
+	return total_pages;
 #endif
 }
 
