Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2FMD4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:56:54 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5804 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab2FMD4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:56:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JACgO2E95LKXc/2dsb2JhbABFtAUEgS2BCIIYAQEEAScTHA8UBQsIAxUDLhQlAyETG4drBLlUFIsTSYVIA5Ugj32CcoFN
Date: Wed, 13 Jun 2012 13:56:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liswp@linux.vnet.ibm.com>
Subject: Re: [PATCH] writeback: avoid race when update bandwidth
Message-ID: <20120613035647.GU22848@dastard>
References: <1339496803-2885-1-git-send-email-liwp.linux@gmail.com>
 <20120612112129.GA16639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612112129.GA16639@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:21:29PM +0800, Fengguang Wu wrote:
> On Tue, Jun 12, 2012 at 06:26:43PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> That email address is no longer in use?
> 
> > Since bdi->wb.list_lock is used to protect the b_* lists,
> > so the flushers who call wb_writeback to writeback pages will
> > stuck when bandwidth update policy holds this lock. In order
> > to avoid this race we can introduce a new bandwidth_lock who
> > is responsible for protecting bandwidth update policy.

This is not a race condition - it is a lock contention condition.


> This looks good to me. wb.list_lock could be contended and it's better
> for bdi_update_bandwidth() to use a standalone and hardly contended
> lock.

I'm not sure it will be "hardly contended". That's a global lock, so
now we'll end up with updates on different bdis contending and it's
not uncommon to see a couple of thousand processes on large machines
beating on balance_dirty_pages().  Putting a global scope lock
around such a function doesn't seem like a good solution to me.

Oh, and if you want to remove the dirty_lock from
global_update_limit(), then replacing the lock with a cmpxchg loop
will do it just fine....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
