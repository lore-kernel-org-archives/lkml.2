Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1GLPXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:23:04 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39693 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab1GLPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:23:02 -0400
Date: Tue, 12 Jul 2011 08:22:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        kulkarni.ravi4@gmail.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712152259.GA3556@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712151550.GA3397@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712151550.GA3397@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 08:15:50AM -0700, Paul E. McKenney wrote:
> On Tue, Jul 12, 2011 at 07:49:36AM -0700, Paul E. McKenney wrote:
> > On Tue, Jul 12, 2011 at 10:12:28AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > >   [<c042d0f5>] task_waking_fair+0x14  <--
> > > > 
> > > > Hmmm...  This is a 32-bit system, isn't it?
> > > 
> > > Yes. I ran this little loop:
> > > 
> > > #!/bin/bash
> > > 
> > > ID=`xl list | grep Fedora | awk '  { print $2}'`
> > > 
> > > rm -f cpu*.log
> > > while (true) do
> > > 	xl pause $ID
> > > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 0 >> cpu0.log
> > > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 1 >> cpu1.log
> > > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 2 >> cpu2.log
> > > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 3 >> cpu3.log
> > > 	xl unpause $ID
> > > done
> > > 
> > > To get an idea what the CPU is doing before it hits the task_waking_fair
> > > and there isn't anything daming. Here are the logs:
> > > 
> > > http://darnok.org/xen/cpu1.log
> > 
> > OK, a fair amount of variety, then lots and lots of task_waking_fair(),
> > so I still feel good about asking you for the following.
> 
> But...  But...  But...
> 
> Just how accurate are these stack traces?  For example, do you have
> frame pointers enabled?  If not, could you please enable them?
> 
> The reason that I ask is that the wakeme_after_rcu() looks like it is
> being invoked from softirq, which would be grossly illegal and could
> cause any manner of misbehavior.  Did someone put a synchronize_rcu()
> into an RCU callback or something?  Or did I do something really really
> braindead inside the RCU implementation?
> 
> (I am looking into this last question, but would appreciate any and all
> help with the other questions!)

OK, I was confusing Julie's, Ravi's, and Konrad's situations.
The wakeme_after_rcu() is in fact OK to call from sofirq -- if and
only if the scheduler is actually running.  This is what happens if
you do a synchronize_rcu() given your CONFIG_TREE_RCU setup -- an RCU
callback is posted that, when invoked, awakens the task that invoked
synchronize_rcu().

And, based on http://darnok.org/xen/log-rcu-stall, Konrad's system
appears to be well past the point where the scheduler is initialized.

So I am coming back around to the loop in task_waking_fair().

Though the patch I sent out earlier might help, for example, if early
invocation of RCU callbacks is somehow messing up the scheduler's
initialization.

							Thanx, Paul
