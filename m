Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2GKHKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab2GKHKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:10:14 -0400
Date: Wed, 11 Jul 2012 10:10:06 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120711071006.GF23898@redhat.com>
References: <4FFAE6D8.5050609@gmail.com>
 <20120709141904.GC7298@redhat.com>
 <1341843844.3462.75.camel@twins>
 <4FFAED16.7050204@redhat.com>
 <4FFAEF13.7010108@gmail.com>
 <1341845396.3462.81.camel@twins>
 <4FFAEFF1.9000706@redhat.com>
 <1341845999.3462.86.camel@twins>
 <4FFCBD00.1030109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFCBD00.1030109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 05:38:40PM -0600, David Ahern wrote:
> On 7/9/12 8:59 AM, Peter Zijlstra wrote:
> >On Mon, 2012-07-09 at 17:51 +0300, Avi Kivity wrote:
> >>On 07/09/2012 05:49 PM, Peter Zijlstra wrote:
> >>>On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
> >>>>
> >>>>I found this testing changes to perf-kvm, but found the problem extends
> >>>>to just perf-record. With perf-record exclude_guest defaults to 1. See
> >>>>tools/perf/util/util.c, event_attr_init().
> >>>
> >>>You lost me there.. so perf-record defaults to exclude_guest=1 (which
> >>>would make the proposed patch I just send actually possible), but its
> >>>still going *bang* ?
> >>
> >>It's possible that the DS writes overshoot the MSR... or that there's a
> >>bug somewhere.
> >
> >OK, so the first thing to stare at is in what order the MSRs are
> >touched, I think you first need to stop the counter, then clear the PEBS
> >bits, then clear the DS_AREA one.
> >
> 
> Any updates on the options for this or is there still squinting
> going on with MSR orders?
> 
Looks like Avi is right about the overshoot. Can you test something like this?

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..5fb371a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
+	arr[1].host = cpuc->pebs_enabled;
+	arr[1].guest = 0;
+	*nr = 2;
 
-	*nr = 1;
 	return arr;
 }
 

> I guess it's a good thing Ingo's request for :pp to be the default
> was not implemented:
>   https://lkml.org/lkml/2012/5/14/26
> 
> David

--
			Gleb.
