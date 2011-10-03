Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1JCPlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:41:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab1JCPlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:41:37 -0400
Date: Mon, 3 Oct 2011 17:41:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 6/9] perf, intel: Use GO/HO bits in perf-ctr
Message-ID: <20111003154113.GB3225@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
 <1317649795-18259-7-git-send-email-gleb@redhat.com>
 <4E89CF73.4020208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89CF73.4020208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:06:27PM +0200, Avi Kivity wrote:
> On 10/03/2011 03:49 PM, Gleb Natapov wrote:
> >Intel does not have guest/host-only bit in perf counters like AMD
> >does.  To support GO/HO bits KVM needs to switch EVENTSELn values
> >(or PERF_GLOBAL_CTRL if available) at a guest entry. If a counter is
> >configured to count only in a guest mode it stays disabled in a host,
> >but VMX is configured to switch it to enabled value during guest entry.
> >
> >This patch adds GO/HO tracking to Intel perf code and provides interface
> >for KVM to get a list of MSRs that need to be switched on a guest entry.
> >
> >Only cpus with architectural PMU (v1 or later) are supported with this
> >patch.  To my knowledge there is not p6 models with VMX but without
> >architectural PMU and p4 with VMX are rare and the interface is general
> >enough to support them if need arise.
> >
> >+
> >+static int core_guest_get_msrs(int cnt, struct perf_guest_switch_msr *arr)
> >+{
> >+	struct cpu_hw_events *cpuc =&__get_cpu_var(cpu_hw_events);
> >+	int idx;
> >+
> >+	if (cnt<  x86_pmu.num_counters)
> >+		return -ENOMEM;
> >+
> >+	for (idx = 0; idx<  x86_pmu.num_counters; idx++)  {
> >+		struct perf_event *event = cpuc->events[idx];
> >+
> >+		arr[idx].msr = x86_pmu_config_addr(idx);
> >+		arr[idx].host = arr[idx].guest = 0;
> >+
> >+		if (!test_bit(idx, cpuc->active_mask))
> >+			continue;
> >+
> >+		arr[idx].host = arr[idx].guest =
> >+				event->hw.config | ARCH_PERFMON_EVENTSEL_ENABLE;
> >+
> >+		if (event->attr.exclude_host)
> >+			arr[idx].host&= ~ARCH_PERFMON_EVENTSEL_ENABLE;
> >+		else if (event->attr.exclude_guest)
> >+			arr[idx].guest&= ~ARCH_PERFMON_EVENTSEL_ENABLE;
> >+	}
> >+
> >+	return 0;
> >+}
> 
> Would be better to calculate these when the host msrs are
> calculated, instead of here, every vmentry.
>
For arch PMU v2 and greater it is precalculated. For v1 (which is almost
non existent, even my oldest cpu with VMX has v2 PMU) I am not sure it
will help since we need to copy information to perf_guest_switch_msr
array anyway here.

--
			Gleb.
