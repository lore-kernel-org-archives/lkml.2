Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab1DZRYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:24:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab1DZRYd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110426190918.01660ccf@neptune.home>
References: <20110425180450.1ede0845@neptune.home> <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
 <20110425190032.7904c95d@neptune.home> <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
 <20110425203606.4e78246c@neptune.home> <20110425191607.GL2468@linux.vnet.ibm.com>
 <20110425231016.34b4293e@neptune.home> <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
 <20110425214933.GO2468@linux.vnet.ibm.com> <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 10:18:22 -0700
Message-ID: <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:09 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Just in case, /proc/$(pidof rcu_kthread)/status shows ~20k voluntary
> context switches and exactly one non-voluntary one.
>
> In addition when rcu_kthread has stopped doing its work
> `swapoff $(swapdevice)` seems to block forever (at least normal shutdown
> blocks on disabling swap device).
> If I get to do it when I get back home I will manually try to swapoff
> and take process traces with sysrq-t.

That "exactly one non-voluntary one" sounds like the smoking gun.

Normally SCHED_FIFO runs until it voluntarily gives up the CPU. That's
kind of the point of SCHED_FIFO. Involuntary context switches happen
when some higher-priority SCHED_FIFO process becomes runnable (irq
handlers? You _do_ have CONFIG_IRQ_FORCED_THREADING=y in your config
too), and maybe there is a bug in the runqueue handling for that case.

Ingo, do you have any tests for SCHED_FIFO scheduling? Particularly
with UP and voluntary preempt?

                          Linus
