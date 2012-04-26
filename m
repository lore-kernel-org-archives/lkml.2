Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab2DZQJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:09:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab2DZQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:09:04 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=H15IAYsitMgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=otQ4BjsOvi84YuDQbAwA:9 a=YuOM6MSr3e4kuJX1YuEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335456539.28106.185.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ
 timers expire on correct CPU
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 12:08:59 -0400
In-Reply-To: <20120426155450.GD2407@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
	 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335445496.13683.21.camel@twins>
	 <20120426155450.GD2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 08:54 -0700, Paul E. McKenney wrote:

> > The simpler change looks to use mod_timer_pinned()
> 
> Good point!
> 
> Except...  Now that you mention it, I don't see how mod_timer_pinned()
> actually helps.  It looks to me like a CPU-hotplug operation will
> migrate the timers anyway.
> 
> This is actually (in theory) harmless in the RCU_FAST_NO_HZ case, because
> the CPU_DYING stuff will force a wakeup of the CPU in question, which
> will cancel the timer.  But still, mod_timer_pinned() has a rather
> misleading name.  ;-)
> 
> But a line is a line, so I made this change.
> 

It's expected that if you use this (or anything else pinned to a CPU)
that you add the hotplug hooks to handle a CPU going down.

There's only two users of this that I see. One is
arch/x86/kernel/apic/x2apic_uv_x.c, that has the hotplug handling. The
other is drivers/net/ethernet/tile/tilepro.c, that does not have hotplug
handling, but the tile arch does not support hotplug anyway:

arch/tile/kernel/process.c: cpu_idle()

			if (cpu_is_offline(cpu))
				BUG();  /* no HOTPLUG_CPU */

-- Steve


