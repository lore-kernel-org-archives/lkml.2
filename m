Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2A3Cev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:34:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2A3Cet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:34:49 -0500
Message-ID: <4F2601C9.6000606@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 10:34:49 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to make memory.memsw.failcnt is nonzero
References: <4EFADFF8.5020703@cn.fujitsu.com> <20120103160411.GD3891@tiehlicka.suse.cz>
In-Reply-To: <20120103160411.GD3891@tiehlicka.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 10:33:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 10:33:29,
	Serialize complete at 2012-01-30 10:33:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Hocko said the following on 2012-1-4 0:04:
> On Wed 28-12-11 17:23:04, Peng Haitao wrote:
>>
>> memory.memsw.failcnt shows the number of memory+Swap hits limits.
>> So I think when memory+swap usage is equal to limit, memsw.failcnt should be nonzero.
>>
>> I test as follows:
>>
>> # uname -a
>> Linux K-test 3.2.0-rc7-17-g371de6e #2 SMP Wed Dec 28 12:02:52 CST 2011 x86_64 x86_64 x86_64 GNU/Linux
>> # mkdir /cgroup/memory/group
>> # cd /cgroup/memory/group/
>> # echo 10M > memory.limit_in_bytes
>> # echo 10M > memory.memsw.limit_in_bytes
>> # echo $$ > tasks
>> # dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
>> Killed
>> # cat memory.memsw.failcnt
>> 0
>> # grep "failcnt" /var/log/messages | tail -2
>> Dec 28 17:05:52 K-test kernel: memory: usage 10240kB, limit 10240kB, failcnt 21
>> Dec 28 17:05:52 K-test kernel: memory+swap: usage 10240kB, limit 10240kB, failcnt 0
>>
>> memory+swap usage is equal to limit, but memsw.failcnt is zero.
>>
> Please note that memsw.limit_in_bytes is triggered only if we have
> consumed some swap space already (and the feature is primarily intended
> to stop extensive swap usage in fact).
> It goes like this: If we trigger hard limit (memory.limit_in_bytes) then
> we start the direct reclaim (with swap available). If we trigger memsw
> limit then we try to reclaim without swap available. We will OOM if we
> cannot reclaim enough to satisfy the respective limit.
> 
> The other part of the answer is, yes there is something wrong going
> on her because we definitely shouldn't OOM. The workload is a single
> threaded and we have a plenty of page cache that could be reclaimed
> easily. On the other hand we end up with:
> # echo $$ > tasks 
> /dev/memctl/a# echo 10M > memory.limit_in_bytes 
> /dev/memctl/a# echo 10M > memory.memsw.limit_in_bytes 
> /dev/memctl/a# dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
> Killed
> /dev/memctl/a# cat memory.stat 
> cache 9265152
> [...]
> 
> So there is almost 10M of page cache that we can simply reclaim. If we
> use 40M limit then we are OK. So this looks like the small limit somehow
> tricks our math in the reclaim path and we think there is nothing to
> reclaim.
> I will look into this.

Have any conclusion for this?
Thanks.

-- 
Best Regards,
Peng

