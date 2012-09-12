Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab2ILBp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:45:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2ILBp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:45:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,407,1344182400"; 
   d="scan'208";a="5824679"
Message-ID: <504FE7AC.90309@cn.fujitsu.com>
Date: Wed, 12 Sep 2012 09:38:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "'FNST-Wen Congyang'" <wency@cn.fujitsu.com>
Subject: Re: [V4 PATCH 27/27] memory,hotplug: Don't modify the zone_start_pfn
 outside of zone_span_writelock()
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <504E8874.5020605@jp.fujitsu.com> <504F07ED.3070502@cn.fujitsu.com> <504F0FE6.5090709@jp.fujitsu.com>
In-Reply-To: <504F0FE6.5090709@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/12 09:36:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/12 09:36:27,
	Serialize complete at 2012/09/12 09:36:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 06:18 PM, Yasuaki Ishimatsu wrote:
> Hi Lai,
> 
> 2012/09/11 18:44, Lai Jiangshan wrote:
>> On 09/11/2012 08:40 AM, Yasuaki Ishimatsu wrote:
>>> Hi Lai,
>>>
>>> Using memory_online to hot-added node's memory, the following kernel messages
>>> were shown. Is this a known issue?
>>
>> Fixed.
>>
>> Subject: Don't modify the zone_start_pfn outside of zone_span_writelock()
>>
>> Original __add_zone() and new online_movable/online_kernel
>> maybe call sleep-able init_currently_empty_zone() to init wait_table,
>>
>> but this function also modifies the zone_start_pfn without lock.
>> so we move this code out, and ensure the modification of zone_start_pfn is done
>> with zone_span_writelock() held or booting.
>>
>> Since zone_start_pfn is not modified by init_currently_empty_zone()
>> grow_zone_span() needs to be updated to be aware of empty zone.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Reported-by: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
>> Tested-by: Wen Congyang <wency@cn.fujitsu.com>
> 
> Applying the patch, the kernel messages disappeared. Thanks.
> But I have a question. Using online_movable, the following messages are shown.
> 
> [  608.314608] Built 3 zonelists in Node order, mobility grouping on.  Total pages: 7844412
> [  608.411478] Policy zone: Normal
> 
> I think memory is allocated to ZONE_MOVABLE by using online_movable.
> So why is "Policy zone: Normal" shown? It should be "Policy zone: Movable"
> 
>


I don't know the mean of "Policy zone" of here. but:

---------------------------------
/* Highest zone. An specific allocation for a zone below that is not
   policied. */
enum zone_type policy_zone = 0;


------------------------------------------------
extern enum zone_type policy_zone;

static inline void check_highest_zone(enum zone_type k)
{
	if (k > policy_zone && k != ZONE_MOVABLE)
		policy_zone = k;
}

----------------------

so I think the output is correct.

Thanks,
Lai
