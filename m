Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1I0Xac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:30:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:57160 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1I0Xaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:30:30 -0400
Date: Wed, 28 Sep 2011 01:30:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 12/24] C6X: interrupt handling
In-Reply-To: <1317155405-26235-13-git-send-email-msalter@redhat.com>
Message-ID: <alpine.LFD.2.02.1109280115130.2711@ionos>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-13-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Tue, 27 Sep 2011, Mark Salter wrote:
> diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
> +static raw_spinlock_t core_irq_lock;

static DEFINE_RAW_SPINLOCK(...) please, so you can get rid of the
raw_spin_lock_init(...) below.

> +static int core_host_map(struct irq_host *h, unsigned int virq,
> +			 irq_hw_number_t hw)
> +{
> +	if (hw < 4 || hw >= NR_PRIORITY_IRQS)
> +		return -1;

Proper error code please, i.e -EINVAL or such

> +
> +	irq_set_status_flags(virq, IRQ_LEVEL);
> +	irq_set_chip_and_handler(virq, &core_chip, handle_level_irq);
> +	return 0;
> +}
> +
> +static struct irq_host_ops core_host_ops = {
> +	.map = core_host_map,
> +};
> +
> +void __init init_IRQ(void)
> +{
> +	struct device_node *np;
> +
> +	raw_spin_lock_init(&core_irq_lock);

See above.

Aside of that I'm still not too happy about the of_/irqhost/domain
code replication and the cleanup which needs to be done after that has
been solved. Though if you and Grant have a plan for that, I'm not in
the way.

Btw, keeping people who have been added to previous review comments of
a particular patch in the CC makes everyones life easier.

Thanks,

	tglx
