Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2HTHBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:01:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2HTHBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:01:35 -0400
X-IronPort-AV: E=Sophos;i="4.77,796,1336320000"; 
   d="scan'208";a="5670424"
Message-ID: <5031E208.2080202@cn.fujitsu.com>
Date: Mon, 20 Aug 2012 15:06:48 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: wujianguo <wujianguo106@gmail.com>
CC: tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.liu@huawei.com,
        guohanjun@huawei.com, qiuxishi@huawei.com, liuj97@gmail.com
Subject: Re: [PATCH]mm/ia64: fix a node distance bug
References: <5031D763.9010808@gmail.com>
In-Reply-To: <5031D763.9010808@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 15:01:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 15:01:37,
	Serialize complete at 2012/08/20 15:01:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 08/20/2012 02:21 PM, wujianguo Wrote:
> From: Jianguo Wu <wujianguo@huawei.com>
> 
> Hi all,
> 	When doing memory-hot-plug, We found node distance is wrong after offline
> a node in IA64 platform. For example system has 4 nodes:
> node distances:
> node   0   1   2   3
>   0:  10  21  21  32
>   1:  21  10  32  21
>   2:  21  32  10  21
>   3:  32  21  21  10
> 
> linux-drf:/sys/devices/system/node/node0 # cat distance
> 10  21  21  32
> linux-drf:/sys/devices/system/node/node1 # cat distance
> 21  10  32  21
> 
> After offline node2:
> linux-drf:/sys/devices/system/node/node0 # cat distance
> 10 21 32
> linux-drf:/sys/devices/system/node/node1 # cat distance
> 32 21 32	--------->expected value is: 21  10  21
> 
> In arch IA, we have following definition:
> extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
> #define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])
> 
> node distance is setup as following:
> acpi_numa_arch_fixup()
> {
> 	...
> 	memset(numa_slit, -1, sizeof(numa_slit));
> 	for (i = 0; i < slit_table->locality_count; i++) {
> 		if (!pxm_bit_test(i))
> 			continue;
> 		node_from = pxm_to_node(i);
> 		for (j = 0; j < slit_table->locality_count; j++) {
> 			if (!pxm_bit_test(j))
> 				continue;
> 			node_to = pxm_to_node(j);
> 			node_distance(node_from, node_to) =
> 			    slit_table->entry[i * slit_table->locality_count + j];
> 		}
> 	}
> 	...
> }
> 	num_online_nodes() is a variable value, during system boot the return vale is 4,
> but after offline node2, the return value is 3, so we read a wrong node distance value.
> This patch is trying to fix this bug.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>  arch/ia64/include/asm/numa.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/numa.h b/arch/ia64/include/asm/numa.h
> index 6a8a27c..2e27ef1 100644
> --- a/arch/ia64/include/asm/numa.h
> +++ b/arch/ia64/include/asm/numa.h
> @@ -59,7 +59,7 @@ extern struct node_cpuid_s node_cpuid[NR_CPUS];
>   */
> 
>  extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
> -#define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])
> +#define node_distance(from,to) (numa_slit[(from) * MAX_NUMNODES + (to)])

Hmm, MAX_NUMNODES is too large. I think num_possible_nodes() is better.

Thanks
Wen Congyang

> 
>  extern int paddr_to_nid(unsigned long paddr);
> 

