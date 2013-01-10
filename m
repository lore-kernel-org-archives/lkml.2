Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab3AJCSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:18:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8122 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3AJCR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:17:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,441,1355068800"; 
   d="scan'208";a="6554527"
Message-ID: <50EE24A4.8020601@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 10:17:08 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rientjes@google.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v6 00/15] memory-hotplug: hot-remove physical memory
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com> <20130109142314.1ce04a96.akpm@linux-foundation.org>
In-Reply-To: <20130109142314.1ce04a96.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:17:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:17:21,
	Serialize complete at 2013/01/10 10:17:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you very much for your pushing. :)

On 01/10/2013 06:23 AM, Andrew Morton wrote:
>
> This does sound like a significant problem.  We should assume that
> mmecg is available and in use.
>
>> In patch1, we provide a solution which is not good enough:
>> Iterate twice to offline the memory.
>> 1st iterate: offline every non primary memory block.
>> 2nd iterate: offline primary (i.e. first added) memory block.
>
> Let's flesh this out a bit.
>
> If we online memory8, memory9, memory10 and memory11 then I'd have
> thought that they would need to offlined in reverse order, which will
> require four iterations, not two.  Is this wrong and if so, why?

Well, we may need more than two iterations if all memory8, memory9,
memory10 are in use by kernel, and 10 depends on 9, 9 depends on 8.

So, as you see here, the iteration method is not good enough.

But this only happens when the memory is used by kernel, which will not
be able to be migrated. So if we can use a boot option, such as
movablecore_map, or movable_online functionality to limit the memory as 
movable, the kernel will not use this memory. So it is safe when we are
doing node hot-remove.

>
> Also, what happens if we wish to offline only memory9?  Do we offline
> memory11 then memory10 then memory9 and then re-online memory10 and
> memory11?

In this case, offlining memory9 could fail if user do this by himself,
for example using sysfs.

In this path, it is in memory hot-remove path. So when we remove a
memory device, it will automatically offline all pages, and it is in
reverse order by itself.

And again, this is not good enough. We will figure out a reasonable way
to solve it soon.

>
>> And a new idea from Wen Congyang<wency@cn.fujitsu.com>  is:
>> allocate the memory from the memory block they are describing.
>
> Yes.
>
>> But we are not sure if it is OK to do so because there is not existing API
>> to do so, and we need to move page_cgroup memory allocation from MEM_GOING_ONLINE
>> to MEM_ONLINE.
>
> This all sounds solvable - can we proceed in this fashion?

Yes, we are in progress now.

>
>> And also, it may interfere the hugepage.
>
> Please provide full details on this problem.

It is not very clear now, and if I find something, I'll share it out.

>
>> Note: if the memory provided by the memory device is used by the kernel, it
>> can't be offlined. It is not a bug.
>
> Right.  But how often does this happen in testing?  In other words,
> please provide an overall description of how well memory hot-remove is
> presently operating.  Is it reliable?  What is the success rate in
> real-world situations?

We test the hot-remove functionality mostly with movable_online used.
And the memory used by kernel is not allowed to be removed.

We will do some tests in the kernel memory offline cases, and tell you
the test results soon.

And since we are trying out some other ways, I think the problem will
be solved soon.

> Are there precautions which the administrator
> can take to improve the success rate?

Administrator could use movablecore_map boot option or movable_online
functionality (which is now in kernel) to limit memory as movable to
avoid this problem.

> What are the remaining problems
> and are there plans to address them?

For now, we will try to allocate page_group on the memory block which
itself is describing. And all the other parts seems work well now.

And we are still testing. If we have any problem, we will share.

Thanks. :)

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

