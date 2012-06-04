Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2FDULt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:11:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:43020 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2FDULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:11:47 -0400
Date: Mon, 4 Jun 2012 22:11:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1206042203590.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Since offline CPU is in wmait or hlt if mwait feature is not available, it can
> be waken up by writing to monitored memory range or via nmi.
> 
> Compared to current INIT, INIT, STARTUP wake up sequence, waking up offline CPU
> is faster via wmait or nmi. This is especially useful when offline CPU for
> power saving and shorter waking up time is desired. On one tested desktop
> machine, waking up time via mwait or nmi is reduced to 23% of waking up time
> via INIT. Waking up time is measured from the beginning of store_online() to
> the beginning of cpu_idle() after the CPU is waken up.
> 
> Waking up offline CPU via mwait or nmi is also useful to support BSP offline/
> online because offline BSP can not be waken up by the INIT's sequence. The BSP
> offline/online patchset will be sent out seperately.

I understand what you are trying to do, though I completely disagree
with the solution.

The main problem of the current hotplug code is that it is an all or
nothing approach. You have to tear down the whole thing completely
instead of just taking it out of the usable set of cpus.

I'm working on a proper state machine driven online/offline sequence,
where you can put the cpu into an intermediate state which avoids
bringing it down completely. This is enough to get the full
powersaving benefits w/o having to go through all the synchronization
states of a full online/offline. That will shorten the onlining time
of an previously offlined cpu to almost nothing.

I really want to avoid adding more bandaids to the hotplug code before
we have sorted out the existing horror.

Thanks,

	tglx
