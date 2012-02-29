Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501Ab2B2RBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:01:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977Ab2B2RBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:01:00 -0500
Message-ID: <4F4E5999.6080600@redhat.com>
Date: Wed, 29 Feb 2012 19:00:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH v2] perf/x86: Fix HO/GO counting with SVM disabled
References: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com> <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 03:57 PM, Joerg Roedel wrote:
> It turned out that a performance counter on AMD does not
> count at all when the GO or HO bit is set in the control
> register and SVM is disabled in EFER.
>
> This patch works around this issue by masking out the HO bit
> in the performance counter control register when SVM is not
> enabled.
>
> The GO bit is not touched because it is only set when the
> user wants to count in guest-mode only. So when SVM is
> disabled the counter should not run at all and the
> not-counting is the intended behaviour.
>
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 0397b23..67250a5 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -1,4 +1,5 @@
>  #include <linux/perf_event.h>
> +#include <linux/export.h>
>  #include <linux/types.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> @@ -357,7 +358,9 @@ static void amd_pmu_cpu_starting(int cpu)
>  	struct amd_nb *nb;
>  	int i, nb_id;
>  
> -	if (boot_cpu_data.x86_max_cores < 2)
> +	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
> +
> +	if (boot_cpu_data.x86_max_cores < 2 || boot_cpu_data.x86 == 0x15)
>  		return;

Why this (boot_cpu_data.x86 == 0x15) change?



-- 
error compiling committee.c: too many arguments to function

