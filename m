Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3ABU3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:29:24 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:6692 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3ABU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:29:22 -0500
Message-ID: <1357158557.3652.42.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v3] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: Josh Triplett <josh@joshtriplett.org>
CC: David Decotigny <decot@googlers.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 2 Jan 2013 20:29:17 +0000
In-Reply-To: <20121229203644.GA31014@leaf>
References: <cover.1356810877.git.decot@googlers.com>
	 <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
	 <20121229203644.GA31014@leaf>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.001
X-TM-AS-Result: No--17.736600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 12:36 -0800, Josh Triplett wrote:
> On Sat, Dec 29, 2012 at 11:57:09AM -0800, David Decotigny wrote:
> > In some cases, free_irq_cpu_rmap() is called while holding a lock
> > (eg. rtnl). This can lead to deadlocks, because it invokes
> > flush_scheduled_work() which ends up waiting for whole system
> > workqueue to flush, but some pending works might try to acquire the
> > lock we are already holding.
> > 
> > This commit uses reference-counting to replace
> > irq_run_affinity_notifiers(). It also removes
> > irq_run_affinity_notifiers() altogether.
> > 
> > Signed-off-by: David Decotigny <decot@googlers.com>
> 
> You might consider adding a cpu_rmap_get to parallel cpu_rmap_put.
> 
> Also, why keep free_cpu_rmap around at this point?  As far as I can
> tell, it has no callers.
> 
> Otherwise, this looks good to me.

I intended to make cpu_rmap usable independently of IRQ notification,
although as you note there have been no other users so far.
free_cpu_rmap() is now effectively an alias for cpu_rmap_put(), and the
latter *does* have a caller.  So perhaps cpu_rmap_put() should be extern
and the alias dropped.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

