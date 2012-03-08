Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2CHNFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:05:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab2CHNFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:05:15 -0500
Message-ID: <1331211877.11248.390.camel@twins>
Subject: Re: [RFC PATCH 5/5 single-thread-version] implement per-domain
 single-thread state machine call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Thu, 08 Mar 2012 14:04:37 +0100
In-Reply-To: <4F56DBDA.1020608@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
	 <4F56DBDA.1020608@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 11:54 +0800, Lai Jiangshan wrote:
> +static void srcu_advance_batches(struct srcu_struct *sp)
> +{
> +       int idx = 1 - (sp->completed & 0x1UL);
> +
> +       /*
> +        * SRCU read-side critical sections are normally short, so check
> +        * twice after a flip.
> +        */
> +       if (!rcu_batch_empty(&sp->batch_check1) ||
> +           !rcu_batch_empty(&sp->batch_check0)) {
> +               if (try_check_zero(sp, idx, 1)) {
> +                       rcu_batch_move(&sp->batch_done, &sp->batch_check1);
> +                       rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
> +                       if (!rcu_batch_empty(&sp->batch_check1)) {
> +                               srcu_flip(sp);
> +                               if (try_check_zero(sp, 1 - idx, 2)) {
> +                                       rcu_batch_move(&sp->batch_done,
> +                                               &sp->batch_check1);
> +                               }
> +                       }
> +               }
> +       }
> +} 

static void srcu_advance_batches(struct srcu_struct *sp)
{
	int idx = 1 - (sp->completed & 1);

	if (rcu_batch_empty(&sp->batch_check0) && 
	    rcu_batch_empty(&sp->batch_check1))
		return;

	if (!try_check_zero(sp, idx, 1))
		return;

	rcu_batch_move(&sp->batch_done,   &sp->batch_check1);
	rcu_batch_move(&sp->batch_check1, &sp->batch_check0);

	if (rcu_batch_empty(&sp->batch_check1))
		return;

	srcu_flip(sp);

	if (!try_check_zero(sp, idx^1, 2))
		return;

	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
}

Seems like a more readable version.. do check I didn't mess up the logic
though.
