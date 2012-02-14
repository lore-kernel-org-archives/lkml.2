Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2BNVDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:03:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:30999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab2BNVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:03:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="110003080"
Message-ID: <4F3ACC02.9020003@linux.intel.com>
Date: Tue, 14 Feb 2012 13:02:58 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Arjan van de Ven <arjanvandeven@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, gregkh@linuxfoundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: smp: Start up non-boot CPUs asynchronously
References: <20120130205444.22f5e26a@infradead.org> <20120131125232.GD4408@elte.hu>	<20120131054155.371e8307@infradead.org> <20120131143130.GF13676@elte.hu>	<20120131072216.1ce78e50@infradead.org> <20120131161207.GA18357@elte.hu>	<20120131082439.575978c0@infradead.org> <4F3A1891.8060001@linux.vnet.ibm.com>	<4F3A2DFB.5000209@linux.vnet.ibm.com> <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com> <4F3ABCC1.5020000@linux.vnet.ibm.com>
In-Reply-To: <4F3ABCC1.5020000@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/2012 11:57 AM, Srivatsa S. Bhat wrote:

>> In addition to this, the reality is that the whole "bring cpus up"
>> sequence needs to be changed; the current one is very messy and requires
>> the hotplug lock for the whole bring up of each individual cpu... which
>> is a very unfortunate design; a much better design would be to only take
>> the lock for the actual registration of the newly brought up CPU to the
>> kernel, while running the physical bringup without the global lock.
>> If/when that change gets made, we can do the physical bring up in
>> parallel (with each other, but also with the rest of the kernel boot),
>> and do the registration en-mass at some convenient time in the boot,
>> potentially late.
>>
> 
> 
> Sounds like a good idea, but how will we take care of CPU_UP_PREPARE and
> CPU_STARTING callbacks then? Because, CPU_UP_PREPARE callbacks are run
> before bringing up the cpu and CPU_STARTING is called from the cpu that is
> coming up. Also, CPU_UP_PREPARE callbacks can be failed, which can lead
> to that particular cpu boot getting aborted. With the "late commissioning
> of CPUs" idea you proposed above, retaining such semantics could become
> very challenging.

some of these callbacks may need to be redesigned as well; or at least,
we may need to decouple the "physical" state of the CPU that's getting
brought up from the "logical" OS visible one.
