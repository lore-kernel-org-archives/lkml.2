Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab1EXA0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:26:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab1EXA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:26:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 May 2011 09:19:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        hannes@cmpxchg.org, Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8] memcg async reclaim v2
Message-Id: <20110524091928.3aee46da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTimd0CAqoAnuGz7WvKsbwphJxo0eZQ@mail.gmail.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTimd0CAqoAnuGz7WvKsbwphJxo0eZQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 15:38:31 -0700
Ying Han <yinghan@google.com> wrote:

> Hi Kame:
> 
> I applied and tested the patchset on top of mmotm-2011-05-12-15-52. I
> admit that I didn't look the patch closely yet, which I plan to do
> next. Now i have few quick questions based on the testing result:
> 
> Test:
> 1) create a 2g memcg and enable async_control
> $ mkdir /dev/cgroup/memory/A
> $ echo 2g >/dev/cgroup/memory/A/memory.limit_in_bytes
> $ echo 1 >/dev/cgroup/memory/A/memory.async_control
> 
> 2) read a 20g file in the memcg
> $ echo $$ >/dev/cgroup/memory/A/tasks
> $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
> 
> real	4m26.677s
> user	0m0.222s
> sys	0m28.481s
> 
> Here are the questions:
> 
> 1. I monitored the "top" while the test is running. The amount of
> cputime the kworkers take worries me, and the following top output
> stays pretty consistent while the "cat" is running/
> 

memcg-async's kworker is kworker/u:x .....because of UNBOUND_WQ.
Then, kworker you see is for other purpose....Hmm, from trace log,
most of them are for "draining" per-cpu memcg cache. I'll prepare a patch.




> Tasks: 152 total,   2 running, 150 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.1%us,  1.2%sy,  0.0%ni, 87.6%id, 10.6%wa,  0.0%hi,  0.5%si,  0.0%st
> Mem:  32963480k total,  2694728k used, 30268752k free,     3888k buffers
> Swap:        0k total,        0k used,        0k free,  2316500k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   389 root      20   0     0    0    0 R   45  0.0   1:36.24
> kworker/3:1
> 23127 root      20   0     0    0    0 S   44  0.0   0:13.44
> kworker/4:2
>   393 root      20   0     0    0    0 S   43  0.0   2:02.28
> kworker/7:1
>    32 root      20   0     0    0    0 S   42  0.0   1:54.02
> kworker/6:0
>  1230 root      20   0     0    0    0 S   42  0.0   1:22.01
> kworker/2:2
> 23130 root      20   0     0    0    0 S   31  0.0   0:04.04
> kworker/0:2
>   391 root      20   0     0    0    0 S   22  0.0   1:45.79
> kworker/5:1
> 23109 root      20   0  3104  228  180 D   10  0.0   0:08.56 cat
> 
> I attached the tracing output of the kworkers while they are running
> by doing the following:
> 
>  $ mount -t debugfs nodev /sys/kernel/debug/
>  $ echo workqueue:workqueue_queue_work > /sys/kernel/debug/tracing/set_event
>  $ cat /sys/kernel/debug/tracing/trace_pipe > out.txt
> 
> 2. I can not justify the cputime on the kworkers. I am looking for the
> patch which we exports the time before and after workitem on memcg
> basis. I recall we have that in previous post, sorry I missed that
> patch somehere.
> 
>  # cat /cgroup/memory/A/memory.stat
>  ....
>  direct_elapsed_ns 0
>  wmark_elapsed_ns 103566424
>  direct_scanned 0
>  wmark_scanned 29303
>  direct_freed 0
>  wmark_freed 29290
> 

I didn't include this for this version because you and others working on
memory.stat file. I wanted to avoid to add new mess ;)
I'll include it again in v3.



> 3. Here is the outout of memory.stat after the test, the last one is
> the memory.failcnt. As far as I remember, the failcnt is far higher
> than the result i got on previous testing (per-memcg-per-kswapd
> patch). This is all clean file pages which shouldn't be hard to
> reclaim.
> 
> cache 2147151872
> rss 94208
> mapped_file 0
> pgpgin 5242945
> pgpgout 4718715
> pgfault 274
> pgmajfault 0
> 1050041
> 
> Please let me know if the current version isn't ready for testing, and
> I will wait :)
> 

This version has tweaked to be less cpu hogging than previous one. So,
hit_limit increases. I'll drop some tweakes I added in v2 for starting from
a simple one.

I'll post v3 in this week. But if dirty_ratio is ready, I think it should be
merged 1st. But it's merge window....

Thanks,
-Kame




