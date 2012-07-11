Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2GKMpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:45:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:33029 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2GKMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:45:44 -0400
Date: Wed, 11 Jul 2012 14:45:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
In-Reply-To: <4FFD6E5A.9060206@redhat.com>
Message-ID: <alpine.LFD.2.02.1207111425260.32033@ionos>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com> <4FFD6E5A.9060206@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Prarit Bhargava wrote:
> On 07/10/2012 06:43 PM, John Stultz wrote:
> > clock_was_set() cannot be called from hard interrupt context because
> > it calls on_each_cpu(). For fixing the widely reported leap seconds
> > issue it's necessary to call it from the timer interrupt context.
> > 
> > Provide a new function which denotes it in the hrtimer cpu base
> > structure of the cpu on which it is called and raising the timer
> > softirq.
> > 
> > We then execute the clock_was_set() notificiation in the timer softirq
> > context in hrtimer_run_pending().
> 
> I wish there was a nicer way to do this ... but looking at the code I can't
> figure out a better way.  (no offense John, it's just the way the code is ;) )

Yeah, I had the same discussion with Peter earlier today. There is
only a rather limited set of options.

1) Retrigger the timer interrupt vectors on all CPUs - except the one
   we are running on, but we have no interface for that at the moment

2) Do the nasty __smp_call_function_single() hack

   Preallocate call_single_data for all cpus and do a
   __smp_call_function_single() on all online cpus.

   This can be called from hard interrupt context or irq disabled
   regions.

   That would allow to get rid of the whole delay magic all
   together.

Thoughts?

	tglx

