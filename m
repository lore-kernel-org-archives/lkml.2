Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2KUFq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:46:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58056 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2KUFq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:46:57 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50AC6AA3.8000806@jp.fujitsu.com>
Date: Wed, 21 Nov 2012 14:46:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <wency@cn.fujitsu.com>, <linfeng@cn.fujitsu.com>, <rob@landley.net>,
        <akpm@linux-foundation.org>, <laijs@cn.fujitsu.com>,
        <jiang.liu@huawei.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <minchan.kim@gmail.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <yinghai@kernel.org>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86: Get pg_data_t's memory from other node
References: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com> <1353335246-9127-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1353335246-9127-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tang,

2012/11/19 23:27, Tang Chen wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> If system can create movable node which all memory of the
> node is allocated as ZONE_MOVABLE, setup_node_data() cannot
> allocate memory for the node's pg_data_t.
> So when memblock_alloc_nid() fails, setup_node_data() retries
> memblock_alloc().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
> Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>   arch/x86/mm/numa.c |    9 +++++++--
>   1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 2d125be..ae2e76e 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -224,9 +224,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>   	} else {
>   		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>   		if (!nd_pa) {
> -			pr_err("Cannot find %zu bytes in node %d\n",

> +			printk(KERN_WARNING "Cannot find %zu bytes in node %d\n",
>   			       nd_size, nid)

Please change to use pr_warn().

Thanks,
Yasuaki Ishimatsu

> -			return;
> +			nd_pa = memblock_alloc(nd_size, SMP_CACHE_BYTES);
> +			if (!nd_pa) {
> +				pr_err("Cannot find %zu bytes in other node\n",
> +				       nd_size);
> +				return;
> +			}
>   		}
>   		nd = __va(nd_pa);
>   	}
> 


