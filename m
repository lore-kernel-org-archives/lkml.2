Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2BBGL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 01:11:26 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56778 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2BBGLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 01:11:25 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 22:11:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 38/41] rcu: Rework detection of use of
 RCU by offline CPUs
Message-ID: <20120202061106.GU29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-38-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-38-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:56AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Because newly offlined CPUs continue executing after completing the
> CPU_DYING notifiers, they legitimately enter the scheduler and use
> RCU while appearing to be offline.  This calls for a more sophisticated
> approach as follows:
> 
> 1.	RCU marks the CPU online during the CPU_UP_PREPARE phase.
> 
> 2.	RCU marks the CPU offline during the CPU_DEAD phase.
> 
> 3.	Diagnostics regarding use of read-side RCU by offline CPUs use
> 	RCU's accounting rather than the cpu_online_map.  (Note that
> 	__call_rcu() still uses cpu_online_map to detect illegal
> 	invocations within CPU_DYING notifiers.)
> 
> 4.	Offline CPUs are prevented from hanging the system by
> 	force_quiescent_state(), which pays attention to cpu_online_map.
> 	Some additional work (in a later commit) will be needed to
> 	guarantee that force_quiescent_state() waits a full jiffy before
> 	assuming that a CPU is offline, for example, when called from
> 	idle entry.
> 
> This approach avoids the false positives encountered when attempting to
> use more exact classification of CPU online/offline state.

Doesn't this fix need to happen *before* the earlier patches in this
series that add splats for RCU usage while offline?  Otherwise,
bisection can hit those splats.

- Josh Triplett
