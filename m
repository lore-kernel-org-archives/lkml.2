Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1GLOu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:50:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58472 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab1GLOu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:50:56 -0400
Date: Tue, 12 Jul 2011 07:49:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712144936.GD2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712141228.GA7831@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:12:28AM -0400, Konrad Rzeszutek Wilk wrote:
> > >   [<c042d0f5>] task_waking_fair+0x14  <--
> > 
> > Hmmm...  This is a 32-bit system, isn't it?
> 
> Yes. I ran this little loop:
> 
> #!/bin/bash
> 
> ID=`xl list | grep Fedora | awk '  { print $2}'`
> 
> rm -f cpu*.log
> while (true) do
> 	xl pause $ID
> 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 0 >> cpu0.log
> 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 1 >> cpu1.log
> 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 2 >> cpu2.log
> 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 3 >> cpu3.log
> 	xl unpause $ID
> done
> 
> To get an idea what the CPU is doing before it hits the task_waking_fair
> and there isn't anything daming. Here are the logs:
> 
> http://darnok.org/xen/cpu1.log

OK, a fair amount of variety, then lots and lots of task_waking_fair(),
so I still feel good about asking you for the following.

> > Could you please add a check to the loop in task_waking_fair() and
> > do a printk() if the loop does (say) more than 1000 passes without
> > exiting?
> 
> Of course. Let me queue that up.

Hmmm...  Given that this is persisting for many many seconds, it might
be better to check for at least 10,000,000 passes.  In contrast, 1000
passes might elapse just waiting for a cache miss to complete.

Other possible causes include:

o	A mismatch between Xen's and RCU's ideas of how CONFIG_NO_HZ
	works.  If Xen thinks that the CPU is in CONFIG_NO_HZ's
	dyntick-idle mode, but RCU thinks otherwise, the grace period
	might stall.

o	Problems due to portions of the code attempting to use
	RCU read-side critical sections while in dyntick-idle mode.
	Frederic Weisbecker has located some of these, (though not yet
	in Xen) and he has some diagnositics which may be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

	on branch eqscheck.2011.07.08a.

	You need to enable CONFIG_PROVE_RCU for these diagnostics to
	be executed.

o	As always, there might be bugs in RCU.  ;-)

But the loop in task_waking_fair() looks like the most prominent smoking
gun at the moment.

							Thanx, Paul
