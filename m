Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1E0Cz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:55:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46915 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1E0CzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:55:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 11:48:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 0/10] memcg async reclaim
Message-Id: <20110527114837.8fae7f00.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTikcdOGkJWxS0Sey8C1ereVk8ucvQQ@mail.gmail.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikcdOGkJWxS0Sey8C1ereVk8ucvQQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 18:49:26 -0700
Ying Han <yinghan@google.com> wrote:

> On Wed, May 25, 2011 at 10:10 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > It's now merge window...I just dump my patch queue to hear other's idea.
> > I wonder I should wait until dirty_ratio for memcg is queued to mmotm...
> > I'll be busy with LinuxCon Japan etc...in the next week.
> >
> > This patch is onto mmotm-May-11 + some patches queued in mmotm, as numa_stat.
> >
> > This is a patch for memcg to keep margin to the limit in background.
> > By keeping some margin to the limit in background, application can
> > avoid foreground memory reclaim at charge() and this will help latency.
> >
> > Main changes from v2 is.
> >  - use SCHED_IDLE.
> >  - removed most of heuristic codes. Now, code is very simple.
> >
> > By using SCHED_IDLE, async memory reclaim can only consume 0.3%? of cpu
> > if the system is truely busy but can use much CPU if the cpu is idle.
> > Because my purpose is for reducing latency without affecting other running
> > applications, SCHED_IDLE fits this work.
> >
> > If application need to stop by some I/O or event, background memory reclaim
> > will cull memory while the system is idle.
> >
> > Perforemce:
> >  Running an httpd (apache) under 300M limit. And access 600MB working set
> >  with normalized distribution access by apatch-bench.
> >  apatch bench's concurrency was 4 and did 40960 accesses.
> >
> > Without async reclaim:
> > Connection Times (ms)
> >              min  mean[+/-sd] median   max
> > Connect:        0    0   0.0      0       2
> > Processing:    30   37  28.3     32    1793
> > Waiting:       28   35  25.5     31    1792
> > Total:         30   37  28.4     32    1793
> >
> > Percentage of the requests served within a certain time (ms)
> >  50%     32
> >  66%     32
> >  75%     33
> >  80%     34
> >  90%     39
> >  95%     60
> >  98%    100
> >  99%    133
> >  100%   1793 (longest request)
> >
> > With async reclaim:
> > Connection Times (ms)
> >              min  mean[+/-sd] median   max
> > Connect:        0    0   0.0      0       2
> > Processing:    30   35  12.3     32     678
> > Waiting:       28   34  12.0     31     658
> > Total:         30   35  12.3     32     678
> >
> > Percentage of the requests served within a certain time (ms)
> >  50%     32
> >  66%     32
> >  75%     33
> >  80%     34
> >  90%     39
> >  95%     49
> >  98%     71
> >  99%     86
> >  100%    678 (longest request)
> >
> >
> > It seems latency is stabilized by hiding memory reclaim.
> >
> > The score for memory reclaim was following.
> > See patch 10 for meaning of each member.
> >
> > == without async reclaim ==
> > recent_scan_success_ratio 44
> > limit_scan_pages 388463
> > limit_freed_pages 162238
> > limit_elapsed_ns 13852159231
> > soft_scan_pages 0
> > soft_freed_pages 0
> > soft_elapsed_ns 0
> > margin_scan_pages 0
> > margin_freed_pages 0
> > margin_elapsed_ns 0
> >
> > == with async reclaim ==
> > recent_scan_success_ratio 6
> > limit_scan_pages 0
> > limit_freed_pages 0
> > limit_elapsed_ns 0
> > soft_scan_pages 0
> > soft_freed_pages 0
> > soft_elapsed_ns 0
> > margin_scan_pages 1295556
> > margin_freed_pages 122450
> > margin_elapsed_ns 644881521
> >
> >
> > For this case, SCHED_IDLE workqueue can reclaim enough memory to the httpd.
> >
> > I may need to dig why scan_success_ratio is far different in the both case.
> > I guess the difference of epalsed_ns is because several threads enter
> > memory reclaim when async reclaim doesn't run. But may not...
> >
> 
> 
> Hmm.. I noticed a very strange behavior on a simple test w/ the patch set.
> 
> Test:
> I created a 4g memcg and start doing cat. Then the memcg being OOM
> killed as soon as it reaches its hard_limit. We shouldn't hit OOM even
> w/o async-reclaim.
> 
> Again, I will read through the patch. But like to post the test result first.
> 
> $ echo $$ >/dev/cgroup/memory/A/tasks
> $ cat /dev/cgroup/memory/A/memory.limit_in_bytes
> 4294967296
> 
> $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
> Killed
> 
> real	0m53.565s
> user	0m0.061s
> sys	0m4.814s
> 

Hmm, what I see is
==
root@bluextal kamezawa]# ls -l test/1G
-rw-rw-r--. 1 kamezawa kamezawa 1053261824 May 13 13:58 test/1G
[root@bluextal kamezawa]# mkdir /cgroup/memory/A
[root@bluextal kamezawa]# echo 0 > /cgroup/memory/A/tasks
[root@bluextal kamezawa]# echo 300M > /cgroup/memory/A/memory.limit_in_bytes
[root@bluextal kamezawa]# echo 1 > /cgroup/memory/A/memory.async_control
[root@bluextal kamezawa]# cat test/1G > /dev/null
[root@bluextal kamezawa]# cat /cgroup/memory/A/memory.reclaim_stat
recent_scan_success_ratio 83
limit_scan_pages 82
limit_freed_pages 49
limit_elapsed_ns 242507
soft_scan_pages 0
soft_freed_pages 0
soft_elapsed_ns 0
margin_scan_pages 218630
margin_freed_pages 181598
margin_elapsed_ns 117466604
[root@bluextal kamezawa]#
==

I'll turn off swapaccount and try again.

Thanks,
-Kame



