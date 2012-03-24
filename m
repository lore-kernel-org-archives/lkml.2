Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2CXMpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 08:45:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36196 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2CXMpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 08:45:07 -0400
Message-ID: <1332593021.16159.27.camel@twins>
Subject: Re: [PATCH 01/10] cpu: Introduce clear_tasks_mm_cpumask() helper
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Date: Sat, 24 Mar 2012 13:43:41 +0100
In-Reply-To: <20120324102751.GA29067@lizard>
References: <20120324102609.GA28356@lizard> <20120324102751.GA29067@lizard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 14:27 +0400, Anton Vorontsov wrote:
> +void clear_tasks_mm_cpumask(int cpu)
> +{
> +       struct task_struct *p;
> +
> +       read_lock(&tasklist_lock);
> +       for_each_process(p) {
> +               struct task_struct *t;
> +
> +               t = find_lock_task_mm(p);
> +               if (!t)
> +                       continue;
> +               cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
> +               task_unlock(t);
> +       }
> +       read_unlock(&tasklist_lock);
> +} 

Why bother with the tasklist_lock at all anymore, afaict you could use
rcu_read_lock() here. This all is called after the cpu is taken down and
marked offline, so its not like new tasks will ever get this cpu set in
their mm mask.


