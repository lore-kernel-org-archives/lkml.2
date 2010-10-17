Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0JQJwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:52:50 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55817 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0JQJwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:52:49 -0400
Subject: Re: [RFC][PATCH 6/7] perf: use jump_label to optimize the
 scheduler hooks
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20101014203625.552405859@chello.nl>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.552405859@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 11:52:39 +0200
Message-ID: <1287309159.1998.146.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 22:34 +0200, Peter Zijlstra wrote:
> +static inline void perf_event_task_sched_in(struct task_struct *task)
> +{
> +       JUMP_LABEL(&perf_task_events, have_events);
> +       return;
> +
> +have_events:
> +       __perf_event_task_sched_in(task);
> +} 

OK, so I hate the JUMP_LABEL() interface for it means we have to keep
writing these silly stubs.

How about something like:

#define COND_STMT(key, stmt)					\
do {								\
	__label__ jl_enabled;					\
	JUMP_LABEL(key, jl_enabled);				\
	if (0) {						\
jl_enabled:							\
		stmt;						\
	}							\
} while (0)


