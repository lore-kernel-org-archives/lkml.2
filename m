Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1KHJ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:29:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:39221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1KHJ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:29:26 -0500
Subject: Re: [patch 1/3] sched: use jump labels to reduce overhead when
 bandwidth control is inactive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 08 Nov 2011 10:29:23 +0100
In-Reply-To: <20111108042736.560831357@google.com>
References: <20111108042632.977080206@google.com>
	 <20111108042736.560831357@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320744563.2244.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 20:26 -0800, Paul Turner wrote:
> @@ -1788,6 +1791,9 @@ static void do_sched_cfs_slack_timer(str
>   */
>  static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
>  {
> +       if (!cfs_bandwidth_used())
> +               return;
> +
>         /* an active group must be handled by the update_curr()->put() path */
>         if (!cfs_rq->runtime_enabled || cfs_rq->curr)
>                 return;
> @@ -1805,6 +1811,9 @@ static void check_enqueue_throttle(struc
>  /* conditionally throttle active cfs_rq's from put_prev_entity() */
>  static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>  {
> +       if (!cfs_bandwidth_used())
> +               return;
> +
>         if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
>                 return;
>   

does it matter if you pull this out into an inline function like:

static __always_inline void check_enqueue_throttle(struct cfs_rq *cfs_rq)
{
	if (cfs_bandwidth_used())
		__check_enqueue_throttle(cfs_rq);
}

That would avoid the superfluous function call as well.
