Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1BOOqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:46:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1BOOqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:46:02 -0500
Subject: Re: [PATCH v3 3/6] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4D5A8F28.4090306@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
	 <1297448364-14051-4-git-send-email-glommer@redhat.com>
	 <4D5A8F28.4090306@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 15:45:55 +0100
Message-ID: <1297781155.2413.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 16:35 +0200, Avi Kivity wrote:
> On 02/11/2011 08:19 PM, Glauber Costa wrote:
> > This patch accounts steal time time in kernel/sched.
> > I kept it from last proposal, because I still see advantages
> > in it: Doing it here will give us easier access from scheduler
> > variables such as the cpu rq. The next patch shows an example of
> > usage for it.
> >
> > Since functions like account_idle_time() can be called from
> > multiple places, not only account_process_tick(), steal time
> > grabbing is repeated in each account function separatedely.
> >
> 
> I still don't see how we export this to userspace for top(1) and friends.
> 

The existing steal time stuff is:

 kernel/sched.c:account_steal_time()

	cpustat->steal = cputime64_add(cpustat->steal, cputime64);

and

 fs/proc/stat.c:show_stat()


	steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);

	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
		"%llu\n",
		(unsigned long long)cputime64_to_clock_t(user),
		(unsigned long long)cputime64_to_clock_t(nice),
		(unsigned long long)cputime64_to_clock_t(system),
		(unsigned long long)cputime64_to_clock_t(idle),
		(unsigned long long)cputime64_to_clock_t(iowait),
		(unsigned long long)cputime64_to_clock_t(irq),
		(unsigned long long)cputime64_to_clock_t(softirq),
		(unsigned long long)cputime64_to_clock_t(steal),
		(unsigned long long)cputime64_to_clock_t(guest),
		(unsigned long long)cputime64_to_clock_t(guest_nice));


etc..

Glauber's patch is making sure we call account_steal_time(), which is
currently only called from arch code like:

# git grep account_steal_
arch/ia64/xen/time.c:           account_steal_ticks(stolen);
arch/powerpc/kernel/time.c:                     account_steal_time(stolen);
arch/s390/kernel/vtime.c:               account_steal_time(steal);
arch/x86/xen/time.c:    account_steal_ticks(ticks);
include/linux/kernel_stat.h:extern void account_steal_time(cputime_t);
include/linux/kernel_stat.h:extern void account_steal_ticks(unsigned long ticks);
kernel/sched.c:void account_steal_time(cputime_t cputime)
kernel/sched.c:void account_steal_ticks(unsigned long ticks)
kernel/sched.c: account_steal_time(jiffies_to_cputime(ticks));



