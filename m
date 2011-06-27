Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1F0TEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1F0TEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:04:13 -0400
Date: Mon, 27 Jun 2011 15:03:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110627190358.GQ3765@redhat.com>
References: <20110623124918.GC13050@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623124918.GC13050@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 04:49:18PM +0400, Cyrill Gorcunov wrote:
> Due to restriction and specifics of Netburst PMU we need a separated
> event for NMI watchdog. In particular every Netburst event consume not
> just a counter and config register, but also an additional ESCR register.
> Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
> for some event there is no room for another event to enter until it's
> released) we need to pick up "least" used ESCR (or most available)
> for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.

I have tested this on a p4 and a westmere using 'perf top' and then
lkdtm's 'HARDLOCKUP' command.  Both seemed to work correctly indicating
that the watchdog and perf were co-existing peacefully. :-)

Thanks Cyrill.

Tested-and-reviewed-by: Don Zickus <dzickus@redhat.com>

> Index: linux-2.6.git/kernel/watchdog.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/watchdog.c
> +++ linux-2.6.git/kernel/watchdog.c
> @@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
>  }
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> +

Though I do wonder about this call in the watchdog.  I thought it might be
better elsewhere but not sure where.

Cheers,
Don
