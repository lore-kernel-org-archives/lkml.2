Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1FMSYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:24:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40947 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753590Ab1FMSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:24:14 -0400
X-Authenticated: #724076
X-Provags-ID: V01U2FsdGVkX19O3YdgZuROEbWUlEKsRCwonwX9LfsJlbV05Y0ySJ
	AjVG+mVtBzw0U9
Message-ID: <4DF655CB.5000206@gmx.net>
Date: Mon, 13 Jun 2011 20:24:11 +0200
From: marcel partap <mpartap@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CFQ IOsched / CGROUPs: How can a process with realtime/0 IO priority
 starve for several seconds?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Kernelings.
Today i have a very curious issue to bring forward that has been 
bothering me for some time. But because i just got myself my first basic 
CGROUP setup, i considered hickups like this to be a thing of the past: 
Under heavy IO load, mpd starts skipping, sometimes even for a few 
seconds. That with mpd being in my 'swift' CGROUP which has, as can be 
seen below, a blkio.weight of 1000 - double the default of 500 and 100 
times 'idle' class processes like munin-graph get. Nevertheless, it 
repeatedly happens that multiple processes accumulate in IOWAIT stage. 
What i would expect is that the drastically higher blkio.weight would 
prevent mpd to starve on disk input (it needs 30k/s or something), 
instead it stutters a lot making me want to #bash my head against a 
#shell or sumthing ^^
When i noticed the mpd process showed up as besteffort/4 in iotop, i 
re-ioniced it to realtime/0. That did nothing to improve the situation! 
That's in line with my earlier notion that a process in IOWAIT seems not 
to be unblocked by re-ionicing it to realtime!? That really confuses me. 
Doesn't realtime IO scheduling mean that... ???

So how comes? *How can a process even with high blkio.weight and 
realtime/0 IO priority starve for several seconds?*

Thx for any insights and please CC me.

#best regards/marcel.

P.S.: i did notice i did not have the CONFIG_CFQ_GROUP_IOSCHED option 
set, and i am going to try that now. But i guess that doesn't quite 
touch my basic question.

appendix
--------

> CONFIG_CGROUPS=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_BLK_CGROUP=y
> CONFIG_DEBUG_BLK_CGROUP=y
> CONFIG_SCHED_AUTOGROUP=y
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_CFQ_GROUP_IOSCHED is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_SCHED_MC=y
> CONFIG_SCHED_HRTICK=y
> CONFIG_NET_SCHED=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_SCHED_TRACER=y

a screenshot of the situation: 
http://tinyurl.com/3-0-0-rc2-iosched-troubles-png (iotop in accumulative 
mode)

/etc/cgroup/cgconfig.conf
> mount {
>         blkio = /sys/fs/cgroup;
>         cpu = /sys/fs/cgroup;
>         memory = /sys/fs/cgroup;
> }
>
> group . {
>         blkio {
>                 blkio.weight = 500;
>         }
> }
>
> group idle {
>         blkio {
>                 blkio.weight = 10;
>         }
>         cpu {
>                 cpu.shares = 512;
>         }
>         memory {
>                 memory.swappiness = 90;
>         }
> }
>
> group swift {
>         blkio {
>                 blkio.weight = 1000;
>         }
>         cpu {
>                 cpu.shares = 2048;
>         }
>         memory {
>                 memory.swappiness = 1;
>         }
> }
