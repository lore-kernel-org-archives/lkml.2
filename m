Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2JDMM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:12:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:33579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2JDMM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:12:58 -0400
Message-ID: <1349352728.4438.23.camel@twins>
Subject: Re: [PATCH RFC 1/3] sched: introduce distinct per-cpu load average
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 04 Oct 2012 14:12:08 +0200
In-Reply-To: <20121004094349.GA2163@thinkpad>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
	 <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
	 <1349341186.4438.1.camel@twins> <20121004094349.GA2163@thinkpad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 11:43 +0200, Andrea Righi wrote:
> 
> Right, the update must be atomic to have a coherent nr_uninterruptible
> value. And AFAICS the only way to account a coherent
> nr_uninterruptible
> value per-cpu is to go with atomic ops... mmh... I'll think more on
> this. 

You could stick it in the cpu controller instead of cpuset, add a
per-cpu nr_uninterruptible counter to struct task_group and update it
from the enqueue/dequeue paths. Those already are per-cgroup (through
cfs_rq, which has a tg pointer).

That would also give you better semantics since it would really be the
load of the tasks of the cgroup, not whatever happened to run on a
particular cpu regardless of groups. Then again, it might be 'fun' to
get the hierarchical semantics right :-)

OTOH it would also make calculating the load-avg O(nr_cgroups) and since
we do this from the tick and people are known to create a shitload (on
the order of 1e3 and upwards) of those this might not actually be a very
good idea.

Also, your patch 2 relies on the load avg function to be additive yet
your completely fail to mention this and state whether this is so or
not.

Furthermore, please look at PER_CPU() and friends as alternatives to
[NR_CPUS] arrays.
