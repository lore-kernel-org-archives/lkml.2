Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1LCBxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:53:43 -0500
Received: from mga12.intel.com ([143.182.124.36]:51373 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901Ab1LCBxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111202235655.24470.24712.stgit@localhost6.localdomain6>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
	<20111202235655.24470.24712.stgit@localhost6.localdomain6>
Date: Fri, 2 Dec 2011 17:53:40 -0800
Message-ID: <CABE8wwvLysxv=dGxsP2zKAvWFaZwHdZDf9PwXpdYHZQNDTvJpg@mail.gmail.com>
Subject: Re: [PATCH 2/3] workqueue: defer work to a draining queue
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: tj@kernel.org, JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 3:56 PM, Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> @@ -2405,7 +2434,7 @@ void drain_workqueue(struct workqueue_struct *wq)
>         */
>        spin_lock_irq(&workqueue_lock);
>        if (!wq->nr_drainers++)
> -               wq->flags |= WQ_DRAINING;
> +               wq->flags |= WQ_DRAINING | flags;
>        spin_unlock_irq(&workqueue_lock);
>  reflush:
>        flush_workqueue(wq);
> @@ -2429,9 +2458,25 @@ reflush:
>        }
>
>        spin_lock_irq(&workqueue_lock);
> -       if (!--wq->nr_drainers)
> -               wq->flags &= ~WQ_DRAINING;
> +       if (!--wq->nr_drainers) {
> +               wq->flags &= ~(WQ_DRAINING | WQ_NO_DEFER);
> +               list_splice_init(&wq->drain_defer, &drain_defer);
> +               ret = !list_empty(&drain_defer);
> +       }
>        spin_unlock_irq(&workqueue_lock);
> +
> +       /* requeue work on this queue provided it was not being destroyed */
> +       list_for_each_entry_safe(work, w, &drain_defer, entry) {
> +               list_del_init(&work->entry);
> +               queue_work(wq, work);
> +       }

Actually, this won't work.  The queuing of deferred work would need to
be under the lock and then flushed again to guarantee workqueue
semantics which just devolves into a "wait until all work stops being
submitted to the queue for one drain_workqueue() duration".  Which is
more than what we need for libsas.
