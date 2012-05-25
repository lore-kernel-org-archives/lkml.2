Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2EYEQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 00:16:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33428 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EYEQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 00:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <4FAB8EB5.8080901@jp.fujitsu.com>
References: <1336588657.26723.23.camel@andre> <4FAB8EB5.8080901@jp.fujitsu.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 25 May 2012 12:16:33 +0800
Message-ID: <CAC8teKXWuzANxCVuV1c+A4Qyh5i7Ws=H5=f-oph72Di_XJFdAQ@mail.gmail.com>
Subject: Re: About cgroup memory limits
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andre Nathan <andre@digirati.com.br>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/10 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> (2012/05/10 3:37), Andre Nathan wrote:
>
>> Hello
>>
>> I'm doing some tests with LXC and how it interacts with the memory
>> cgroup limits, more specifically the memory.limit_in_bytes control file.
>>
>> Am I correct in my understanding of the memory cgroup documentation[1]
>> that the limit set in memory.limit_in_bytes is applied to the sum of the
>> fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?
>>
>
> cache includes mapped_file. Then,

Excuse me, but it does read:

	switch (ctype) {
	case MEM_CGROUP_CHARGE_TYPE_CACHE:
	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
		SetPageCgroupCache(pc);
		SetPageCgroupUsed(pc);
		break;
	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
		ClearPageCgroupCache(pc);
		SetPageCgroupUsed(pc);
		break;
	default:
		break;
	}
	mem_cgroup_charge_statistics(mem, pc, page_size);

And then, in 	mem_cgroup_charge_statistics() we have :

	if (PageCgroupCache(pc))
		__mem_cgroup_stat_add_safe(cpustat,
			MEM_CGROUP_STAT_CACHE, numpages);
	else
		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS,
			numpages);

So it seems that rss includes mapped_file, not cache?

>
> rss + cache < limit.
>
> cache - mapped_file == unmapped file caches.
>
>
>> I am also trying to understand the values reported in memory.stat when
>> compared to the statistics in /proc/$PID/statm.
>>
>> Below is the sum of each field in /proc/$PID/statm for every process
>> running inside a test container, converted to bytes:
>>
>>        size  resident     share     text  lib       data  dt
>>   897208320  28741632  20500480  1171456    0  170676224   0
>>
>
> from statm source code.
>
> size      = total virtual memory size
>            # total amount of mmaps().
>
> shared    = mapped_file
>            # resident mapped file caches
>
> text      = end_code - start_code
>            # end_code and start_code is determined when the program is loaded.
>            # this is virtual memory size.
>
> data      = total virtual memory size  - MAP_SHARED virtual memory size.
>
> regisdent = anonymous pages + mapped_file.
>
>
>> Compare this with the usage reports from memory.stat (fields total_*,
>> hierarchical_* and pg* omitted):
>>
>> cache                     16834560
>> rss                       8192000
>> mapped_file               3743744
>> swap                      0
>> inactive_anon             0
>> active_anon               8192000
>> inactive_file             13996032
>> active_file               2838528
>> unevictable               0
>>
>> Is there a way to reconcile these numbers somehow? I understand that the
>> fields from the two files represent different things. What I'm trying to
>> do is to combine, for example, the fields from memory.stat to
>> approximately reach what is displayed by statm.
>>
>
>
> From above, rss + mapped_file == resident.
>
> Thanks,
> -Kame
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
