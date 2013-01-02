Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3ABUVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:21:44 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:6566 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3ABUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:21:41 -0500
Message-ID: <1357158097.3652.36.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v3] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@googlers.com>
CC: <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 2 Jan 2013 20:21:37 +0000
In-Reply-To: <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
References: <cover.1356810877.git.decot@googlers.com>
	 <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.001
X-TM-AS-Result: No--18.926700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 11:57 -0800, David Decotigny wrote:
> In some cases, free_irq_cpu_rmap() is called while holding a lock
> (eg. rtnl).

I made fairly sure that it didn't get called while holding the RTNL
lock.  However it looks like some mlx4_en ethtool ops now call it
(indirectly).

> This can lead to deadlocks, because it invokes
> flush_scheduled_work() which ends up waiting for whole system
> workqueue to flush, but some pending works might try to acquire the
> lock we are already holding.

Which is why the kernel-doc says not to do that.  But realistically a
device driver may not easily be able to avoid holding either its
underlying device's lock or a susbsytem global lock... and presumably
there may sometimes be a work item that needs the device lock.

> This commit uses reference-counting to replace
> irq_run_affinity_notifiers(). It also removes
> irq_run_affinity_notifiers() altogether.
> 
> Signed-off-by: David Decotigny <decot@googlers.com>
[...]
> --- a/lib/cpu_rmap.c
> +++ b/lib/cpu_rmap.c
[...]
>  /**
>   * irq_cpu_rmap_add - add an IRQ to a CPU affinity reverse-map
> - * @rmap: The reverse-map
> + * @rmap: The per-IRQ reverse-map
[...]

Please drop this comment change; the only 'per-IRQ' thing is the IRQ
notifier structure which is private.

With that, you can add:

Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

