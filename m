Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2IRAMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:12:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53462 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2IRAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:12:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5057BC2F.3020008@jp.fujitsu.com>
Date: Tue, 18 Sep 2012 09:11:27 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: qiuxishi <qiuxishi@gmail.com>, <mgorman@suse.de>, <tony.luck@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, <qiuxishi@huawei.com>,
        <bessel.wang@huawei.com>, <wujianguo@huawei.com>,
        <paul.gortmaker@windriver.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <rientjes@google.com>,
        Minchan Kim <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH RESEND] memory hotplug: fix a double register section
 info bug
References: <5052A7DF.4050301@gmail.com> <50530E39.5020100@jp.fujitsu.com> <20120914131428.1f530681.akpm@linux-foundation.org>
In-Reply-To: <20120914131428.1f530681.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/09/15 5:14, Andrew Morton wrote:
> On Fri, 14 Sep 2012 20:00:09 +0900
> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
>
>>> @@ -187,9 +184,10 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
>>>    	end_pfn = pfn + pgdat->node_spanned_pages;
>>>
>>>    	/* register_section info */
>>> -	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION)
>>> -		register_page_bootmem_info_section(pfn);
>>> -
>>> +	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>>> +		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
>>
>> I cannot judge whether your configuration is correct or not.
>> Thus if it is correct, I want a comment of why the node check is
>> needed. In usual configuration, a node does not span the other one.
>> So it is natural that "pfn_to_nid(pfn) is same as "pgdat->node_id".
>> Thus we may remove the node check in the future.
>
> yup.  How does this look?

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

>
> --- a/mm/memory_hotplug.c~memory-hotplug-fix-a-double-register-section-info-bug-fix
> +++ a/mm/memory_hotplug.c
> @@ -185,6 +185,12 @@ void register_page_bootmem_info_node(str
>
>   	/* register_section info */
>   	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		/*
> +		 * Some platforms can assign the same pfn to multiple nodes - on
> +		 * node0 as well as nodeN.  To avoid registering a pfn against
> +		 * multiple nodes we check that this pfn does not already
> +		 * reside in some other node.
> +		 */
>   		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
>   			register_page_bootmem_info_section(pfn);
>   	}
> _
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


