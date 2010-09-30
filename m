Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0I3LEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:04:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0I3LEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:04:42 -0400
Subject: Re: [PATCH 1/7] si time accounting accounts bh_disable'd time to
 si -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1285788096-29471-2-git-send-email-venki@google.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-2-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:04:22 +0200
Message-ID: <1285844662.2144.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
> Peter Zijlstra found a bug in the way softirq time is accounted in
> VIRT_CPU_ACCOUNTING on this thread.
> http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/01366.html
> 
> The problem is, softirq processing uses local_bh_disable internally. There
> is no way, later in the flow, to differentiate between whether softirq is
> being processed or is it just that bh has been disabled. So, a hardirq when bh
> is disabled results in time being wrongly accounted as softirq.
> 
> Looking at the code a bit more, the problem exists in !VIRT_CPU_ACCOUNTING
> as well. As account_system_time() in normal tick based accouting also uses
> softirq_count, which will be set even when not in softirq with bh disabled.
> 
> Peter also suggested solution of using 2 * SOFTIRQ_OFFSET as irq count
> for local_bh_{disable,enable} and using just SOFTIRQ_OFFSET while softirq
> processing. The patch below does that and adds API in_serving_softirq() which
> returns whether we are currently processing softirq or not.
> 
> Also changes one of the usages of softirq_count in net/sched/cls_cgroup.c
> to in_serving_softirq.
> 
> Looks like many usages of in_softirq really want in_serving_softirq. Those
> changes can be made individually on a case by case basis.
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

One nit: in_serving_softirq() doesn't seem right as either:

  - we're not accounting ksoftirq in it, or
  - we're are and VIRT_CPU_ACCOUNTING is again broken ;-)

So only the softirq from irq tails wants to have SOFTIRQ_OFFSET set, the
ksoftirqd stuff can be tested for using PF_flags or something (ksoftirq
doesn't currently have a PF_SOFTIRQ flag, but -rt does and we could
bring that over).
