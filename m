Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2FFKXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:23:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:49846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2FFKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:23:41 -0400
Date: Wed, 6 Jun 2012 12:23:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <alpine.LFD.2.02.1206061056520.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206061215250.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos>
 <4FCF0500.9050704@linux.intel.com> <alpine.LFD.2.02.1206061056520.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-424538539-1338978215=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-424538539-1338978215=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 6 Jun 2012, Thomas Gleixner wrote:

> On Wed, 6 Jun 2012, Chen Gong wrote:
> > 于 2012/6/5 21:35, Thomas Gleixner 写道:
> > I add some print in timer callback, it shows:
> > 
> > smp_processor_id() = 0, mce_timer_fn data(CPU id) = 10
> > timer->function = ffffffff8102c200, timer pending = 1, CPU = 0
> > (add_timer_on, BUG!!!)
> 
> Sure. That's not a surprise. The timer function for cpu 10 is called
> on cpu 0. And the timer function does:
> 
>    struct timer_list *t = &__get_cpu_var(mce_timer);
> 
> which gets a pointer to the timer of cpu0. And that timer is
> pending. So yes, it's exploding for a good reason.
> 
> Though, this does not tell us how the timer of cpu10 gets on cpu0.
> 
> Did you do any cpu hotplug operations ?

There's a problem in the hotplug code.

        case CPU_DOWN_PREPARE:
	case CPU_DOWN_PREPARE_FROZEN:
                del_timer_sync(t);
                smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
                break;

We delete the timer before we disable mce and cmci. So if the cmci
interrupt kicks the timer after del_timer_sync() and before
mce_disable_cpu() is called on the other core, then the timer is still
enqueued when the cpu goes down. After it's dead the timer is migrated
and then the above scenario happens.

Can you try the following just for a quick test ?

        case CPU_DOWN_PREPARE:
	case CPU_DOWN_PREPARE_FROZEN:
                del_timer_sync(t);
                smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		del_timer_sync(t);
                break;

That's not a proper solution, for a proper solution the hotplug code
of mce needs an overhaul. It's patently ugly.

Thanks,

	tglx
--8323328-424538539-1338978215=:3086--
