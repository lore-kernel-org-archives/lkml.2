Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2LRToM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:44:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab2LRToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:44:11 -0500
Date: Tue, 18 Dec 2012 20:43:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121218194357.GA27972@redhat.com>
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <20121213161709.GA19125@redhat.com> <50CA0317.90501@linux.vnet.ibm.com> <20121214180345.GA22024@redhat.com> <50D09180.4080703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D09180.4080703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Srivatsa S. Bhat wrote:
>
> So now that we can't avoid disabling and enabling interrupts,

Still I think it would be better to not use local_irq_save/restore
directly. And,

> I was
> wondering if we could exploit this to avoid the smp_mb()..
>
> Maybe this is a stupid question, but I'll shoot it anyway...
> Does local_irq_disable()/enable provide any ordering guarantees by any chance?

Oh, I do not know.

But please look at the comment above prepare_to_wait(). It assumes
that even spin_unlock_irqrestore() is not the full barrier.

In any case. get_online_cpus_atomic() has to use irq_restore, not
irq_enable. And _restore does nothing "special" if irqs were already
disabled, so I think we can't rely on sti.

> I tried thinking about other ways to avoid that smp_mb() in the reader,

Just in case, I think there is no way to avoid mb() in _get (although
perhaps it can be "implicit").

The writer changes cpu_online_mask and drops the lock. We need to ensure
that the reader sees the change in cpu_online_mask after _get returns.

> but was unsuccessful. So if the above assumption is wrong, I guess we'll
> just have to go with the version that uses synchronize_sched() at the
> writer-side.

In this case we can also convert get_online_cpus() to use percpu_rwsem
and avoid mutex_lock(&cpu_hotplug.lock), but this is minor I guess.
I do not think get_online_cpus() is called too often.

Oleg.

