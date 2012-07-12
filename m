Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161324Ab2GLQGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161293Ab2GLQGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:06:42 -0400
Date: Thu, 12 Jul 2012 19:06:35 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120712160634.GI7298@redhat.com>
References: <1341845396.3462.81.camel@twins>
 <4FFAEFF1.9000706@redhat.com>
 <1341845999.3462.86.camel@twins>
 <4FFCBD00.1030109@gmail.com>
 <20120711071006.GF23898@redhat.com>
 <1342000187.3462.134.camel@twins>
 <20120711095337.GJ23898@redhat.com>
 <4FFE4E8D.90606@gmail.com>
 <20120712042923.GG7298@redhat.com>
 <4FFEEB55.5070009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFEEB55.5070009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 09:20:53AM -0600, David Ahern wrote:
> On 7/11/12 10:29 PM, Gleb Natapov wrote:
> >On Wed, Jul 11, 2012 at 10:11:57PM -0600, David Ahern wrote:
> >>On 7/11/12 3:53 AM, Gleb Natapov wrote:
> >>>On Wed, Jul 11, 2012 at 11:49:47AM +0200, Peter Zijlstra wrote:
> >>>>On Wed, 2012-07-11 at 10:10 +0300, Gleb Natapov wrote:
> >>>>
> >>>>>Looks like Avi is right about the overshoot. Can you test something like this?
> >>>>>
> >>>>>diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> >>>>>index 166546e..5fb371a 100644
> >>>>>--- a/arch/x86/kernel/cpu/perf_event_intel.c
> >>>>>+++ b/arch/x86/kernel/cpu/perf_event_intel.c
> >>>>>@@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
> >>>>>  	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
> >>>>>  	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> >>>>>  	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> >>>>>+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
> >>>>>+	arr[1].host = cpuc->pebs_enabled;
> >>>>>+	arr[1].guest = 0;
> >>>>>+	*nr = 2;
> >>>>>
> >>>>>-	*nr = 1;
> >>>>>  	return arr;
> >>>>>  }
> >>>>
> >>
> >>So far the 64-bit Fedora 10 VM with both a Fedora 10 stock kernel
> >>and a 2.6.38 kernel have not faired well - and that's the only VM I
> >>have tried at the moment. Using -e cycles:pp I have been able to
> >>lock up the VM 3 times out of 3 series of tests with perf-kvm that
> >>includes network traffic (e.g., netperf), disk I/O (dd based to
> >>create a file with dsync flag) and pure userspace cpu bound (openssl
> >>speed). May or may not be related.
> >>
> >OK that's may be BTSes. What about -e cycles:p? BTW are you using your
> >patch to set exclude_guest parameter? If not use -e cycles:Hp.
> 
> I started with cycles:pp; should not really matter - they all need
> to work without blowing up VMs (cycles:p, cycles:pH, cycles:pG,
> cycles:pp, cycles:ppH, cycles:ppG).
cycles:ppG and cycles:pG should be illegal. Peter's patch takes care of
this. Others should set exclude guest and have to work without blowing
up VMs.

> 
> For grins I ran a quick test while reading emails this morning. This
> time a fedora 17 VM with 3.4.0-1.fc17.x86_64 kernel. It too locks up
> pretty quickly - just a couple of iterations of perf:
> 
> perf kvm --guestmount=/tmp/guest-mount record -fo /tmp/perf.data -a
> -v -e cycles:pH -- sleep 60
Do not run perf kvm. It does not set exclude_guest and :p and :pp is not
compatible with guest profiling and should be disallowed. Again Peter's
patch takes care of this.

Run perf top -e cycles:pH or similar.

> 
> Note the :pH this time.
I am not sure what perf kvm does with :pH modifier, but H modifier does
not make sense with perf kvm and should be reported as an error by perf tool.

> 
> I did not have netserver installed in the VM so used a ping flood
> for network traffic.
> 
> >
> >>Also, I noted that 'perf kvm --guest record -e cycles:pp' does not
> >>generate a whole lot of samples -- like < 100 in a 20-second sample
> >>-- despite the fact that the guest is rather busy.
> >>
> >Host events do not suppose to generate events while guest is running.
> 
> My server has 16 cpus and the VM has only 2 vcpus; with the -a I
> would expect some host sampling. Note: in the above case :pp resets
> the exclude-host modifier set by the perf-kvm part, so hosts samples
> are not excluded. See parse_events_modifier().
Isn't this a bug? Why anything at all resets exclude-host set by
perf-kvm?


> 
> So, is the idea of your patch to not enable the PEBS in guest mode?
> 
Yes, the idea of my patch is to disable PEBS and the guest entry.

--
			Gleb.
