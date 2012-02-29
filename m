Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681Ab2B2RFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:05:50 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27303
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964977Ab2B2RFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:05:48 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M05ZHC-02-5WL-02
X-M-MSG: 
Date: Wed, 29 Feb 2012 18:05:36 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <joro@8bytes.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH v2] perf/x86: Fix HO/GO counting with SVM disabled
Message-ID: <20120229170536.GE10684@amd.com>
References: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
 <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
 <4F4E5999.6080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F4E5999.6080600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
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

This is because this function did not run on Fam15h before but now it
has to so that cpuc->perf_ctr_virt_mask is initialized. The other stuff
done in this function is setup for northbridge counter. These are not
yet implemented for Fam15h CPUs so this setup must not run on those
CPUs. Therefore the check was added.
Once northbridge counters are implemented for Fam15h this check can go
away again.


	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

