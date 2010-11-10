Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KJSHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:07:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab0KJSHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:07:32 -0500
Date: Wed, 10 Nov 2010 19:07:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101110180711.GB22410@elte.hu>
References: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
 <20101110074941.GD29493@elte.hu>
 <20101110160516.GZ4823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110160516.GZ4823@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> > Hm, the flip side is that if a CPU is stuck spewing backtraces, we will now make 
> > all the other CPUs a lot more noisy - which might only 'lock up' because this 
> > CPU is stuck spewing oopses, right?
> 
> When you say the other CPUs will be a lot more noisy, is that because they are 
> busy processing backtraces for the first cpu to spew?  I guess I don't understand 
> how the other CPUs could have their interrupts off the whole time while the first 
> cpu is spewing a backtrace (just trying to educate myself).

Say the kernel crashes on a CPU and keeps spewing new oopses, while write-holding 
tasklist_lock.

Any other CPU that delivers a signal from IRQ context, trying to take the 
tasklist_lock, will loop indefinitely until that crashing CPU releases the lock.

In that case the 'secondary' NMI warnings from all other CPUs (eventually every CPU 
gets stuck in such a scenario) will start spewing NMI lockup messages.

Dunno. Maybe we should do your change - but also have an option to 'shut up' the 
kernel after the first hard oops [not warning]. That would silence the secondary NMI 
watchdog messages as well.

Thanks,

	Ingo
