Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab2FGKIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:08:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:2028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564Ab2FGKIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149359403"
Message-ID: <4FD07D8F.5020303@linux.intel.com>
Date: Thu, 07 Jun 2012 18:08:15 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
References: <20120606214941.104735929@linutronix.de>
In-Reply-To: <20120606214941.104735929@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/7 5:53, Thomas Gleixner 写道:
> Sorry for the resend, I guess I need more sleep or vacation or both :(
>
> The following series fixes a few interesting bugs (found by review in
> context of the CMCI poll effort) and a cleanup to the timer/hotplug
> code followed by a consolidated version of the CMCI poll
> implementation. This series is based on
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>
> which contains the bugfix for the dropped timer interval init.
>
> Thanks,
>
> 	tglx
>
>
>
>

I tested the latest patch series based on your tip tree. The basic logic
is correct as we expected :-).

But during the CPU online/offline test I found an issue. After *STORM*
mode is entered, it can't come back from *STORM* mode to normal
interrupt mode. At least there exists such an issue: when *STORM* is
entered, in the meanwhile, one CPU is offline during this period,
which means *cmci_storm_on_cpus* can't decrease to 0 because there
is one bit stuck on this offlined CPU. So we should detect such
situation and decrease on *cmci_storm_on_cpus* at proper time.
BTW, even I online the *CPU* in above situation, the normal CMCI
still doesn't come back, strange.

I still have another question: When we handle following case:
mce_cpu_callback(struct notifier_block *
		mce_device_remove(cpu);
		break;
	case CPU_DOWN_PREPARE:
-		del_timer_sync(t);
		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+ 		del_timer_sync(t);
		break;

Where we add this timer back? I can't find it in "case CPU_ONLINE".
