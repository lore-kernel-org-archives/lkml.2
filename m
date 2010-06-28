Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0F1Kbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:31:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55142 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0F1Kbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:31:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/5] cpumask: reduce cpumask_size
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, Mike Travis <travis@sgi.com>
In-Reply-To: <201006281957.34403.rusty@rustcorp.com.au>
References: <20100628114425.3881.A69D9226@jp.fujitsu.com> <201006281957.34403.rusty@rustcorp.com.au>
Message-Id: <20100628192912.38A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 19:31:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 28 Jun 2010 12:42:23 pm KOSAKI Motohiro wrote:
> > > Now we're sure noone is using old cpumask operators, nor *cpumask, we can
> > > allocate less bits safely.  This reduces the memory usage of off-stack
> > > cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
> > > cpus.
> > 
> > I have to say I'm sorry. Probably I broke your assumption.
> > If this patch applied, we reintroduce exposing nr_cpu_ids issue and
> > break libnuma again. I think following change is necessary too.
> > 
> > Or, Am I missing something?
> 
> I cc'd you because I remembered you being involved in that libnuma issue
> and couldn't remember the details.
> 
> Unfortunately, this solution doesn't work:
> 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 18faf4d..c14acad 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4823,7 +4823,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
> > 
> >         ret = sched_getaffinity(pid, mask);
> >         if (ret == 0) {
> > -               size_t retlen = min_t(size_t, len, cpumask_size());
> > +               size_t retlen = min_t(size_t, len,
> > +                                     BITS_TO_LONGS(NR_CPUS) * sizeof(long));
> > 
> 
> Since mask is a cpumask_var_t, only cpumask_size() is allocated.  We can't
> copy NR_CPUS bits.

Ahh, yes. It's purely broken.


> But I think it's OK, anyway.  libnuma is broken because it gets upset if the
> number of cpus it reads from /sys/.../cpumap is more than the cpumask size
> returned from sys_sched_getaffinity.
> 
> Currently, getaffinity returns cpumask_size() (ie. based on NR_CPUS), and
> the printing routines use nr_cpumask_bits (ie. based on NR_CPUS for 
> !CPUMASK_OFFSTACK, nr_cpu_ids for CPUMASK_OFFSTACK).
> 
> (libnuma is OK on CONFIG_CPUMASK_OFFSTACK=y because the sysfs output is
> *shorter* than expected.  I checked the code).
> 
> With this patch, cpumask_size() becomes based on nr_cpumask_bits, so both
> getaffinity and sysfs are using the same basis.
> 
> Do you agree?

Sure. I agree I missed. Thank you for very kindful explanation!



