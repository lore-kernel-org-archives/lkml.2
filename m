Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1G2Q7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:59:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60984 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1G2Q7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:59:11 -0400
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-5-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 18:58:46 +0200
Message-ID: <1311958726.5890.411.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> +static int __kprobes
> +perf_ibs_nmi_handler(struct notifier_block *self,
> +                    unsigned long cmd, void *__args)
> +{
> +       struct die_args *args = __args;
> +       int handled = 0;
> +
> +       switch (cmd) {
> +       case DIE_NMI:
> +               break;
> +       default:
> +               return NOTIFY_DONE;
> +       }
> +
> +       handled += perf_ibs_handle_irq(&perf_ibs_fetch, args->regs);
> +       handled += perf_ibs_handle_irq(&perf_ibs_op, args->regs);
> +
> +       if (!handled)
> +               return NOTIFY_DONE;
> +
> +       inc_irq_stat(apic_perf_irqs);
> +
> +       return NOTIFY_STOP;
> +} 

So IBS cannot trigger the whole unknown NMI business? Wouldn't ibs_op
triggering while ibs_fetch just started latch the NMI line, the
in-progress NMI would handle both, and we then end up with a spare NMI?
