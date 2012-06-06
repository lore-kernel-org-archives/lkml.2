Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2FFJ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:27:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:49565 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2FFJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:27:22 -0400
Date: Wed, 6 Jun 2012 11:27:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: "Luck, Tony" <tony.luck@intel.com>, "bp@amd64.org" <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix the MCE poll timer logic
In-Reply-To: <4FCF0C03.9010400@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206061120270.3086@ionos>
References: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com> <tip-958fb3c51295764599d6abce87e1a01ace897a3e@git.kernel.org> <4FCF0C03.9010400@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Chen Gong wrote:
> In fact, there still exists another potential issue:
> 
> static void __mcheck_cpu_init_timer(void)
> {
>         struct timer_list *t = &__get_cpu_var(mce_timer);
>         unsigned long iv = __this_cpu_read(mce_next_interval);
> 
>         setup_timer(t, mce_timer_fn, smp_processor_id());
> 
>         if (mce_ignore_ce)
>                 return;
> 
>         __this_cpu_write(mce_next_interval, iv);
>         if (!iv)
>                 return;
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Because the 2nd patch is not merged yet, so here iv is zero when this
> function is called, which means at the beginning, the poll timers are
> not registered until some other conditions trigger *add_timer_on*.

Dammit. I dropped the 

	iv = check_interval * HZ;

line before __this_cpu_write() and nobody noticed. :(
 
>         t->expires = round_jiffies(jiffies + iv);
>         add_timer_on(t, smp_processor_id());
> }
> 
> Another potential issue is in this function two smp_processor_id()
> are called. If conext changes during this procedure (I'm not sure
> if it can hapen, besides secondary_cpu kickoff, online/offline will

No. This code is always called with preemption disabled.

> call these functions, even in virtualization envrionment, etc.).

What has virtualization to do with that ?

> So I think it will be better saving the value in the beginning of
> this function. Make sense?

No. Otherwise all the __this_cpu_read/write accesses are bogus as
well.

Thanks,

	tglx
