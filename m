Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab2FHHto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:49:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:57468 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab2FHHtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:49:41 -0400
Date: Fri, 8 Jun 2012 09:49:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
In-Reply-To: <4FD07D8F.5020303@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206080940360.3086@ionos>
References: <20120606214941.104735929@linutronix.de> <4FD07D8F.5020303@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, Chen Gong wrote:
> 
> But during the CPU online/offline test I found an issue. After *STORM*
> mode is entered, it can't come back from *STORM* mode to normal
> interrupt mode. At least there exists such an issue: when *STORM* is
> entered, in the meanwhile, one CPU is offline during this period,
> which means *cmci_storm_on_cpus* can't decrease to 0 because there
> is one bit stuck on this offlined CPU. So we should detect such
> situation and decrease on *cmci_storm_on_cpus* at proper time.

Yes, we need to reset the storm state as well I think.

> BTW, even I online the *CPU* in above situation, the normal CMCI
> still doesn't come back, strange.

That's weird.
 
> I still have another question: When we handle following case:
> mce_cpu_callback(struct notifier_block *
> 		mce_device_remove(cpu);
> 		break;
> 	case CPU_DOWN_PREPARE:
> -		del_timer_sync(t);
> 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
> + 		del_timer_sync(t);
> 		break;
> 
> Where we add this timer back? I can't find it in "case CPU_ONLINE".

The timer gets added back via mcheck_cpu_init(), which is called on
the newly onlined cpu from smp_callin().

Thanks,

	tglx

