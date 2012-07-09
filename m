Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab2GIEUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:20:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42241 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2GIEUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:20:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA5B7F.8030403@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 13:18:07 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881562-5900-1-git-send-email-handai.szj@taobao.com> <20120708145309.GC18272@localhost> <4FFA51AB.30203@gmail.com> <20120709041437.GA10180@localhost>
In-Reply-To: <20120709041437.GA10180@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/09 13:14), Fengguang Wu wrote:
> On Mon, Jul 09, 2012 at 11:36:11AM +0800, Sha Zhengju wrote:
>> On 07/08/2012 10:53 PM, Fengguang Wu wrote:
>>>> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>>>>   {
>>>>   	struct address_space *mapping = page_mapping(page);
>>>>   	int ret;
>>>> +	bool locked;
>>>> +	unsigned long flags;
>>>>
>>>> +	mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>>>   	if (mapping) {
>>>>   		struct backing_dev_info *bdi = mapping->backing_dev_info;
>>>>   		unsigned long flags;
>>>> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>>>>   	}
>>>>   	if (!ret)
>>>>   		account_page_writeback(page);
>>>> +
>>>> +	mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>>>   	return ret;
>>>>
>>>>   }
>>> Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
>>>
>>
>> It's in account_page_writeback().
>>
>>   void account_page_writeback(struct page *page)
>>   {
>> +	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
>>   	inc_zone_page_state(page, NR_WRITEBACK);
>>   }
>
> I didn't find that chunk, perhaps it's lost due to rebase..
>
>> There isn't a unified interface to dec/inc writeback accounting, so
>> I just follow that.
>> Maybe we can rework account_page_writeback() to also account
>> dec in?
>
> The current seperate inc/dec paths are fine. It sounds like
> over-engineering if going any further.
>
> I'm a bit worried about some 3rd party kernel module to call
> account_page_writeback() without mem_cgroup_begin/end_update_page_stat().
> Will that lead to serious locking issues, or merely inaccurate
> accounting?
>

Ah, Hm. Maybe it's better to add some debug check in
  mem_cgroup_update_page_stat(). rcu_read_lock_held() or some.

Thanks,
-Kame



