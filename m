Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab1D2ULY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:11:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:44142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D2ULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:11:20 -0400
Date: Fri, 29 Apr 2011 22:10:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: john stultz <johnstul@us.ibm.com>, sedat.dilek@gmail.com,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
In-Reply-To: <20110429213100.75f771eb@neptune.home>
Message-ID: <alpine.LFD.2.02.1104292209220.3005@ionos>
References: <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home> <20110426190918.01660ccf@neptune.home> <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com> <alpine.LFD.2.02.1104262314110.3323@ionos> <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home> <alpine.LFD.2.02.1104272351290.3323@ionos> <alpine.LFD.2.02.1104281051090.19095@ionos> <BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com> <20110428102609.GJ2135@linux.vnet.ibm.com> <1303997401.7819.5.camel@marge.simson.net>
 <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com> <alpine.LFD.2.02.1104282044120.3005@ionos> <20110428222301.0b745a0a@neptune.home> <alpine.LFD.2.02.1104282227340.3005@ionos> <20110428224444.43107883@neptune.home> <alpine.LFD.2.02.1104282251080.3005@ionos>
 <1304027480.2971.121.camel@work-vm> <alpine.LFD.2.02.1104282353140.3005@ionos> <20110429213100.75f771eb@neptune.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-127621749-1304107849=:3005"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-127621749-1304107849=:3005
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 29 Apr 2011, Bruno Prémont wrote:
> On Fri, 29 April 2011 Thomas Gleixner wrote:
> > On Thu, 28 Apr 2011, john stultz wrote:
> > > On Thu, 2011-04-28 at 23:04 +0200, Thomas Gleixner wrote:
> > > > /me suspects hrtimer changes to be the real culprit.
> > > 
> > > I'm not seeing anything on right off, but it does smell like
> > > e06383db9ec591696a06654257474b85bac1f8cb would be where such an issue
> > > would crop up.
> > > 
> > > Bruno, could you try checking out e06383db9ec, confirming it still
> > > occurs (and then maybe seeing if it goes away at e06383db9ec^1)?
> > > 
> > > I'll keep digging in the meantime.
> > 
> > I found the bug already. The problem is that sched_init() calls
> > init_rt_bandwidth() which calls hrtimer_init() _BEFORE_
> > hrtimers_init() is called.
> > 
> > That was unnoticed so far as the CLOCK id to hrtimer base conversion
> > was hardcoded. Now we use a table which is set up at hrtimers_init(),
> > so the bandwith hrtimer ends up on CLOCK_REALTIME because the table is
> > in the bss.
> > 
> > The patch below fixes this, by providing the table statically rather
> > than runtime initialized. Though that whole ordering wants to be
> > revisited.
> 
> Works here as well (applied alone), /proc/$(pidof rcu_kthread)/sched shows
> total runtime continuing to increase beyond 950 and slubs continue being
> released!

Does the CPU time show up in top/ps as well now ?

Thanks,

	tglx
--8323328-127621749-1304107849=:3005--
