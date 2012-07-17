Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2GQSiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:38:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2GQSiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:38:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle workers
Date: Tue, 17 Jul 2012 20:43:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-pm@vger.kernel.org
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207172043.42659.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 17, 2012, Tejun Heo wrote:
> Currently, workqueue destroys all workers for offline CPUs unless
> there are lingering work items.  On some platforms, CPU hotplugs are
> used as part of runtime powersaving and thus can be very frequent.
> The overhead of destroying and re-creating workers on each cycle can
> be noticeable.
> 
> In addition, being different from the usual mode of opration,
> kill-all-idle involves separate driving logic, which currently is
> implemented across trustee_thread() and CPU hotplug notifier.  This is
> rather complex and ugly.
> 
> This patchset updates workqueue CPU hotplug path such that a
> disassociated global_cwq (the per-cpu worker pool) is run as if it's
> running as an unbound one (WQ_UNBOUND) - executing work items ASAP
> without concurrency management while following the usual worker
> management based on idle timer.
> 
> While this makes rebinding somewhat more complicated, as it has to be
> able to rebind idle workers too, it allows overall hotplug path to be
> much simpler.  A disassociating global_cwq simply becomes an unbound
> one at the end of CPU_DOWN_PREPARE and makes use of the same logic
> already existing for WQ_UNBOUND.  While re-associating, it switches
> back to a bound one.  Except during the transitions themselves, the
> usual worker management is always in effect making trustee
> unnecessary.
> 
>  0001-workqueue-perform-cpu-down-operations-from-low-prior.patch
>  0002-workqueue-drop-CPU_DYING-notifier-operation.patch
>  0003-workqueue-ROGUE-workers-are-UNBOUND-workers.patch
>  0004-workqueue-use-mutex-for-global_cwq-manager-exclusion.patch
>  0005-workqueue-drop-bind-from-create_worker.patch
>  0006-workqueue-reimplement-CPU-online-rebinding-to-handle.patch
>  0007-workqueue-don-t-butcher-idle-workers-on-an-offline-C.patch
>  0008-workqueue-remove-CPU-offline-trustee.patch
>  0009-workqueue-simplify-CPU-hotplug-code.patch
> 
> 0001 is fix for an unlikely race condition.  0002-0005 prepare for CPU
> hotplug reimplementation.  0006 reimplements re-binding such that it
> can handle idle workers too.  0007 drops killing idle workers of
> offline CPUs.  0008 replaces trustee with the usual management logic.
> 0009 refactors hotplug path a bit to clean it up.
> 
> This patchset is on top of "workqueue: reimplement high priority using
> a separate worker pool" patchset[1] and available on the following git
> branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-hotplug
> 
>  include/linux/cpu.h |    5 
>  kernel/workqueue.c  |  738 ++++++++++++++++++++--------------------------------
>  2 files changed, 296 insertions(+), 447 deletions(-)

I like these changes.

I suppose you're going to push them through your tree, right?  I that case
please free to add my Acked-by to them.

Thanks,
Rafael
