Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab2IQS4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:56:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55876 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2IQS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:56:36 -0400
Date: Mon, 17 Sep 2012 11:56:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: fix leak of active
Message-ID: <20120917185620.GH18677@google.com>
References: <50568D85.5030309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50568D85.5030309@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Mon, Sep 17, 2012 at 10:40:05AM +0800, Lai Jiangshan wrote:
> try_to_grab_pending() leave LINKED tagalong in delayed queue when
> it deletes a work. This behavior will cause future
> cwq_activate_first_delayed() increase the ->nr_active wrongly,
> and may cause the whole cwq frozen.
> 
> example:
> 
> state:	cwq->max_active = 1, cwq->nr_active = 1
> 	one work in cwq->pool, many in cwq->delayed_works.
> 
> step1:	try_to_grab_pending() remove a work from delayed_works but leave tagalong.
> step2:	when the work in cwq->pool is finished, cwq_activate_first_delayed()
> 	move the tagalong to cwq->pool and increase the ->nr_active.
> 
> current state: cwq->nr_active = 1, but works of the cwq in cwq->pool are all NO_COLOR,
> 	so even when these works are finished, cwq->nr_active will not be decreased,
> 	and no work will be moved from cwq->delayed_works. the cwq is frozen.
> 
> Fix it by moving the tagalong to cwq->pool in try_to_grab_pending().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Nice spotting.

> @@ -1101,11 +1101,26 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
>  		 */
>  		smp_rmb();
>  		if (gcwq == get_work_gcwq(work)) {
> +			unsigned long delayed;
> +
> +			/*
> +			 * move LINKED tagalong(if exist) out from
> +			 * delayed queue. Otherwise some future
> +			 * cwq_activate_first_delayed() may move
> +			 * works(which are all NO_COLOR) to cwq->pool
> +			 * and increase the ->nr_active. It may
> +			 * cause the whole cwq frozen.
> +			 */
> +			delayed = *work_data_bits(work) & WORK_STRUCT_DELAYED;
> +			if (delayed)
> +				move_linked_works(work,
> +					&get_work_cwq(work)->pool->worklist,
> +					NULL);
> +
>  			debug_work_deactivate(work);
>  			list_del_init(&work->entry);
>  			cwq_dec_nr_in_flight(get_work_cwq(work),
> -				get_work_color(work),
> -				*work_data_bits(work) & WORK_STRUCT_DELAYED);
> +				get_work_color(work), delayed);

I'm a bit uneasy about how this introduces something which is on
active list but not quite active.  Can we first activate it and then
grab its pending?  IOW, change cwq_activate_first_delayed() to
cwq_activate_delayed() which takes @work instead and then call it with
the work item being grabbed in try_to_grab_pending() before dec'ing
nr_in_flight?

Thanks.

-- 
tejun
