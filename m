Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1EPKS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:18:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1EPKS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:18:26 -0400
Subject: Re: [patch 05/15] sched: add a timer to handle CFS bandwidth
 refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110503092904.895444153@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.895444153@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 12:18:08 +0200
Message-ID: <1305541088.2466.4102.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> @@ -1003,6 +1003,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>  
>         if (cfs_rq->nr_running == 1)
>                 list_add_leaf_cfs_rq(cfs_rq);
> +
> +       start_cfs_bandwidth(cfs_rq);
>  }
>  
>  static void __clear_buddies_last(struct sched_entity *se)
> @@ -1220,6 +1222,8 @@ static void put_prev_entity(struct cfs_r
>                 update_stats_wait_start(cfs_rq, prev);
>                 /* Put 'current' back into the tree. */
>                 __enqueue_entity(cfs_rq, prev);
> +
> +               start_cfs_bandwidth(cfs_rq);
>         }
>         cfs_rq->curr = NULL;
>  } 

OK, so while the first made sense the second had me go wtf?!, now I
_think_ you do that because do_sched_cfs_period_timer() can return idle
and stop the timer when no bandwidth consumption is seen for a while,
and thus we need to re-start the timer when we put the entity to sleep,
since that could have been a throttle.

If that's so then neither really do make sense and a big fat comment is
missing.

So why not start on the same (but inverse) condition that makes it stop?
