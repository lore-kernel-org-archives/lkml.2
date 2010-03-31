Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0CaX4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:56:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:39273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328Ab0CaX4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:56:04 -0400
Message-ID: <4BB3E0CA.5060405@kernel.org>
Date: Wed, 31 Mar 2010 16:54:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com>
In-Reply-To: <4BB3DC23.50005@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 04:34 PM, H. Peter Anvin wrote:
> On 03/31/2010 03:47 PM, Yinghai Lu wrote:
>>>
>>> Well and that whole #ifdeffery is disgusting as well - even if the goal was to 
>>> remove CONFIG_NO_BOOTMEM ASAP.
>>>
>>> Please learn to use proper intermediate helper functions and at minimum put 
>>> the conversion ugliness somewhere that doesnt intrude our daily flow in .c 
>>> files. The best rule is to _never ever_ put an #ifdef construct into a .c 
>>> file. It doesnt matter what the goal if the #ifdef is - such ugliness in code 
>>> is never justified.
>>
>> if you agree that i can have one nobootmem.c in mm/
>>
> 
> That would be better, or more commonly, use inlines.
> 
> I'm still totally puzzled about this patch as well as the comment:
> 
> +#if defined(CONFIG_NO_BOOTMEM) && defined(MAX_NUMNODES)
> +	/* In case some 32bit systems don't have RAM installed on node0 */
> +        totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
> +#else
>  	totalram_pages += free_all_bootmem();
> +#endif
> 
> 
> Why is that "32 bits" specific?  Second, MAX_NUMNODES is defined
> whenever <linux/numa.h> is included, so what on Earth is this supposed
> to signify?  Are you trying to say MAX_NUMNODES > 1?  Or are you trying
> to say CONFIG_NUMA?

you are right, this one should be more clear.

Subject: [PATCH -v2] nobootmem, x86: Fix 32bit system without RAM on Node0

when 32bit numa is used, free_all_bootmem() will still only go over with
node id 0.

If node 0 doesn't have RAM installed, We need to go with node1
because early_node_map still use 1 for all ranges, and ram from node1
becom low ram.

Try to use MAX_NUMNODES like 64 numa does.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -303,7 +303,7 @@ unsigned long __init free_all_bootmem_no
 unsigned long __init free_all_bootmem(void)
 {
 #ifdef CONFIG_NO_BOOTMEM
-	return free_all_memory_core_early(NODE_DATA(0)->node_id);
+	return free_all_memory_core_early(MAX_NUMNODES);
 #else
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 #endif

> 
> Furthermore, I really don't see the connection between this and James
> Morris' reported problem, which he reports as "amd64", which presumably
> is an x86-64 kernel and not 32 bits...  James, is that correct?  Any
> more details you can give about the system?  I *really* don't want to go
> into cargo cult programming mode, that would suck eggs no matter what.

it happened one of my test setup, node0 ram disappear somehow.
and i found the 32bit numa doesn't work on that.

Thanks

Yinghai
