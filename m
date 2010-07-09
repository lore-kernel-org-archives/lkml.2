Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0GIXMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0GIXMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:12:39 -0400
Message-ID: <4C37AC2B.4090709@ds.jp.nec.com>
Date: Fri, 09 Jul 2010 19:09:31 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, Muuhh Ikeda <m-ikeda@ds.jp.nec.com>
Subject: Re: [RFC][PATCH 02/11] blkiocg async: The main part of iotrack
References: <4C369009.80503@ds.jp.nec.com>	<4C369452.2070103@ds.jp.nec.com> <20100709163820.c7cd687b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100709163820.c7cd687b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote, on 07/09/2010 03:38 AM:
> On Thu, 08 Jul 2010 23:15:30 -0400
> Munehiro Ikeda<m-ikeda@ds.jp.nec.com>  wrote:
>
>> Signed-off-by: Hirokazu Takahashi<taka@valinux.co.jp>
>> Signed-off-by: Ryo Tsuruta<ryov@valinux.co.jp>
>> Signed-off-by: Andrea Righi<arighi@develer.com>
>> Signed-off-by: Munehiro "Muuhh" Ikeda<m-ikeda@ds.jp.nec.com>
>> ---
>>   block/Kconfig.iosched       |    8 +++
>>   block/Makefile              |    1 +
>>   block/blk-iotrack.c         |  129 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/blk-iotrack.h |   62 +++++++++++++++++++++
>>   include/linux/page_cgroup.h |   25 ++++++++
>>   init/Kconfig                |    2 +-
>>   mm/page_cgroup.c            |   91 +++++++++++++++++++++++++++---
>>   7 files changed, 309 insertions(+), 9 deletions(-)
>>   create mode 100644 block/blk-iotrack.c
>>   create mode 100644 include/linux/blk-iotrack.h

(snip)

>> +/**
>> + * blk_iotrack_set_owner() - set the owner ID of a page.
>> + * @page:	the page we want to tag
>> + * @mm:		the mm_struct of a page owner
>> + *
>> + * Make a given page have the blkio-cgroup ID of the owner of this page.
>> + */
>> +int blk_iotrack_set_owner(struct page *page, struct mm_struct *mm)
>> +{
>> +	struct blkio_cgroup *blkcg;
>> +	unsigned short id = 0;	/* 0: default blkio_cgroup id */
>> +
>> +	if (blk_iotrack_disabled())
>> +		return 0;
>> +	if (!mm)
>> +		goto out;
>> +
>> +	rcu_read_lock();
>> +	blkcg = task_to_blkio_cgroup(rcu_dereference(mm->owner));
>> +	if (likely(blkcg))
>> +		id = css_id(&blkcg->css);
>> +	rcu_read_unlock();
>> +out:
>> +	return page_cgroup_set_owner(page, id);
>> +}
>> +
>
> I think this is bad. I/O should be charged against threads i.e. "current",
> because CFQ/blockio-cgroup provides per-thread control.
> mm->owner is not suitable, I think.

OK, thanks.


-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

