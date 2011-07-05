Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1GEKeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:34:08 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36257 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1GEKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:34:07 -0400
Date: Tue, 5 Jul 2011 14:34:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705103403.GN17941@sun>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705102017.GA12458@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 12:20:17PM +0200, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
...
> 
> So why don't we simply set this for all PERF_COUNT_HW_CPU_CYCLES 
> events in the P4 PMU driver? That would remove half of the patch 
> AFAICS.
> 
> Thanks,
> 
> 	Ingo

Unfortunately it doesn't solve the main issue -- nmi-watchdog events
and cpu clock events should be a separate events with non-intersected
ESCRs, otherwise nmi-watchdog and cpu-cycles can't operate simultaneously
like other PMUs does.

non-sleeping ticks use

	[P4_EVENT_EXECUTION_EVENT] = {
		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
		.cntr		= { {12, 13, 16}, {14, 15, 17}
	},

while cpu-cycles

	[P4_EVENT_GLOBAL_POWER_EVENTS] = {
		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
		.cntr		= { {0, -1, -1}, {2, -1, -1} },
	},

Note non-intersection of { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 } and
{ MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 } here (together with counters
itselves pointed by .cntr).

	Cyrill
