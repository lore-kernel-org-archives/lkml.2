Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0EaIBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:01:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0EaIBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:01:04 -0400
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1273747705-7829-3-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 10:01:06 +0200
Message-ID: <1275292866.27810.21441.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
> Concurrency managed workqueue needs to be able to migrate tasks to a
> cpu which is online but !active for the following two purposes.
> 
> p1. To guarantee forward progress during cpu down sequence.  Each
>     workqueue which could be depended upon during memory allocation
>     has an emergency worker task which is summoned when a pending work
>     on such workqueue can't be serviced immediately.  cpu hotplug
>     callbacks expect workqueues to work during cpu down sequence
>     (usually so that they can flush them), so, to guarantee forward
>     progress, it should be possible to summon emergency workers to
>     !active but online cpus.

If we do the thing suggested in the previous patch, that is move
clearing active and rebuilding the sched domains until right after
DOWN_PREPARE, this goes away, right?

> p2. To migrate back unbound workers when a cpu comes back online.
>     When a cpu goes down, existing workers are unbound from the cpu
>     and allowed to run on other cpus if there still are pending or
>     running works.  If the cpu comes back online while those workers
>     are still around, those workers are migrated back and re-bound to
>     the cpu.  This isn't strictly required for correctness as long as
>     those unbound workers don't execute works which are newly
>     scheduled after the cpu comes back online; however, migrating back
>     the workers has the advantage of making the behavior more
>     consistent thus avoiding surprises which are difficult to expect
>     and reproduce, and being actually cleaner and easier to implement.

I still don't like this much, if you mark these tasks to simply die when
the queue is exhausted, and flush the queue explicitly on
CPU_UP_PREPARE, you should never need to do this.


After which I think you don't need this patch anymore..
