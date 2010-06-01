Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0FAP52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:57:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab0FAP51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:57:27 -0400
Subject: Re: [PATCH 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
In-Reply-To: <1275332199-28082-3-git-send-email-tj@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
	 <1275332199-28082-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 17:57:26 +0200
Message-ID: <1275407846.27810.27627.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 20:56 +0200, Tejun Heo wrote:
> Currently, when a cpu goes down, cpu_active is cleared before
> CPU_DOWN_PREPARE starts and cpuset configuration is updated from a
> default priority cpu notifier.  When a cpu is coming up, it's set
> before CPU_ONLINE but cpuset configuration again is updated from the
> same cpu notifier.
> 
> For cpu notifiers, this presents an inconsistent state.  Threads which
> a CPU_DOWN_PREPARE notifier expects to be bound to the CPU can be
> migrated to other cpus because the cpu is no more inactive.
> 
> Fix it by updating cpu_active in the highest priority cpu notifier and
> cpuset configuration in the second highest when a cpu is coming up.
> Down path is updated similarly.  This guarantees that all other cpu
> notifiers see consistent cpu_active and cpuset configuration.
> 
> This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
> callback creates a kthread and kthread_bind()s it to the target cpu,
> and the thread is expected to run on that cpu.

I know we all love notifier lists, but doesn't the below code get lots
more readable if we don't play tricks with notifier priorities and
simply hardcode the few (perf/sched/cpuset) callbacks into the hotplug
paths?

Also, I'm afraid you've now inverted the relation between
cpu_active_mask and parition_sched_domains().

You need to first set/clear the active mask, then rebuild the domain.
But with your patch parition_sched_domains() gets called in the regular
DOWN_PREPARE path, while we only clear active at the very end, which
means we build the wrong domains.


