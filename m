Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1FXR4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:56:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:34665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1FXRz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:55:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,420,1304319600"; 
   d="scan'208";a="18187369"
Subject: Re: [patch 3/4] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
In-Reply-To: <1308901534.27849.10.camel@twins>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
	 <1308821119.1022.84.camel@twins>
	 <1308853153.15847.90.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1308901534.27849.10.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 24 Jun 2011 10:55:58 -0700
Message-Id: <1308938158.15847.190.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 00:45 -0700, Peter Zijlstra wrote:
> On Thu, 2011-06-23 at 11:19 -0700, Suresh Siddha wrote:
> > > In commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3 you mention that its
> > > specific to HT, wouldn't it make sense to limit the stop-machine use in
> > > the next patch to the sibling mask instead of the whole machine?
> > 
> > That specific issue was seen in the context of HT. But the SDM
> > guidelines (pre date HT and) are applicable for SMP too. 
> 
> Sure, but we managed to ignore those long enough, could we not continue
> to violate them and keep to the minimum that is working in practice?

No we didn't violate all of them.

There are two paths where we do the rendezvous. One is during cpu online
(either boot, hotplug, suspend/resume etc) where we init the MTRR
registers and another is when MTRR's change (through /proc/mtrr
interface) during runtime.

Before the commit 'd0af9eed5aa91b6b7b5049cae69e5ea956fd85c3' we were
indeed doing rendezvous of all the cpu's when we were dynamically
changing MTRR's.

And even in older kernels prior to 2.6.11 or so, we were doing
rendezvous on all occasions. And during cpu hotplug code revamp, we
broke the MTRR rendezvous for online paths which led to the WSM issue we
fixed in the commit 'd0af9eed5aa91b6b7b5049cae69e5ea956fd85c3'.

> From what I understand the explosion is WSM+/VMX on HT only because the
> siblings share state, or do we have proof that it yields problems
> between cores as well?

During dynamic MTRR register changes, I believe rendezvous of all the
cpu's is more critical, otherwise, there can be multiple cpu's accessing
the same memory location with different memory attributes and that can
potentially lead to memory corruption, machine-check etc.

During cpu online, I think we can be less aggressive (like perhaps
rendezvous only some of the HT/core siblings etc).

This is what we are planning to bring up with the cpu folks and see what
we can cut down and what is essential.

thanks,
suresh

