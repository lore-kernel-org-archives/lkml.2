Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1BURXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:23:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44745 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BURXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:23:06 -0500
Message-ID: <4D629F17.5030006@kernel.org>
Date: Mon, 21 Feb 2011 09:21:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for early_node_mem()
References: <4D5EC05A.60103@kernel.org> <4D5EC184.6000505@kernel.org> <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com> <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com> <20110221094318.GG31267@htj.dyndns.org>
In-Reply-To: <20110221094318.GG31267@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D629F69.0118,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 01:43 AM, Tejun Heo wrote:
> Hello,
> 
> On Sat, Feb 19, 2011 at 08:17:11PM -0800, Yinghai Lu wrote:
>>> The old code guarantees that the range is from a single zone, and even
>>> though memblock may be top -> down, it seems like there would be
>>> configurations where this would still be an issue (perhaps simulating it
>>> with numa=fake for testing?) if it crosses the boundary.
>>
>> memblock_x86_find_in_range_node() will go over with early_node_map[].
>> so it will always can get right on node allocation.
> 
> I think always doing top-down allocation should be enough as long as
> there's no highmem, which we don't have on 64bit.  That said, the
> patch description should note the behavior difference.  Yinghai, care
> to add a bit more detail to the patch description?

please check

[PATCH] x86, numa, 64bit: Do not adjust start/end at first for early_node_mem()

We have top-down allocation  with memblock way now.
So do not need to adjust start/end to make them above DMA region.
memblock allocation always get high address for us.

Just remove those lines.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -164,14 +164,9 @@ static void * __init early_node_mem(int
 	unsigned long mem;
 
 	/*
-	 * put it on high as possible
-	 * something will go with NODE_DATA
+	 * memblock find will follow top-down. we will get addr above DMA region
+	 *  if possible, so don't need to adjust start anymore
 	 */
-	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
-	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
 	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
 	if (mem != MEMBLOCK_ERROR)
 		return __va(mem);

