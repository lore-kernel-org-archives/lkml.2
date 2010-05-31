Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0EaIAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:00:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:48936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0EaIAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:00:54 -0400
Subject: Re: [PATCH 1/4] sched: consult online mask instead of active in
 select_fallback_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1273747705-7829-2-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 10:01:04 +0200
Message-ID: <1275292864.27810.21440.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
> If called after sched_class chooses a CPU which isn't in a task's
> cpus_allowed mask, select_fallback_rq() can end up migrating a task
> which is bound to an !active but online cpu to an active cpu.  This is
> dangerous because active is cleared before CPU_DOWN_PREPARE is called
> and subsystems expect affinities of kthreads and other tasks to be
> maintained till their CPU_DOWN_PREPARE callbacks are complete.

So 6ad4c188 (sched: Fix balance vs hotplug race) moved it that early
because it was done too late.

Could we not instead do it explicitly after CPU_DOWN_PREPARE? It would
of course mean removing the partition_sched_domain() and
generate_sched_domains() calls from these callbacks and doing it
explicitly.

So we need to do it before we take the CPU down, but I think we can do
it after DOWN_PREPARE.

> Consult cpu_online_mask instead.
> 
> This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
> callback creates the trustee kthread and kthread_bind()s it to the
> target cpu, and the trustee is expected to run on that cpu.

It doesn't explain wth a trustee kthread is, which pretty much renders
the whole paragraph useless.
