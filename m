Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2FTIgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:36:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42039 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2FTIge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
Date: Wed, 20 Jun 2012 10:36:32 +0200
Message-ID: <CABPqkBS=QAnoz3-_XgRPoRsUh4GbpHQe+u75dR=pLG2isC8Ccw@mail.gmail.com>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 8:10 PM, Robert Richter <robert.richter@amd.com> wrote:
>
> This patch adds northbridge counter support for AMD family 15h cpus.
>
> The NB counter implementation and usage is in the same way as for
> family 10h. Thus a nb event can now be selected as any other
> performance counter event. As for family 10h the kernel selects only
> one NB PMC per node by using the nb constraint handler.
>
> Main part of this patch set is to rework current code in a way that
> bit masks for counters can be used. Also, Intel's fixed counters have
> been moved to Intel only code. This is since AMD nb counters start at
> index 32 which leads to holes in the counter mask and causes conflicts
> with fixed counters.
>

I dont' quite understand the design choice here. In Fam15h, there is a clean
design for the uncore PMU. It has its own distinct set of 4 counters. Unlike
Fam10h, where you program core counters to access the NB counters. So
why not like with Intel uncore, create a separate NB PMU which would
advertise its characteristics? That does not preclude re-using the existing
AMD-specific routines wherever possible. I think the advantage is that
muxing or starting/stopping of the core PMU would not affect uncore and
vice-versa for instance. Wouldn't this also alleviate the problems with
assigning indexes to uncore PMU counters?

> Another major change is the unification of AMD pmus and, where
> possible, a family independent feature check based on cpuid.
>
> It should also be mentioned that nb perfctrs do not support all bits
> in the config value, see patch #10.
>
> -Robert
>
>
>
> Robert Richter (10):
>  perf, amd: Rework northbridge event constraints handler
>  perf, x86: Rework counter reservation code
>  perf, x86: Use bitmasks for generic counters
>  perf, x86: Rename Intel specific macros
>  perf, x86: Move Intel specific code to intel_pmu_init()
>  perf, amd: Unify AMD's generic and family 15h pmus
>  perf, amd: Generalize northbridge constraints code for family 15h
>  perf, amd: Enable northbridge counters on family 15h
>  perf, x86: Improve debug output in check_hw_exists()
>  perf, amd: Check northbridge event config value
>
>  arch/x86/include/asm/cpufeature.h         |    2 +
>  arch/x86/include/asm/kvm_host.h           |    4 +-
>  arch/x86/include/asm/perf_event.h         |   26 ++-
>  arch/x86/kernel/cpu/perf_event.c          |  129 +++++------
>  arch/x86/kernel/cpu/perf_event.h          |    7 +
>  arch/x86/kernel/cpu/perf_event_amd.c      |  368
> +++++++++++++++++------------
>  arch/x86/kernel/cpu/perf_event_intel.c    |   65 +++++-
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +-
>  arch/x86/kernel/cpu/perf_event_p4.c       |    8 +-
>  arch/x86/kvm/pmu.c                        |   22 +-
>  arch/x86/oprofile/op_model_amd.c          |    4 +-
>  11 files changed, 374 insertions(+), 265 deletions(-)
>
> --
> 1.7.8.4
>
>
