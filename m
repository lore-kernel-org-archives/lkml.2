Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2B2RpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:45:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37129 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2B2RpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:45:01 -0500
Message-ID: <1330537489.11248.164.camel@twins>
Subject: Re: [PATCH v2] perf/x86: Fix HO/GO counting with SVM disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 29 Feb 2012 18:44:49 +0100
In-Reply-To: <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
References: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
	 <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 14:57 +0100, Joerg Roedel wrote:

> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 8944062..2c581b9 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -148,6 +148,8 @@ struct cpu_hw_events {
>          * AMD specific bits
>          */
>         struct amd_nb           *amd_nb;
> +       /* Inverted mask of bits to clear in the perf_ctr ctrl registers */
> +       u64                     perf_ctr_virt_mask;
>  
>         void                            *kfree_on_online;
>  };
> @@ -417,9 +419,11 @@ void x86_pmu_disable_all(void);
>  static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
>                                           u64 enable_mask)
>  {
> +       u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
> +
>         if (hwc->extra_reg.reg)
>                 wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
> -       wrmsrl(hwc->config_base, hwc->config | enable_mask);
> +       wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
>  }

Its starting to look like we should kill this helper, the extra_reg muck
is Intel only and the disable_mask is AMD.



Queued it for now though.. 
