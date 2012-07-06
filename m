Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2GFMYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:24:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2GFMYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:24:20 -0400
Message-ID: <1341577439.7709.49.camel@twins>
Subject: Re: [PATCH 09/16] sched: normalize tg load contributions against
 runnable time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2012 14:23:59 +0200
In-Reply-To: <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:

> +       contrib = div_u64(sa->runnable_avg_sum << 12,
> +                         sa->runnable_avg_period + 1);

> +
> +       /*
> +        * Unlike a task-entity, a group entity may be using >=1 cpu globally.
> +        * However, in the case that it's using <1 cpu we need to form a
> +        * correction term so that we contribute the same load as a task of
> +        * equal weight. (Global runnable time is taken as a fraction over
> +        * 2^12.)
> +        */
> +       runnable_avg = atomic_read(&tg->runnable_avg);
> +       if (runnable_avg < (1<<12)) {
> +               se->avg.load_avg_contrib *= runnable_avg;
> +               se->avg.load_avg_contrib /= (1<<12);
> +       }


Did we really have to open-code a 4096 fixed point here? Couldn't we
re-use some of the existing _SCALE things.. if not why 12?


