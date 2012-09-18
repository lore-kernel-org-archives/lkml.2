Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2IRRIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:08:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2IRRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:08:07 -0400
Date: Tue, 18 Sep 2012 10:08:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: Keep activate-order equals to
 queue_work()-order
Message-ID: <20120918170802.GC8474@google.com>
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
 <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com>
 <20120918170519.GB8474@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918170519.GB8474@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:05:19AM -0700, Tejun Heo wrote:
> On Tue, Sep 18, 2012 at 04:36:53PM +0800, Lai Jiangshan wrote:
> > The whole workqueue.c keeps activate-order equals to queue_work()-order
> > in any given cwq except workqueue_set_max_active().
> > 
> > If this order is not kept, something may be not good:
> > 
> > first_work_fn() { release some resource; }
> > second_work_fn() { wait and request the resource; use resource; }
> > 
> > 1. user queues the first work.	# ->max_active is low, is queued on ->delayed_works.
> > 2. someone increases the >max_active via workqueue_set_max_active()
> > 3. user queues the second work.	# queued on cwq->pool.
> > 
> > When the second work is launched to execute, it waits the first work
> > to release the resource. But the first work is still in ->delayed_works,
> > it waits the first work to finish and them it can be activated.
> > 
> > It is bad. we fix it by activating the first work in the step 2.
> > 
> > I can't fully determine that it is workqueue's responsibility
> > or the user's responsibility.
> > If it is workqueue's responsibility, the patch needs go to -stable.
> > If it is user's responsibility. it is a nice cleanup, it can go to for-next.
> > I prefer it is workqueue's responsibility.
> 
> Unless max_active == 1, workqueue doesn't give any guarantee on
> execution order.  I don't think we need to care about this.

That said, I kinda like the patches.  Can you please update the
description on the second patch to something along the line of "use
common set_max_active logic which immediately makes use of the newly
increased max_mactive if there are delayed work items and also happens
to keep activation ordering"?

Thanks.

-- 
tejun
