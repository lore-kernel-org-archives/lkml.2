Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1FNKKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:10:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1FNKKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:10:30 -0400
Subject: Re: [PATCH 5/7] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1308007897-17013-6-git-send-email-glommer@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
	 <1308007897-17013-6-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 12:10:03 +0200
Message-ID: <1308046203.19856.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 19:31 -0400, Glauber Costa wrote:
> +static inline int touch_steal_time(int is_idle)
> +{
> +       u64 steal, st = 0;
> +
> +       if (static_branch(&paravirt_steal_enabled)) {
> +
> +               steal = paravirt_steal_clock(smp_processor_id());
> +
> +               steal -= this_rq()->prev_steal_time;
> +               this_rq()->prev_steal_time += steal;

If you move this addition below this test:

> +               if (is_idle || (steal < TICK_NSEC))
> +                       return 0;

that is, right here, then you don't loose tiny steal deltas and
subsequent ticks accumulate their steal time until you really
have a full steal tick to account.

I guess you want something different for the idle case though.

> +               while (steal > TICK_NSEC) {

			/* really, if we wanted a division we'd have written one */
			asm("" : "+rm" (steal));

> +                       steal -= TICK_NSEC;
> +                       st++;
> +               }
> +
> +               account_steal_time(st);
> +               return 1;
> +       }
> +       return 0;
> +} 


