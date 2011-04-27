Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1D0WG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:06:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33144 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab1D0WGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:06:24 -0400
Date: Thu, 28 Apr 2011 00:06:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
In-Reply-To: <20110427204139.1b0ea23b@neptune.home>
Message-ID: <alpine.LFD.2.02.1104272351290.3323@ionos>
References: <20110425180450.1ede0845@neptune.home> <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com> <20110425190032.7904c95d@neptune.home> <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com> <20110425203606.4e78246c@neptune.home> <20110425191607.GL2468@linux.vnet.ibm.com>
 <20110425231016.34b4293e@neptune.home> <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com> <20110425214933.GO2468@linux.vnet.ibm.com> <20110426081904.0d2b1494@pluto.restena.lu> <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home> <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com> <alpine.LFD.2.02.1104262314110.3323@ionos> <20110427081501.5ba28155@pluto.restena.lu> <20110427204139.1b0ea23b@neptune.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1129399958-1303941699=:3323"
Content-ID: <alpine.LFD.2.02.1104280006080.3323@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1129399958-1303941699=:3323
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.02.1104280006081.3323@ionos>

On Wed, 27 Apr 2011, Bruno Prémont wrote:
> On Wed, 27 April 2011 Bruno Prémont wrote:
> Voluntary context switches stay constant from the time on SLABs pile up.
> (which makes sense as it doesn't run get CPU slices anymore)
> 
> > > Can you please enable CONFIG_SCHED_DEBUG and provide the output of
> > > /proc/sched_stat when the problem surfaces and a minute after the
> > > first snapshot?
> 
> hm, did you mean CONFIG_SCHEDSTAT or /proc/sched_debug?
> 
> I did use CONFIG_SCHED_DEBUG (and there is no /proc/sched_stat) so I took
> /proc/sched_debug which exists... (attached, taken about 7min and +1min
> after SLABs started piling up), though build processes were SIGSTOPped
> during first minute.

Oops. /proc/sched_debug is the right thing.
 
> printk wrote (in case its timestamp is useful, more below):
> [  518.480103] sched: RT throttling activated

Ok. Aside of the fact that the CPU time accounting is completely hosed
this is pointing to the root cause of the problem.

kthread_rcu seems to run in circles for whatever reason and the RT
throttler catches it. After that things go down the drain completely
as it should get on the CPU again after that 50ms throttling break.

Though we should not ignore the fact, that the RT throttler hit, but
none of the RT tasks actually accumulated runtime.

So there is a couple of questions:

   - Why does the scheduler detect the 950 ms RT runtime, but does
     not accumulate that runtime to any thread

   - Why is the runtime accounting totally hosed

   - Why does that not happen (at least not reproducible) with 
     TREE_RCU

I need some sleep now, but I will try to come up with sensible
debugging tomorrow unless Paul or someone else beats me to it.

Thanks,

	tglx
--8323328-1129399958-1303941699=:3323--
