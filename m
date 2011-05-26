Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab1EZPq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1EZPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:46:58 -0400
Date: Thu, 26 May 2011 17:45:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110526154508.GA13788@redhat.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com> <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins> <1306358128.21578.107.camel@twins> <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com> <1306405979.1200.63.camel@twins> <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306412511.1200.90.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Peter Zijlstra wrote:
>
>  static void ttwu_queue(struct task_struct *p, int cpu)
>  {
> @@ -2631,17 +2650,17 @@ try_to_wake_up(struct task_struct *p, un
>  	while (p->on_cpu) {
>  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  		/*
> -		 * If called from interrupt context we could have landed in the
> -		 * middle of schedule(), in this case we should take care not
> -		 * to spin on ->on_cpu if p is current, since that would
> -		 * deadlock.
> +		 * In case the architecture enables interrupts in
> +		 * context_switch(), we cannot busy wait, since that
> +		 * would lead to live-locks when an interrupt hits and
> +		 * tries to wake up @prev. So bail and do a complete
> +		 * remote wakeup.
>  		 */
> -		if (p == current) {
> -			ttwu_queue(p, cpu);
> +		if (ttwu_activate_remote(p, wake_flags))

Stupid question. Can't we fix this problem if we do

	-	if (p == current)
	+	if (cpu == raw_smp_processor_id())

?

I forgot the rules... but iirc task_cpu(p) can't be changed under us?

Oleg.

