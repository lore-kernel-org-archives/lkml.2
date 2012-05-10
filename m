Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2EJCRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:17:08 -0400
Received: from ozlabs.org ([203.10.76.45]:33829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2EJCRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:17:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kosaki.motohiro@gmail.com
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
In-Reply-To: <4FAB1AC9.1050306@gmail.com>
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 10 May 2012 11:46:23 +0930
Message-ID: <871umsdbm0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2012 21:32:57 -0400, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> (5/9/12 2:10 AM), Rusty Russell wrote:
> > Hi Ingo,
> >
> >          I finally rebased this on top of your tip tree, and tested it
> > locally.  Some more old-style cpumask usages have crept in, but it's a
> > fairly simple series.
> >
> > The final result is that if you enable CONFIG_CPUMASK_OFFSTACK, then
> > 'struct cpumask' becomes an undefined type.  You can't accidentally take
> > the size of it, assign it, or pass it by value.  And thus it's safe for
> > us to make it smaller if nr_cpu_ids<  NR_CPUS, as the final patch does.
> >
> > It unfortunately requires the lglock cleanup patch, which Al already has
> > queued, so I've included it here.
> 
> Hi
> 
> Thanks this effort. This is very cleaner than I expected.
> However I should NAK following one patch. sorry. because of, lru-drain is
> called from memory reclaim context. It mean, additional allocation may not
> work. Please just use bare NR_CPUS bitmap instead. space wasting is minor
> issue than that.

But if it fails the allocation, that's fine: we just send a few more
IPIs to every CPU:

+	if (!zalloc_cpumask_var(&cpus_with_pcps, GFP_KERNEL)) {
+		on_each_cpu(drain_local_pages, NULL, 1);
+		return;
+	}

We can do it the other way, but it sets a bad example, and after we get
rid of cpumask, it becomes:

        static DECLARE_BITMAP(cpus_with_pcps, NR_CPUS);

        ......

 		if (has_pcps)
			cpumask_set_cpu(cpu, to_cpumask(cpus_with_pcps));
		else
			cpumask_clear_cpu(cpu, to_cpumask(cpus_with_pcps));
 	}
	on_each_cpu_mask(to_cpumask(cpus_with_pcps), drain_local_pages, NULL, 1);

Or is there a reason we shouldn't even try to allocate here?

Thanks,
Rusty.
