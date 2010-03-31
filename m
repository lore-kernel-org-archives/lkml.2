Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab0CaWG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:06:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:60827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0CaWGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:06:55 -0400
Message-ID: <4BB3C739.2020106@kernel.org>
Date: Wed, 31 Mar 2010 15:05:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 11:47 PM, James Morris wrote:
> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
> 
>> On 03/30/2010 09:49 PM, James Morris wrote:
>>> Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
>>> that it leads to all kinds of strange, undebuggable boot hangs and errors 
>>> (with relatively current Fedora development userland).
>>
>> Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
> 
> Yes, it was happening with -rc3.

in case, you have one 32bit system without RAM installed on node0. please check

Thanks

Yinghai

Subject: [PATCH] x86: Fix 32bit system without RAM on Node0

when 32bit numa is used, free_all_bootmem() will still only go over with
node id 0.

If node 0 doesn't have RAM installed, We need to go with node1
because early_node_map still use 1 for all ranges, and ram from node1
becom low ram.

Try to use MAX_NUMNODES like 64 numa does.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_32.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -875,7 +875,12 @@ void __init mem_init(void)
 	BUG_ON(!mem_map);
 #endif
 	/* this will put all low memory onto the freelists */
+#if defined(CONFIG_NO_BOOTMEM) && defined(MAX_NUMNODES)
+	/* In case some 32bit systems don't have RAM installed on node0 */
+        totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
+#else
 	totalram_pages += free_all_bootmem();
+#endif
 
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
