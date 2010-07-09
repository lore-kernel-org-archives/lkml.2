Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0GIDJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:09:01 -0400
Received: from ozlabs.org ([203.10.76.45]:43479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab0GIDJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:09:00 -0400
Date: Fri, 9 Jul 2010 13:08:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/11] perf: register pmu implementations
Message-ID: <20100709030846.GN7771@brick.ozlabs.ibm.com>
References: <20100624142804.431553874@chello.nl>
 <20100624143406.764162308@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624143406.764162308@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:28:09PM +0200, Peter Zijlstra wrote:

> Simple registration interface for struct pmu, this provides the
> infrastructure for removing all the weak functions.

Seems to work on powerpc, but the sh bits don't seem quite right:

> Index: linux-2.6/arch/sh/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/sh/kernel/perf_event.c
> +++ linux-2.6/arch/sh/kernel/perf_event.c
> @@ -257,24 +257,24 @@ static void sh_pmu_read(struct perf_even
>  	sh_perf_event_update(event, &event->hw, event->hw.idx);
>  }
>  
> -static struct pmu pmu = {
> -	.enable		= sh_pmu_enable,
> -	.disable	= sh_pmu_disable,
> -	.read		= sh_pmu_read,
> -};
> -
> -struct pmu *hw_perf_event_init(struct perf_event *event)
> +static in sh_pmu_event_init(struct perf_event *event)

int?

>  {
>  	int err = __hw_perf_event_init(event);

We need a switch on event->attr.type so we return -ENOENT if it's
not PERF_TYPE_{HARDWARE,HW_CACHE,RAW}.  As it is we don't ever return
-ENOENT, which might stop software and tracepoint events from working.

Paul.
