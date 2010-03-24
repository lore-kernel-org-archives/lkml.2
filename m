Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0CXPly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:41:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:49708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0CXPlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:41:53 -0400
Subject: Re: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
 select_fallback_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100315091010.GA9131@redhat.com>
References: <20100315091010.GA9131@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 16:41:24 +0100
Message-ID: <1269445284.5109.360.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 10:10 +0100, Oleg Nesterov wrote:
>  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
>  {
> +       struct rq *rq = cpu_rq(dead_cpu);
> +       int needs_cpu, dest_cpu;
> +       unsigned long flags;
>  again:
> +       local_irq_save(flags);
> +
> +       raw_spin_lock(&rq->lock);
> +       needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);

                                       ^ 
kernel/sched.c:5445: warning: ‘dest_cpu’ may be used uninitialized in this function

> +       if (needs_cpu)
> +               dest_cpu = select_fallback_rq(dead_cpu, p); 
