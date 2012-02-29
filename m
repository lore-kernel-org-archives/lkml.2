Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765Ab2B2REU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:04:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977Ab2B2RET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:04:19 -0500
Date: Wed, 29 Feb 2012 19:03:57 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH v2] perf/x86: Fix HO/GO counting with SVM disabled
Message-ID: <20120229170357.GE11013@redhat.com>
References: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
 <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
 <4F4E5999.6080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E5999.6080600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 07:00:09PM +0200, Avi Kivity wrote:
> On 02/29/2012 03:57 PM, Joerg Roedel wrote:
> > It turned out that a performance counter on AMD does not
> > count at all when the GO or HO bit is set in the control
> > register and SVM is disabled in EFER.
> >
> > This patch works around this issue by masking out the HO bit
> > in the performance counter control register when SVM is not
> > enabled.
> >
> > The GO bit is not touched because it is only set when the
> > user wants to count in guest-mode only. So when SVM is
> > disabled the counter should not run at all and the
> > not-counting is the intended behaviour.
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > index 0397b23..67250a5 100644
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -1,4 +1,5 @@
> >  #include <linux/perf_event.h>
> > +#include <linux/export.h>
> >  #include <linux/types.h>
> >  #include <linux/init.h>
> >  #include <linux/slab.h>
> > @@ -357,7 +358,9 @@ static void amd_pmu_cpu_starting(int cpu)
> >  	struct amd_nb *nb;
> >  	int i, nb_id;
> >  
> > -	if (boot_cpu_data.x86_max_cores < 2)
> > +	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
> > +
> > +	if (boot_cpu_data.x86_max_cores < 2 || boot_cpu_data.x86 == 0x15)
> >  		return;
> 
> Why this (boot_cpu_data.x86 == 0x15) change?
> 
I think it is related to .cpu_starting callback now available in
amd_pmu_f15h where previously it wasn't.

--
			Gleb.
