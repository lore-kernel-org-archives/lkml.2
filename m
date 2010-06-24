Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FXSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:16:59 -0400
Received: from www.tglx.de ([62.245.132.106]:33972 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab0FXSQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:16:57 -0400
Date: Thu, 24 Jun 2010 20:15:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: npiggin@suse.de
cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/52] lglock: introduce special lglock and brlock spin
 locks
In-Reply-To: <20100624030726.371426768@suse.de>
Message-ID: <alpine.LFD.2.00.1006241904160.2911@localhost.localdomain>
References: <20100624030212.676457061@suse.de> <20100624030726.371426768@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, npiggin@suse.de wrote:

> +#define DEFINE_LGLOCK(name)						\
> +									\
> + DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\

Uuurgh. You want to make that an arch_spinlock ? Just to avoid the
preempt_count overflow when you lock all cpu locks nested ?

I'm really not happy about that, it's going to be a complete nightmare
for RT. If you wanted to make this a present for RT giving the
scalability stuff massive testing, then you failed miserably :)

I know how to fix it, but can't we go for an approach which
does not require massive RT patching again ?

struct percpu_lock {
       spinlock_t lock;
       unsigned   global_state;
};

And let the lock function do:

    spin_lock(&pcp->lock);
    while (pcp->global_state)
    	  cpu_relax();

So the global lock side can take each single lock, modify the percpu
"global state" and release the lock. On unlock you just need to reset
the global state w/o taking the percpu lock and be done.

I doubt that the extra conditional in the lock path is going to be
relevant overhead, compared to the spin_lock it's noise.

Thanks,

	tglx
