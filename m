Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1KGOhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:37:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:54385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1KGOhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:37:50 -0500
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 15:36:49 +0100
In-Reply-To: <1320323618-10375-3-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320676609.18053.44.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> +static u64 read_pmc(struct kvm_pmc *pmc)
> +{
> +       u64 counter, enabled, running;
> +
> +       counter = pmc->counter;
> +
> +       if (pmc->perf_event)
> +               counter += perf_event_read_value(pmc->perf_event,
> +                                                &enabled, &running);
> +
> +       /* FIXME: Scaling needed? */

Since the below programming doesn't use perf_event_attr::pinned, yes.

> +       return counter & pmc_bitmask(pmc);
> +}

> +static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
> +               unsigned config, bool exclude_user, bool exclude_kernel,
> +               bool intr)
> +{
> +       struct perf_event *event;
> +       struct perf_event_attr attr = {
> +               .type = type,
> +               .size = sizeof(attr),
> +               .exclude_idle = true,
> +               .exclude_host = 1,
> +               .exclude_user = exclude_user,
> +               .exclude_kernel = exclude_kernel,
> +               .sample_period = (-pmc->counter) & pmc_bitmask(pmc),
> +               .config = config,
> +       };
> +
> +       event = perf_event_create_kernel_counter(&attr, -1, current,
> +                                                intr ? kvm_perf_overflow_intr :
> +                                                kvm_perf_overflow, pmc);
> +       if (IS_ERR(event)) {
> +               printk_once("kvm: pmu event creation failed %ld\n",
> +                               PTR_ERR(event));
> +               return;
> +       }
> +
> +       pmc->perf_event = event;
> +       clear_bit(pmc->idx, (unsigned long*)&pmc->vcpu->arch.pmu.reprogram_pmi);
> +} 
