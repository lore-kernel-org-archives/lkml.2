Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0HKDTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:19:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:56364 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab0HKDTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:19:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,351,1278313200"; 
   d="scan'208";a="310552626"
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100810204856.GA16571@redhat.com>
References: <20100804151858.GB5130@lenovo>
	 <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo>
	 <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com>  <20100810204856.GA16571@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 11:19:39 +0800
Message-ID: <1281496779.2744.1365.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 04:48 +0800, Don Zickus wrote:
> > From d2739578199d881ae6a9537c1b96a0efd1cdea43 Mon Sep 17 00:00:00 2001
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Thu, 5 Aug 2010 16:19:59 +0200
> > Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> 
> On top of Robert's patch:
> (compiled tested only because I don't have a fancy button to trigger
> unknown nmis)

You can trigger unknown NMIs via apic->send_IPI_mask(cpu_mask,
NMI_VECTOR).

How about the algorithm as follow:

int perf_event_nmi_handler()
{
	...
	switch (cmd) {
	case DIE_NMIUNKNOWN:
		if (per_cpu(perfctr_prev_handled) > 1
		    && rdtsc() - per_cpu(perfctr_handled_timestamp) < 1000)
			return NOTIFY_STOP;
		else
			return NOTIFY_DONE;
	}
	...
	handled = x86_pmu.handle_irq(regs);
	per_cpu(perfctr_prev_handled) = per_cpu(perfctr_handled);
	per_cpu(perfctr_handled) = handled;
	if (handled) {
		per_cpu(perfctr_handled_timestamp) = rdtsc();
		return NOTIFY_STOP;
	} else
		return NOTIFY_DONE;
}

Best Regards,
Huang Ying


