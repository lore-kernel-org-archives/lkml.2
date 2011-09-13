Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1IMMLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:11:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:44181 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1IMMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:11:17 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Vladimir Davydov <vdavydov@parallels.com>
To: Paul Turner <pjt@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20110721164325.231521704@google.com>
References: <20110721164325.231521704@google.com>
Content-Type: text/plain
Date: Tue, 13 Sep 2011 16:10:48 +0400
Message-ID: <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul

I have a question about CFS bandwidth control.

Let's consider a cgroup with several (>1) tasks running on a two CPU
host. Let the limit of the cgroup be 50% (e.g. period=1s, quota=0.5s).
How will tasks of the cgroup be distributed between the two CPUs? Will
they all run on one of the CPUs, or will one half of them run on one CPU
and others run on the other?

Although in both cases the tasks will consume not more than one half of
overall CPU time, the first case (all tasks of the cgroup run on the
same CPU) is obviously better if the tasks are likely to communicate
with each other (e.g. through pipe) which is often the case when cgroups
are used for container virtualization.

In other words, I'd like to know if your code (or the scheduler code)
tries to gather all tasks of the same cgroup on such a subset of all
CPUs so that the tasks can't execute less CPUs without losing quota
during each period. And if not, are you going to address the issue?

On Thu, 2011-07-21 at 20:43 +0400, Paul Turner wrote:
> Hi all,
> 
> Please find attached the incremental v7.2 for bandwidth control.
> 
> This release follows a fairly intensive period of scraping cycles across
> various configurations.  Unfortunately we seem to be currently taking an IPC
> hit for jump_labels (despite a savings in branches/instr. ret) which despite
> fairly extensive digging I don't have a good explanation for.  The emitted
> assembly /looks/ ok, but cycles/wall time is consistently higher across several
> platforms.
> 
> As such I've demoted the jumppatch to [RFT] while these details are worked
> out.  But there's no point in holding up the rest of the series any more.
> 
> [ Please find the specific discussion related to the above attached to patch 
> 17/18. ]
> 
> So -- without jump labels -- the current performance looks like:
> 
>                             instructions            cycles                  branches         
> ---------------------------------------------------------------------------------------------
> clovertown [!BWC]           843695716               965744453               151224759        
> +unconstrained              845934117 (+0.27)       974222228 (+0.88)       152715407 (+0.99)
> +10000000000/1000:          855102086 (+1.35)       978728348 (+1.34)       154495984 (+2.16)
> +10000000000/1000000:       853981660 (+1.22)       976344561 (+1.10)       154287243 (+2.03)
> 
> barcelona [!BWC]            810514902               761071312               145351489        
> +unconstrained              820573353 (+1.24)       748178486 (-1.69)       148161233 (+1.93)
> +10000000000/1000:          827963132 (+2.15)       757829815 (-0.43)       149611950 (+2.93)
> +10000000000/1000000:       827701516 (+2.12)       753575001 (-0.98)       149568284 (+2.90)
> 
> westmere [!BWC]             792513879               702882443               143267136        
> +unconstrained              802533191 (+1.26)       694415157 (-1.20)       146071233 (+1.96)
> +10000000000/1000:          809861594 (+2.19)       701781996 (-0.16)       147520953 (+2.97)
> +10000000000/1000000:       809752541 (+2.18)       705278419 (+0.34)       147502154 (+2.96)
> 
> Under the workload:
>   mkdir -p /cgroup/cpu/test
>   echo $$ > /dev/cgroup/cpu/test (only cpu,cpuacct mounted)
>   (W1) taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "for ((i=0;i<5;i++)); do $(dirname $0)/pipe-test 20000; done"
> 
> This may seem a strange work-load but it works around some bizarro overheads
> currently introduced by perf.  Comparing for example with::w
>   (W2)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;true"
>   (W3)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;"
> 
> 
> We see: 
>  (W1)  westmere [!BWC]             792513879               702882443               143267136             0.197246943  
>  (W2)  westmere [!BWC]             912241728               772576786               165734252             0.214923134  
>  (W3)  westmere [!BWC]             904349725               882084726               162577399             0.748506065  
> 
> vs an 'ideal' total exec time of (approximately):
> $ time taskset -c 0 ./pipe-test 100000
>  real    0m0.198 user    0m0.007s ys     0m0.095s
> 
> The overhead in W2 is explained by that invoking pipe-test directly, one of
> the siblings is becoming the perf_ctx parent, invoking lots of pain every time
> we switch.  I do not have a reasonable explantion as to why (W1) is so much
> cheaper than (W2), I stumbled across it by accident when I was trying some
> combinations to reduce the <perf stat>-to-<perf stat> variance.
> 
> v7.2
> -----------
> - Build errors in !CGROUP_SCHED case fixed
> - !CONFIG_SMP now 'supported' (#ifdef munging)
> - gcc was failing to inline account_cfs_rq_runtime, affecting performance
> - checks in expire_cfs_rq_runtime() and check_enqueue_throttle() re-organized
>   to save branches.
> - jump labels introduced in the case BWC is not being used system-wide to
>   reduce inert overhead.
> - branch saved in expiring runtime (reorganize conditonals)
> 
> Hidetoshi, the following patchsets have changed enough to necessitate tweaking
> of your Reviewed-by:
> [patch 09/18] sched: add support for unthrottling group entities (extensive)
> [patch 11/18] sched: prevent interactions with throttled entities (update_cfs_shares)
> [patch 12/18] sched: prevent buddy interactions with throttled entities (new)
> 
> 
> Previous postings:
> -----------------
> v7.1: https://lkml.org/lkml/2011/7/7/24
> v7: http://lkml.org/lkml/2011/6/21/43
> v6: http://lkml.org/lkml/2011/5/7/37
> v5: http://lkml.org/lkml/2011/3 /22/477
> v4: http://lkml.org/lkml/2011/2/23/44
> v3: http://lkml.org/lkml/2010/10/12/44
> v2: http://lkml.org/lkml/2010/4/28/88
> Original posting: http://lkml.org/lkml/2010/2/12/393
> 
> Prior approaches: http://lkml.org/lkml/2010/1/5/44 ["CFS Hard limits v5"]
> 
> Thanks,
> 
> - Paul
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

