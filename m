Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GIDgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:36:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49443 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2GIDgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:36:16 -0400
Message-ID: <4FFA51AB.30203@gmail.com>
Date: Mon, 09 Jul 2012 11:36:11 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881562-5900-1-git-send-email-handai.szj@taobao.com> <20120708145309.GC18272@localhost>
In-Reply-To: <20120708145309.GC18272@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 10:53 PM, Fengguang Wu wrote:
>> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>>   {
>>   	struct address_space *mapping = page_mapping(page);
>>   	int ret;
>> +	bool locked;
>> +	unsigned long flags;
>>
>> +	mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>   	if (mapping) {
>>   		struct backing_dev_info *bdi = mapping->backing_dev_info;
>>   		unsigned long flags;
>> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>>   	}
>>   	if (!ret)
>>   		account_page_writeback(page);
>> +
>> +	mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>   	return ret;
>>
>>   }
> Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
>

It's in account_page_writeback().

  void account_page_writeback(struct page *page)
  {
+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
  	inc_zone_page_state(page, NR_WRITEBACK);
  }


There isn't a unified interface to dec/inc writeback accounting, so
I just follow that.
Maybe we can rework account_page_writeback() to also account
dec in?


Thanks,
Sha
