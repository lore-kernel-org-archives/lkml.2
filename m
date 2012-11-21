Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2KUF71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:59:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2KUF70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:59:26 -0500
X-IronPort-AV: E=Sophos;i="4.83,291,1352044800"; 
   d="scan'208";a="6244300"
Message-ID: <50AC6D78.4060209@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 13:58:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, rob@landley.net,
        akpm@linux-foundation.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, yinghai@kernel.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Get pg_data_t's memory from other node
References: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com> <1353335246-9127-2-git-send-email-tangchen@cn.fujitsu.com> <50AC6AA3.8000806@jp.fujitsu.com>
In-Reply-To: <50AC6AA3.8000806@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 13:59:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 13:59:07,
	Serialize complete at 2012/11/21 13:59:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ishimatsu-san,

Thanks for the comments.

And I also found the some algorithm problems in patch2 ~ patch3.
I am working on it, and a v2 patchset is coming soon. :)

Thanks.

On 11/21/2012 01:46 PM, Yasuaki Ishimatsu wrote:
> Hi Tang,
> 
> 2012/11/19 23:27, Tang Chen wrote:
>> From: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>>
>> If system can create movable node which all memory of the
>> node is allocated as ZONE_MOVABLE, setup_node_data() cannot
>> allocate memory for the node's pg_data_t.
>> So when memblock_alloc_nid() fails, setup_node_data() retries
>> memblock_alloc().
>>
>> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> Reviewed-by: Wen Congyang<wency@cn.fujitsu.com>
>> Tested-by: Lin Feng<linfeng@cn.fujitsu.com>
>> ---
>>    arch/x86/mm/numa.c |    9 +++++++--
>>    1 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
>> index 2d125be..ae2e76e 100644
>> --- a/arch/x86/mm/numa.c
>> +++ b/arch/x86/mm/numa.c
>> @@ -224,9 +224,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>>    	} else {
>>    		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>>    		if (!nd_pa) {
>> -			pr_err("Cannot find %zu bytes in node %d\n",
> 
>> +			printk(KERN_WARNING "Cannot find %zu bytes in node %d\n",
>>    			       nd_size, nid)
> 
> Please change to use pr_warn().
> 
> Thanks,
> Yasuaki Ishimatsu
> 
>> -			return;
>> +			nd_pa = memblock_alloc(nd_size, SMP_CACHE_BYTES);
>> +			if (!nd_pa) {
>> +				pr_err("Cannot find %zu bytes in other node\n",
>> +				       nd_size);
>> +				return;
>> +			}
>>    		}
>>    		nd = __va(nd_pa);
>>    	}
>>
> 
> 
> 

