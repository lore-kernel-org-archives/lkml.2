Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0HSR27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:28:59 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48134 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0HSR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:28:56 -0400
X-SpamScore: -24
X-BigFish: VS-24(zz936eK1432N98dNzz1202hzz8275dh15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L7ETW4-02-8OQ-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 19:30:13 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Robin Holt <holt@sgi.com>
CC: Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100819173013.GG19773@amd.com>
References: <20100818165653.GX3043@sgi.com>
 <20100818183024.GZ3043@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100818183024.GZ3043@sgi.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:30:24PM -0400, Robin Holt wrote:
> When I investigated, I noticed that all the zone_data[] structures are
> allocated precisely at the beginning of the individual node's physical
> memory.  By simply staggering based upon nodeid, I reduced the average
> down to 0.0006% of every second.

Interesting. Have you measured cache misses for both cases?

> With this patch, the max value did not change.  I believe that is a
> combination of cacheline contention updating the zone's vmstat information
> combined with round_jiffies_common spattering unrelated cpus onto the same
> jiffie for their next update.  I will investigate those issues seperately.

The max value probably the case where none of the data the code accesses
is actually in the cache. Cache aliasing does not help then so I would
not expect a change in the maximum amount here.

> I had no idea whether to ask stable@kernel.org to pull this back to the
> stable releases.  My reading of the stable_kernel_rules.txt criteria is
> only fuzzy as to whether this meets the "oh, that's not good" standard.
> I personally think this meets that criteria, but I am unwilling to defend
> that position too stridently.  In the end, I punted and added them to
> the Cc list.  We will be asking both SuSE and RedHat to add this to
> their upcoming update releases as we expect it to affect their customers.

I don't think this is stable material. It improves performance and does
not fix a bug. But I am not the one to decide this :-)

> 
>  arch/x86/mm/numa_64.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: round_jiffies/arch/x86/mm/numa_64.c
> ===================================================================
> --- round_jiffies.orig/arch/x86/mm/numa_64.c	2010-08-18 11:39:20.495141178 -0500
> +++ round_jiffies/arch/x86/mm/numa_64.c	2010-08-18 13:24:42.679080103 -0500
> @@ -198,6 +198,7 @@ setup_node_bootmem(int nodeid, unsigned
>  	unsigned long start_pfn, last_pfn, nodedata_phys;
>  	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
>  	int nid;
> +	unsigned long cache_alias_offset;
>  #ifndef CONFIG_NO_BOOTMEM
>  	unsigned long bootmap_start, bootmap_pages, bootmap_size;
>  	void *bootmap;
> @@ -221,9 +222,16 @@ setup_node_bootmem(int nodeid, unsigned
>  	start_pfn = start >> PAGE_SHIFT;
>  	last_pfn = end >> PAGE_SHIFT;
>  
> -	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
> +	/*
> +	 * Allocate an extra cacheline per node to reduce cacheline
> +	 * aliasing when scanning all node's node_data.
> +	 */
> +	cache_alias_offset = nodeid * SMP_CACHE_BYTES;
> +	node_data[nodeid] = cache_alias_offset +
> +			    early_node_mem(nodeid, start, end,
> +					   pgdat_size + cache_alias_offset,
>  					   SMP_CACHE_BYTES);
> -	if (node_data[nodeid] == NULL)
> +	if (node_data[nodeid] == (void *)cache_alias_offset)

It is cleaner to keep the NULL check here and add the cache_alias_offset
to the pointer after that check. 

>  		return;
>  	nodedata_phys = __pa(node_data[nodeid]);
>  	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
> 

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

