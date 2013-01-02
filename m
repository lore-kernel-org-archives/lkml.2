Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3ABXqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:46:53 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:49948 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ABXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:46:51 -0500
Message-ID: <1357170406.3652.66.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 2 Jan 2013 23:46:46 +0000
In-Reply-To: <20130102151242.fc6f1bee.akpm@linux-foundation.org>
References: <cover.1357163124.git.decot@googlers.com>
	 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
	 <20130102151242.fc6f1bee.akpm@linux-foundation.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.001
X-TM-AS-Result: No--31.335700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 15:12 -0800, Andrew Morton wrote:
> On Wed,  2 Jan 2013 13:52:25 -0800
> David Decotigny <decot@googlers.com> wrote:
> 
> > In some cases, free_irq_cpu_rmap() is called while holding a lock
> > (eg. rtnl). This can lead to deadlocks, because it invokes
> > flush_scheduled_work() which ends up waiting for whole system
> > workqueue to flush, but some pending works might try to acquire the
> > lock we are already holding.
> > 
> > This commit uses reference-counting to replace
> > irq_run_affinity_notifiers(). It also removes
> > irq_run_affinity_notifiers() altogether.
> 
> I can't say that I've ever noticed cpu_rmap.c before :( Is is too late
> to review it?
> 
> - The naming is chaotic.  At least these:
> 
> 	EXPORT_SYMBOL(alloc_cpu_rmap);
> 	EXPORT_SYMBOL(free_cpu_rmap);
> 	EXPORT_SYMBOL(cpu_rmap_add);
> 	EXPORT_SYMBOL(cpu_rmap_update);
> 	EXPORT_SYMBOL(free_irq_cpu_rmap);
> 	EXPORT_SYMBOL(irq_cpu_rmap_add);
> 
>   should be consistently named cpu_rmap_foo()

There is a common practice of defining alloc_foo() and free_foo()
alongside foo_do_this() and foo_do_that().  I deliberately chose to
follow that.  If this is deprecated then it should be documented
somewhere.

There is also a separation between functions that are specific to IRQ
affinity (last 2) and those that are not (first 4).

> - What's the locking model?  It appears to be caller-provided, but
>   it is undocumented.

I think caller-provided can be assumed as the default for library code.
And IRQ setup and teardown need to be properly serialised in the driver
already.

>   drivers/net/ethernet/mellanox/mlx4/ appears to be using
>   msix_ctl.pool_lock for exclusion, but I didn't check for coverage.
>
>   drivers/net/ethernet/sfc/efx.c seems to not need locking because
>   all its cpu_rmap operations are at module_init() time.
>
>   The cpu_rmap code would be less of a hand grenade if each of its
>   interface functions documented the caller's locking requirements.

This particular 'hand grenade' *was* documented.  So I don't think
documentation is the problem.

> As for this patch: there's no cc:stable here but it does appear that
> the problem is sufficiently serious to justify a backport, agree?
[...]

Not sure.  So far as I can see, nothing called free_irq_cpu_rmap() while
holding the RTNL lock before v3.8-rc1.  If there can be work items on a
global workqueue that lock a PCI device (perhaps EEH?) then stable
versions may also be affected.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

