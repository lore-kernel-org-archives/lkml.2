Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2CGNef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:34:35 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43510 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2CGNed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:34:33 -0500
Message-ID: <4F5763CD.8050903@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 19:04:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        prashanth@linux.vnet.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "paulmck@linux.vnet.ibm.com >> \"Paul E. McKenney\"" 
	<paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg>
In-Reply-To: <20120306204357.13169.90791.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030713-3864-0000-0000-000001BAD484
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 02:15 AM, Konstantin Khlebnikov wrote:

> This is fix for suspend/resume regression introduced in commit 8f2f748b0656
> ("CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume")
> Without this patch suspend always hangs on my thinkpad x220 (2 x CPU * HT).
> 


Hey, with commit 8f2f748b0656, suspend/resume works perfectly for me! I ran it
multiple times just to make sure, and everything worked just great.

Apart from that, I even tried suspend/resume after building the kernel with
and without CONFIG_CPUSETS. Both cases worked perfectly.

So, I am really surprised at what you stated above. Are you *really* sure you
are facing suspend hangs *because* of the above commit?

And AFAICS hardware doesn't matter for the code in question, but in any case,
the laptop on which I tested it is:
Thinkpad T420 (Intel core i5-2540M), 2 cores * HT (total 4 logical cpus).

Also, the patch you posted here doesn't make much sense.. nor does it give a
clue as to what might be wrong at your end (if anything is really wrong, that
is). Do you have CONFIG_CPUSETS set or unset? Could you share your .config?

Coming to your patch, assuming you have CONFIG_CPUSETS enabled, then,
calling rebuild_sched_domains() at that point is useless because the cpusets
weren't changed at all. So generate_sched_domains() would generate the same
sched domain partitions that is already there.. And hence
partition_sched_domains() would essentially do nothing.. no sched domain is
destroyed, and no new domains are created.

However, if CONFIG_CPUSETS is unset, then, before commit 8f2f748b0656,
partition_sched_domains(1, NULL, NULL) would have been invoked, thus rebuilding
a single sched domain. And that is why I specifically also tested commit
8f2f748b0656 with CONFIG_CPUSETS unset - and that also worked fine (as I
mentioned above).

So could you please check again?

By the way, you can use the pm-test framework (see Documentation/power/basic-
pm-debugging.txt) to pin-point which stage is causing the hang.
Specifically, the stage where CPU hotplug is done is 'processors'.

So you should probably try out this level:
# echo processors > /sys/power/pm_test
# echo mem > /sys/power/state

Replacing processors with core enables even deeper level suspend testing.

> cpuset_update_active_cpus() not only juggles with bits in cpusets,
> it also calls sched-domains rebuilding after all.
> 
> This patch restores sched-domain rebuilds, as it was before that commit.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  kernel/sched/core.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9995eb0..0fb7406 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6732,6 +6732,10 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  	case CPU_DOWN_FAILED:
>  		cpuset_update_active_cpus();
>  		return NOTIFY_OK;
> +	case CPU_ONLINE_FROZEN:
> +	case CPU_DOWN_FAILED_FROZEN:
> +		rebuild_sched_domains();
> +		return NOTIFY_OK;
>  	default:
>  		return NOTIFY_DONE;
>  	}
> @@ -6744,6 +6748,9 @@ static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
>  	case CPU_DOWN_PREPARE:
>  		cpuset_update_active_cpus();
>  		return NOTIFY_OK;
> +	case CPU_DOWN_PREPARE_FROZEN:
> +		rebuild_sched_domains();
> +		return NOTIFY_OK;
>  	default:
>  		return NOTIFY_DONE;
>  	}
> 

 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

