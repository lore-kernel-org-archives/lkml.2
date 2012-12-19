Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2LSQji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:39:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab2LSQja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:39:30 -0500
Date: Wed, 19 Dec 2012 17:39:00 +0100
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
Message-ID: <20121219163900.GA18516@redhat.com>
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D0CCB3.10105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if you see this email twice)

On 12/19, Srivatsa S. Bhat wrote:
>
> On 12/19/2012 01:13 AM, Oleg Nesterov wrote:
>
> >> I tried thinking about other ways to avoid that smp_mb() in the reader,
> >
> > Just in case, I think there is no way to avoid mb() in _get (although
> > perhaps it can be "implicit").
> >
>
> Actually, I was trying to avoid mb() in the _fastpath_, when there is no
> active writer. I missed stating that clearly, sorry.

Yes, I meant the fastpath too,

> > The writer changes cpu_online_mask and drops the lock. We need to ensure
> > that the reader sees the change in cpu_online_mask after _get returns.
> >
>
> The write_unlock() will ensure the completion of the update to cpu_online_mask,
> using the same semi-permeable logic that you pointed above. So readers will
> see the update as soon as the writer releases the lock, right?

Why?

Once again, the writer (say) removes CPU_1 from cpu_online_mask, and
sets writer_signal[0] = 0, this "enables" fast path on CPU_0.

But, without a barrier, there is no guarantee that CPU_0 will see the
change in cpu_online_mask after get_online_cpus_atomic() checks
writer_signal[0] and returns.

Hmm. And this means that the last version lacks the additional rmb()
(at least) if writer_active() == F.

Oleg.

