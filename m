Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2LLJKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:10:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab2LLJKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:10:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,265,1355068800"; 
   d="scan'208";a="6382479"
Message-ID: <50C849DD.20405@cn.fujitsu.com>
Date: Wed, 12 Dec 2012 17:09:49 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>
CC: Jianguo Wu <wujianguo@huawei.com>, hpa@zytor.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 3/5] page_alloc: Introduce zone_movable_limit[] to
 keep movable limit for nodes
References: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>  <1355193207-21797-4-git-send-email-tangchen@cn.fujitsu.com>  <50C6A36C.5030606@huawei.com> <50C6A93A.50404@cn.fujitsu.com> <1355225313.1919.1.camel@kernel.cn.ibm.com> <50C7D490.60409@huawei.com>
In-Reply-To: <50C7D490.60409@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 17:09:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 17:09:54,
	Serialize complete at 2012/12/12 17:09:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 08:49 AM, Jiang Liu wrote:
>>>>> This patch introduces a new array zone_movable_limit[] to store the
>>>>> ZONE_MOVABLE limit from movablecore_map boot option for all nodes.
>>>>> The function sanitize_zone_movable_limit() will find out to which
>>>>> node the ranges in movable_map.map[] belongs, and calculates the
>>>>> low boundary of ZONE_MOVABLE for each node.
>>
>> What's the difference between zone_movable_limit[nid] and
>> zone_movable_pfn[nid]?
> zone_movable_limit[] is a temporary storage for zone_moveable_pfn[].
> It's used to handle a special case if user specifies both movablecore_map
> and movablecore/kernelcore on the kernel command line.
>
Hi Simon, Liu,

Sorry for the late and thanks for your discussion. :)

As Liu said, zone_movable_limit[] is a temporary array for calculation.

If users specified movablecore_map option, zone_movable_limit[] holds
the lowest pfn of ZONE_MOVABLE limited by movablecore_map option. It is 
constant, won't change.

Please refer to find_zone_movable_pfns_for_nodes() in patch4, you will
see that zone_moveable_pfn[] will be changed each time kernel area
increases.

So when kernel area increases on node i, zone_moveable_pfn[i] will
increase. And if zone_moveable_pfn[i] > zone_movable_limit[i], we should
stop allocate memory for kernel on node i. Here, I give movablecore_map 
higher priority than kernelcore/movablecore.

And also, I tried to use zone_moveable_pfn[] to store limits. But when
calculating the kernel area, I still have to store the limits in
temporary variables. I think the code was ugly. So I added an new array.

Thanks. :)
