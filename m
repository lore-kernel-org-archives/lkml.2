Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1GLQce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:32:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:61941 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab1GLQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:32:32 -0400
Date: Tue, 12 Jul 2011 12:32:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        kulkarni.ravi4@gmail.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3 - under Xen,
 32-bit guest only.
Message-ID: <20110712163210.GB1186@dumpdata.com>
References: <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712151550.GA3397@linux.vnet.ibm.com>
 <20110712152259.GA3556@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712152259.GA3556@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E1C771A.00C2:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > http://darnok.org/xen/cpu1.log
> > > 
> > > OK, a fair amount of variety, then lots and lots of task_waking_fair(),
> > > so I still feel good about asking you for the following.
> > 
> > But...  But...  But...
> > 
> > Just how accurate are these stack traces?  For example, do you have
> > frame pointers enabled?  If not, could you please enable them?

Frame pointers are enabled.
> > 
> > The reason that I ask is that the wakeme_after_rcu() looks like it is
> > being invoked from softirq, which would be grossly illegal and could
> > cause any manner of misbehavior.  Did someone put a synchronize_rcu()
> > into an RCU callback or something?  Or did I do something really really

This is a 3.0-rc6 based kernels with the debug patch, the initial
RCU inhibit patch (where you disable the RCU checking during bootup) and
that is it.

What is bizzare is that the soft_irq shows but there is no corresponding
Xen eventchannel stack trace - there should have been also xen_evtchn_upcall
(which is the general code that calls the main IRQ handler.. which would make
the softirq call). This is assuming that the IRQ (timer one) is reguarly dispatching
(which it looks to be doing). Somehow getting just the softirq by itself is bizzre.

Perhaps an IPI has been sent that does this. Let me see what a stack
trace for an IPI looks like.

> > braindead inside the RCU implementation?
> > 
> > (I am looking into this last question, but would appreciate any and all
> > help with the other questions!)
> 
> OK, I was confusing Julie's, Ravi's, and Konrad's situations.

Do you want me to create a new email thread to keep this one seperate?

> The wakeme_after_rcu() is in fact OK to call from sofirq -- if and
> only if the scheduler is actually running.  This is what happens if
> you do a synchronize_rcu() given your CONFIG_TREE_RCU setup -- an RCU
> callback is posted that, when invoked, awakens the task that invoked
> synchronize_rcu().
> 
> And, based on http://darnok.org/xen/log-rcu-stall, Konrad's system
> appears to be well past the point where the scheduler is initialized.
> 
> So I am coming back around to the loop in task_waking_fair().
> 
> Though the patch I sent out earlier might help, for example, if early
> invocation of RCU callbacks is somehow messing up the scheduler's
> initialization.

Ok, let me try it out.
