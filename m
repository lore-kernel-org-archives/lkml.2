Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0KKWW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:22:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:40231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab0KKWWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:22:25 -0500
Subject: Re: [PATCH 04/10] tile: convert to use clocksource_register_hz
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1289513176.2742.56.camel@work-vm>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
	 <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
	 <4CDC5E70.90102@tilera.com>  <1289513176.2742.56.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 23:22:13 +0100
Message-ID: <1289514133.2084.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 14:06 -0800, john stultz wrote:
> 1) How often is sched_clock guaranteed to be called? Once each tick, (so
> the maximum time in nohz mode would be reasonable?)

Never,.. sparc64 for example can stay in nohz mode for hours. We have a
nohz_exit hook for the kernel/sched_clock.c code though which resyncs us
against the GTOD.

> 2) What considerations for sched_clock wrapping is there in generic
> code? I see some considerations in kernel/sched_clock.c, but its not
> obvious the limits. On x86, the 64-bit TSC won't wrap (but might jump on
> non-synced systems, or halt in idle modes). Do architectures that have
> faster-wrapping counters need to handle the cycle accumulation
> internally? 

Basically all code assumes we wrap on the u64 boundary.

So the whole kernel/sched_clock.c machinery tries to make a crummy arch
sched_clock() usable, it syncs against the GTOD code (on tick, idle_exit
and nohz_exit) and only assumes the arch sched_clock() wraps at the u64
boundary, jumps, inter-cpu drift etc are all taken care of.


