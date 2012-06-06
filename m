Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab2FFPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:47:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:39179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2FFPq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:46:58 -0400
Message-ID: <1338997600.2749.146.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 17:46:40 +0200
In-Reply-To: <20120606144417.GH19601@linux.vnet.ibm.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	 <1338913190.2749.10.camel@twins>
	 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
	 <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos>
	 <1338931856.2749.57.camel@twins> <20120605221240.GW2388@linux.vnet.ibm.com>
	 <1338972175.2749.78.camel@twins>
	 <20120606144417.GH19601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:44 -0700, Paul E. McKenney wrote:

> > I don't think the isolation means userspace while(1) applications is
> > interesting. Sure, some people do this, and we should dtrt for them, but
> > the far more interesting case is 'regular' applications that do use
> > system calls.
> 
> OK, I will bite.  What are the semantics/properties for your isolated set?

The scheduler will not place tasks from outside the set in the set and
vice versa. Applications outside the set should not affect those in the
set, except there where there are shared resources across the set
boundary.

So the example of 1 process with multiple threads, some inside some
outside have the obvious shared resource of the address space, hence TLB
invalidates etc. will come through.

Now the kernel as a whole is also a shared resource, and this is where
it all gets tricky, since if something inside the set ends up doing a
memory allocation, it will have to participate in mm/ locks etc.

Same with RCU, if you cannot stay in an extended grace period for some
reason or other, you have to participate in the global RCU state
machinery.

But it should be so that if you don't do any of these things, you should
also not be affected by them.

Now I realize this is a 'weak' model, but the 'strong' model proposed by
tglx would make it impossible to run anything but the while(1) stuff,
and that's of limited utility.


