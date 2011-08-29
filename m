Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1H2QPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:15:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62408 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1H2QPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:15:18 -0400
Date: Mon, 29 Aug 2011 18:15:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/32 RESEND] nohz: Drop ts->idle_active
Message-ID: <20110829161508.GA8649@somewhere>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-3-git-send-email-fweisbec@gmail.com>
 <1314627792.2816.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627792.2816.60.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:23:12PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:51 +0200, Frederic Weisbecker wrote:
> > ts->idle_active is used to know if we want to account the idle sleep
> > time. But ts->inidle is enough to check that.
> > 
> While possibly true, its not immediately obvious and no hints are
> supplied. For example: tick_check_nohz() would disable ->idle_active..
> where is this mirrored in the ->inidle state.

Hmm, you're right. By the time we call tick_check_nohz() (irq_enter())
and tick_nohz_stop_sched_tick() (irq_exit()) there may be a softirq
and then another hard irq that could update the idle time spuriously.

So the mapping inidle - idle_active is wrong.

Let's drop that patch.

> 
> Also, tick_nohz_stop_sched_tick() has this comment:
> 
> 	/*
> 	 * Set ts->inidle unconditionally. Even if the system did not
> 	 * switch to NOHZ mode the cpu frequency governers rely on the
> 	 * update of the idle time accounting in tick_nohz_start_idle().
> 	 */
> 	ts->inidle = 1;
> 
> Which suggest the ->inidle state doesn't accurately reflect things.
> 
> This is all rather hairy code, such changes really want more in terms of
> explanation.
> 
> 
