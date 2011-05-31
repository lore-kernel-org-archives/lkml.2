Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab1EaREM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:04:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13158 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab1EaREK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CRP6O82kJf5ys30DVWPghF4ZY9aSBU91MU1kA4XdIpg4sKnJ39T9J/JVlOa4S1JDG3
         BWMF8b4eoaBpNxa51IVw==
MIME-Version: 1.0
In-Reply-To: <BANLkTimenj2+m6HxS3SP1v+8U86--yxRmw@mail.gmail.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikcdOGkJWxS0Sey8C1ereVk8ucvQQ@mail.gmail.com>
	<20110527111639.22e3e257.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=Cw8HSTUjNfJzH8GhfwQhUua-h7w@mail.gmail.com>
	<20110527133431.471eefc2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=+XoxHca6accmpj9B-HFrmMTtxFA@mail.gmail.com>
	<BANLkTimenj2+m6HxS3SP1v+8U86--yxRmw@mail.gmail.com>
Date: Tue, 31 May 2011 10:04:05 -0700
Message-ID: <BANLkTikLuodgN0KJe_M7U_i_BL=0oygZaCTZeSx7-MDUJYCvZA@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 0/10] memcg async reclaim
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some testing result on the patchset based on mmotm-2011-05-12-15-52.

Test: create a 4g memcg on 32g host, and change the default dirty
ratio to "10% dirty_raio. 5% dirty_background_ratio" due to the lack
for per-memcg dirty limit.

I did a simple streaming IO test ( read/write 20g file) and used the
pagefault histogram to capture the page fault latency under reclaim.
On both tests, there is no pgfault latency introduced from the reclaim
path by enabling the per-memcg async reclaim . I will post the V2 of
the patch right after.

$ cat /export/hdc3/dd_A/tf0 > /dev/zero

w/o the async reclaim:
page reclaim latency histogram (us):
< 150            542
< 200            15402
< 250            481
< 300            23
< 350            1
< 400            0
< 450            0
< rest           0
real>---4m26.604s
user>---0m0.294s
sys>----0m26.632s

with async reclaim:
page reclaim latency histogram (us):
< 150            0
< 200            0
< 250            0
< 300            0
< 350            1
< 400            1
< 450            0
< rest           1
real>---4m26.605s
user>---0m0.246s
sys>----0m24.341s

$ dd if=/dev/zero of=/export/hdc3/dd/tf0 bs=1024 count=20971520

w/o async reclaim:
page reclaim latency histogram (us):
< 150            4
< 200            17382
< 250            3238
< 300            276
< 350            18
< 400            1
< 450            1
< rest           103
real>---4m26.984s
user>---0m4.964s
sys>----1m8.718s

with async reclaim:
page reclaim latency histogram (us):
< 150            0
< 200            0
< 250            0
< 300            0
< 350            0
< 400            0
< 450            0
< rest           0
real>---4m16.355s
user>---0m4.593s
sys>----1m5.896s

Thanks

--Ying

On Fri, May 27, 2011 at 12:20 AM, Ying Han <yinghan@google.com> wrote:
> On Thu, May 26, 2011 at 9:49 PM, Ying Han <yinghan@google.com> wrote:
>> On Thu, May 26, 2011 at 9:34 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> On Thu, 26 May 2011 21:33:32 -0700
>>> Ying Han <yinghan@google.com> wrote:
>>>
>>>> On Thu, May 26, 2011 at 7:16 PM, KAMEZAWA Hiroyuki
>>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>> > On Thu, 26 May 2011 18:49:26 -0700
>>>> > Ying Han <yinghan@google.com> wrote:
>>>> >
>>>> >> On Wed, May 25, 2011 at 10:10 PM, KAMEZAWA Hiroyuki
>>>> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>> >> >
>>>> >> > It's now merge window...I just dump my patch queue to hear other's idea.
>>>> >> > I wonder I should wait until dirty_ratio for memcg is queued to mmotm...
>>>> >> > I'll be busy with LinuxCon Japan etc...in the next week.
>>>> >> >
>>>> >> > This patch is onto mmotm-May-11 + some patches queued in mmotm, as numa_stat.
>>>> >> >
>>>> >> > This is a patch for memcg to keep margin to the limit in background.
>>>> >> > By keeping some margin to the limit in background, application can
>>>> >> > avoid foreground memory reclaim at charge() and this will help latency.
>>>> >> >
>>>> >> > Main changes from v2 is.
>>>> >> >  - use SCHED_IDLE.
>>>> >> >  - removed most of heuristic codes. Now, code is very simple.
>>>> >> >
>>>> >> > By using SCHED_IDLE, async memory reclaim can only consume 0.3%? of cpu
>>>> >> > if the system is truely busy but can use much CPU if the cpu is idle.
>>>> >> > Because my purpose is for reducing latency without affecting other running
>>>> >> > applications, SCHED_IDLE fits this work.
>>>> >> >
>>>> >> > If application need to stop by some I/O or event, background memory reclaim
>>>> >> > will cull memory while the system is idle.
>>>> >> >
>>>> >> > Perforemce:
>>>> >> >  Running an httpd (apache) under 300M limit. And access 600MB working set
>>>> >> >  with normalized distribution access by apatch-bench.
>>>> >> >  apatch bench's concurrency was 4 and did 40960 accesses.
>>>> >> >
>>>> >> > Without async reclaim:
>>>> >> > Connection Times (ms)
>>>> >> >              min  mean[+/-sd] median   max
>>>> >> > Connect:        0    0   0.0      0       2
>>>> >> > Processing:    30   37  28.3     32    1793
>>>> >> > Waiting:       28   35  25.5     31    1792
>>>> >> > Total:         30   37  28.4     32    1793
>>>> >> >
>>>> >> > Percentage of the requests served within a certain time (ms)
>>>> >> >  50%     32
>>>> >> >  66%     32
>>>> >> >  75%     33
>>>> >> >  80%     34
>>>> >> >  90%     39
>>>> >> >  95%     60
>>>> >> >  98%    100
>>>> >> >  99%    133
>>>> >> >  100%   1793 (longest request)
>>>> >> >
>>>> >> > With async reclaim:
>>>> >> > Connection Times (ms)
>>>> >> >              min  mean[+/-sd] median   max
>>>> >> > Connect:        0    0   0.0      0       2
>>>> >> > Processing:    30   35  12.3     32     678
>>>> >> > Waiting:       28   34  12.0     31     658
>>>> >> > Total:         30   35  12.3     32     678
>>>> >> >
>>>> >> > Percentage of the requests served within a certain time (ms)
>>>> >> >  50%     32
>>>> >> >  66%     32
>>>> >> >  75%     33
>>>> >> >  80%     34
>>>> >> >  90%     39
>>>> >> >  95%     49
>>>> >> >  98%     71
>>>> >> >  99%     86
>>>> >> >  100%    678 (longest request)
>>>> >> >
>>>> >> >
>>>> >> > It seems latency is stabilized by hiding memory reclaim.
>>>> >> >
>>>> >> > The score for memory reclaim was following.
>>>> >> > See patch 10 for meaning of each member.
>>>> >> >
>>>> >> > == without async reclaim ==
>>>> >> > recent_scan_success_ratio 44
>>>> >> > limit_scan_pages 388463
>>>> >> > limit_freed_pages 162238
>>>> >> > limit_elapsed_ns 13852159231
>>>> >> > soft_scan_pages 0
>>>> >> > soft_freed_pages 0
>>>> >> > soft_elapsed_ns 0
>>>> >> > margin_scan_pages 0
>>>> >> > margin_freed_pages 0
>>>> >> > margin_elapsed_ns 0
>>>> >> >
>>>> >> > == with async reclaim ==
>>>> >> > recent_scan_success_ratio 6
>>>> >> > limit_scan_pages 0
>>>> >> > limit_freed_pages 0
>>>> >> > limit_elapsed_ns 0
>>>> >> > soft_scan_pages 0
>>>> >> > soft_freed_pages 0
>>>> >> > soft_elapsed_ns 0
>>>> >> > margin_scan_pages 1295556
>>>> >> > margin_freed_pages 122450
>>>> >> > margin_elapsed_ns 644881521
>>>> >> >
>>>> >> >
>>>> >> > For this case, SCHED_IDLE workqueue can reclaim enough memory to the httpd.
>>>> >> >
>>>> >> > I may need to dig why scan_success_ratio is far different in the both case.
>>>> >> > I guess the difference of epalsed_ns is because several threads enter
>>>> >> > memory reclaim when async reclaim doesn't run. But may not...
>>>> >> >
>>>> >>
>>>> >>
>>>> >> Hmm.. I noticed a very strange behavior on a simple test w/ the patch set.
>>>> >>
>>>> >> Test:
>>>> >> I created a 4g memcg and start doing cat. Then the memcg being OOM
>>>> >> killed as soon as it reaches its hard_limit. We shouldn't hit OOM even
>>>> >> w/o async-reclaim.
>>>> >>
>>>> >> Again, I will read through the patch. But like to post the test result first.
>>>> >>
>>>> >> $ echo $$ >/dev/cgroup/memory/A/tasks
>>>> >> $ cat /dev/cgroup/memory/A/memory.limit_in_bytes
>>>> >> 4294967296
>>>> >>
>>>> >> $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
>>>> >> Killed
>>>> >>
>>>> >
>>>> > I did the same kind of test without any problem...but ok, I'll do more test
>>>> > later.
>>>> >
>>>> >
>>>> >
>>>> >> real  0m53.565s
>>>> >> user  0m0.061s
>>>> >> sys   0m4.814s
>>>> >>
>>>> >> Here is the OOM log:
>>>> >>
>>>> >> May 26 18:43:00  kernel: [  963.489112] cat invoked oom-killer:
>>>> >> gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
>>>> >> May 26 18:43:00  kernel: [  963.489121] Pid: 9425, comm: cat Tainted:
>>>> >> G        W   2.6.39-mcg-DEV #131
>>>> >> May 26 18:43:00  kernel: [  963.489123] Call Trace:
>>>> >> May 26 18:43:00  kernel: [  963.489134]  [<ffffffff810e3512>]
>>>> >> dump_header+0x82/0x1af
>>>> >> May 26 18:43:00  kernel: [  963.489137]  [<ffffffff810e33ca>] ?
>>>> >> spin_lock+0xe/0x10
>>>> >> May 26 18:43:00  kernel: [  963.489140]  [<ffffffff810e33f9>] ?
>>>> >> find_lock_task_mm+0x2d/0x67
>>>> >> May 26 18:43:00  kernel: [  963.489143]  [<ffffffff810e38dd>]
>>>> >> oom_kill_process+0x50/0x27b
>>>> >> May 26 18:43:00  kernel: [  963.489155]  [<ffffffff810e3dc6>]
>>>> >> mem_cgroup_out_of_memory+0x9a/0xe4
>>>> >> May 26 18:43:00  kernel: [  963.489160]  [<ffffffff811153aa>]
>>>> >> mem_cgroup_handle_oom+0x134/0x1fe
>>>> >> May 26 18:43:00  kernel: [  963.489163]  [<ffffffff81114a72>] ?
>>>> >> __mem_cgroup_insert_exceeded+0x83/0x83
>>>> >> May 26 18:43:00  kernel: [  963.489176]  [<ffffffff811166e9>]
>>>> >> __mem_cgroup_try_charge.clone.3+0x368/0x43a
>>>> >> May 26 18:43:00  kernel: [  963.489179]  [<ffffffff81117586>]
>>>> >> mem_cgroup_cache_charge+0x95/0x123
>>>> >> May 26 18:43:00  kernel: [  963.489183]  [<ffffffff810e16d8>]
>>>> >> add_to_page_cache_locked+0x42/0x114
>>>> >> May 26 18:43:00  kernel: [  963.489185]  [<ffffffff810e17db>]
>>>> >> add_to_page_cache_lru+0x31/0x5f
>>>> >> May 26 18:43:00  kernel: [  963.489189]  [<ffffffff81145636>]
>>>> >> mpage_readpages+0xb6/0x132
>>>> >> May 26 18:43:00  kernel: [  963.489194]  [<ffffffff8119992f>] ?
>>>> >> noalloc_get_block_write+0x24/0x24
>>>> >> May 26 18:43:00  kernel: [  963.489197]  [<ffffffff8119992f>] ?
>>>> >> noalloc_get_block_write+0x24/0x24
>>>> >> May 26 18:43:00  kernel: [  963.489201]  [<ffffffff81036742>] ?
>>>> >> __switch_to+0x160/0x212
>>>> >> May 26 18:43:00  kernel: [  963.489205]  [<ffffffff811978b2>]
>>>> >> ext4_readpages+0x1d/0x1f
>>>> >> May 26 18:43:00  kernel: [  963.489209]  [<ffffffff810e8d4b>]
>>>> >> __do_page_cache_readahead+0x144/0x1e3
>>>> >> May 26 18:43:00  kernel: [  963.489212]  [<ffffffff810e8e0b>]
>>>> >> ra_submit+0x21/0x25
>>>> >> May 26 18:43:00  kernel: [  963.489215]  [<ffffffff810e9075>]
>>>> >> ondemand_readahead+0x18c/0x19f
>>>> >> May 26 18:43:00  kernel: [  963.489218]  [<ffffffff810e9105>]
>>>> >> page_cache_async_readahead+0x7d/0x86
>>>> >> May 26 18:43:00  kernel: [  963.489221]  [<ffffffff810e2b7e>]
>>>> >> generic_file_aio_read+0x2d8/0x5fe
>>>> >> May 26 18:43:00  kernel: [  963.489225]  [<ffffffff81119626>]
>>>> >> do_sync_read+0xcb/0x108
>>>> >> May 26 18:43:00  kernel: [  963.489230]  [<ffffffff811f168a>] ?
>>>> >> fsnotify_perm+0x66/0x72
>>>> >> May 26 18:43:00  kernel: [  963.489233]  [<ffffffff811f16f7>] ?
>>>> >> security_file_permission+0x2e/0x33
>>>> >> May 26 18:43:00  kernel: [  963.489236]  [<ffffffff8111a0c8>]
>>>> >> vfs_read+0xab/0x107
>>>> >> May 26 18:43:00  kernel: [  963.489239]  [<ffffffff8111a1e4>] sys_read+0x4a/0x6e
>>>> >> May 26 18:43:00  kernel: [  963.489244]  [<ffffffff8140f469>]
>>>> >> sysenter_dispatch+0x7/0x27
>>>> >> May 26 18:43:00  kernel: [  963.489248] Task in /A killed as a result
>>>> >> of limit of /A
>>>> >> May 26 18:43:00  kernel: [  963.489251] memory: usage 4194304kB, limit
>>>> >> 4194304kB, failcnt 26
>>>> >> May 26 18:43:00  kernel: [  963.489253] memory+swap: usage 0kB, limit
>>>> >> 9007199254740991kB, failcnt 0
>>>> >>
>>>> >
>>>> > Hmm, why memory+swap usage 0kb here...
>>>> >
>>>> > In this set, I used mem_cgroup_margin() rather than res_counter_margin().
>>>> > Hmm, do you disable swap accounting ? If so, I may miss some.
>>>>
>>>> Yes, I disabled the swap accounting in .config:
>>>> # CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
>>>>
>>>>
>>>> Here is how i reproduce it:
>>>>
>>>> $ mkdir /dev/cgroup/memory/D
>>>> $ echo 4g >/dev/cgroup/memory/D/memory.limit_in_bytes
>>>>
>>>> $ cat /dev/cgroup/memory/D/memory.limit_in_bytes
>>>> 4294967296
>>>>
>>>> $ cat /dev/cgroup/memory/D/memory.
>>>> memory.async_control             memory.max_usage_in_bytes
>>>> memory.soft_limit_in_bytes       memory.use_hierarchy
>>>> memory.failcnt                   memory.move_charge_at_immigrate
>>>> memory.stat
>>>> memory.force_empty               memory.oom_control
>>>> memory.swappiness
>>>> memory.limit_in_bytes            memory.reclaim_stat
>>>> memory.usage_in_bytes
>>>>
>>>> $ cat /dev/cgroup/memory/D/memory.async_control
>>>> 0
>>>> $ echo 1 >/dev/cgroup/memory/D/memory.async_control
>>>> $ cat /dev/cgroup/memory/D/memory.async_control
>>>> 1
>>>>
>>>> $ echo $$ >/dev/cgroup/memory/D/tasks
>>>> $ cat /proc/4358/cgroup
>>>> 3:memory:/D
>>>>
>>>> $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
>>>> Killed
>>>>
>>>
>>> If you applied my patches collectly, async_control can be seen if
>>> swap controller is configured because of BUG in patch.
>>
>> I noticed the BUG at the very beginning, so all my tests are having the fix.
>>
>>>
>>> I could cat 20G file under 4G limit without any problem with boot option
>>> swapaccount=0. no problem if async_control == 0 ?
>>
>> $ cat /dev/cgroup/memory/D/memory.async_control
>> 1
>>
>> I have the .config
>> # CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
>>
>> Not sure if that makes difference. I will test next to turn that on.
>
> I know what's the problem and also verified. Our configuration might
> differs on the "#if MAX_NUMNODES > 1"
>
> Please apply the following patch:
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6a52699..0b88d71 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1217,7 +1217,7 @@ unsigned long
> mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg,
>        struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
>
>        nr = MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE) +
> -               MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_FILE);
> +               MEM_CGROUP_ZSTAT(mz, NR_INACTIVE_FILE);
>        if (nr_swap_pages > 0)
>                nr += MEM_CGROUP_ZSTAT(mz, NR_ACTIVE_ANON) +
>                        MEM_CGROUP_ZSTAT(mz, NR_INACTIVE_ANON);
>
> --Ying
>
>>
>> --Ying
>>
>>
>>>
>>>
>>>
>>> Thanks,
>>> -Kame
>>>
>>>
>>>
>>>
>>
>
