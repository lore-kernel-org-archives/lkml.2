Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1HaOa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:30:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59899 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaOaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:30:55 -0400
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Wed, 31 Aug 2011 16:30:17 +0200
In-Reply-To: <CAOtvUMd19PD-+EzEcAKMq-12bWRjMFr8G-yBxhCjqMMbxdpaTA@mail.gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
	 <CAOtvUMd19PD-+EzEcAKMq-12bWRjMFr8G-yBxhCjqMMbxdpaTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314801017.3578.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 16:57 +0300, Gilad Ben-Yossef wrote:
> I added the cpuisol option after noticing how many tasks I was unable
> to move from the root cpuset to the system cpuset due to them being
> bound per CPU 

Right, so ideally those tasks should be idle and not interfere. Where
this is not so, we should make it so.

When userspace didn't ask for anything to happen, nothing should happen.
When it did ask for it, well then it shouldn't complain it does :-)

Furthermore things like:

linux-2.6# git grep on_each_cpu mm/
mm/page_alloc.c:        on_each_cpu(drain_local_pages, NULL, 1);
mm/slab.c:      on_each_cpu(do_drain, cachep, 1);
mm/slab.c:      on_each_cpu(do_ccupdate_local, (void *)new, 1);
mm/slub.c:      on_each_cpu(flush_cpu_slab, s, 1);
mm/swap.c:      return schedule_on_each_cpu(lru_add_drain_per_cpu);

Should be converted to smp_call_function_many() and for each we should
keep a cpumask of cpus where there's work to do, avoiding disturbing
cpus that have been quiet.



