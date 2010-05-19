Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0ESJTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:19:39 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:59094 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755850Ab0ESJTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:19:36 -0400
Date: Wed, 19 May 2010 11:19:33 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to
	push model
Message-ID: <20100519091933.GA30741@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Nigel Cunningham <ncunningham@crca.org.au>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.jf.intel.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
	LKML <linux-kernel@vger.kernel.org>
References: <20100517182726.089700767@sbs-t61.sc.intel.com> <4BF1C595.3070707@crca.org.au> <20100517182726.089700767@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF1C595.3070707@crca.org.au> <20100517182726.089700767@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, May 17, 2010 at 11:27:26AM -0700, Suresh Siddha wrote:
> This is an updated version of patchset which is posted earlier at
> http://lkml.org/lkml/2009/12/10/470
> 
> Description:
> Existing nohz idle load balance logic uses the pull model, with one
> idle load balancer CPU nominated on any partially idle system and that
> balancer CPU not going into nohz mode. With the periodic tick, the
> balancer does the idle balancing on behalf of all the CPUs in nohz mode.
> 
> This is not very optimal and has few issues:
> * the balancer will continue to have periodic ticks and wakeup
>   frequently (HZ rate), even though it may not have any rebalancing to do on
>   behalf of any of the idle CPUs.
> * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
>   wakeup can result in an additional interrupt on a CPU doing the timer
>   broadcast.
> 
> The alternative is to have a push model, where all idle CPUs can enter nohz
> mode and any busy CPU kicks one of the idle CPUs to take care of idle
> balancing on behalf of a group of idle CPUs.
> 
> Following patches switches idle load balancer to this push approach.
> 
> Updates from the previous version:
> 
> * Busy CPU uses send_remote_softirq() for invoking SCHED_SOFTIRQ on the
>   idle load balancing cpu, which does the load balancing on behalf of
>   all the idle CPUs.
> 
> * Dropped the per NUMA node nohz load balancing as it doesn't detect
>   certain imbalance scenarios. This will be addressed later.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

This patchset works good on my notebook; the number of wakeups decreases
from ~2.5 to ~1.6 when booting with init=/bin/bash, disabling cursor
blinking and enabling USB autosuspend.

Thanks and best,
	Dominik
