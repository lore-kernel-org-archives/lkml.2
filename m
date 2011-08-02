Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1HBLtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:49:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58796 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1HBLtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:49:36 -0400
Subject: Re: [PATCH 2/7] perf, x86: Implement IBS initialization
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-3-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 13:49:01 +0200
Message-ID: <1312285741.1147.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> +/*
> + * This runs only on the current cpu. We try to find an LVT offset and
> + * setup the local APIC. For this we must disable preemption. On
> + * success we initialize all nodes with this offset. This updates then
> + * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
> + * the IBS interrupt vector is handled by perf_ibs_cpu_notifier that
> + * is using the new offset.
> + */
> +static int force_ibs_eilvt_setup(void)
> +{
> +       int offset;
> +       int ret;
> +
> +       preempt_disable();
> +       /* find the next free available EILVT entry, skip offset 0 */
> +       for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
> +               if (get_eilvt(offset))
> +                       break;
> +       }
> +       preempt_enable();
> +
> +       if (offset == APIC_EILVT_NR_MAX) {
> +               printk(KERN_DEBUG "No EILVT entry available\n");
> +               return -EBUSY;
> +       }
> +
> +       ret = setup_ibs_ctl(offset);
> +       if (ret)
> +               goto out;
> +
> +       if (!ibs_eilvt_valid()) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
> +       pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
> +
> +       return 0;
> +out:
> +       preempt_disable();
> +       put_eilvt(offset);
> +       preempt_enable();
> +       return ret;
> +} 

So I don't get any of that preempt_disable/enable crap in this patch,
but the above is esp. confusing. How is that preempt_disable() at out:
still valid? We could be running on an entirely different cpu from when
we did get_eilvt at the start.


