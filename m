Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1GLSCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:02:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47845 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1GLSCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:02:12 -0400
Date: Tue, 12 Jul 2011 14:01:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712180151.GA18257@dumpdata.com>
References: <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712163947.GF2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E1C8C1E.005F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://darnok.org/xen/loop_cnt.log
> > 
> > which seems to imply that we are indeed stuck in that loop
> > forever.
> 
> It does indeed, thank you!  Also it looks like interrupts are
> disabled, and that timekeeping is similarly out of action.

.. With the latest patch the time looks to be advancing.

> Disabling CONFIG_NO_HZ would be an interesting test case.

Hadn't done that yet. Compiling a kernel with "# CONFIG_NO_HZ is not set"
right now.
> 
> > > o	Problems due to portions of the code attempting to use
> > > 	RCU read-side critical sections while in dyntick-idle mode.
> > > 	Frederic Weisbecker has located some of these, (though not yet
> > > 	in Xen) and he has some diagnositics which may be found at:
> > > 
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > 
> > > 	on branch eqscheck.2011.07.08a.
> > > 
> > > 	You need to enable CONFIG_PROVE_RCU for these diagnostics to
> > > 	be executed.
> > 
> > Ok, let me try those too.
> 
> Thank you!

Will shortly do this.
> 
> > > o	As always, there might be bugs in RCU.  ;-)
> > > 
> > > But the loop in task_waking_fair() looks like the most prominent smoking
> > > gun at the moment.
> 
> And could you also please try out the patch that I posted earlier?

With the previous patch and the .. this is getting confusing. With this patch:
http://darnok.org/xen/loop_cnt-extra.patch

I get this output: http://darnok.org/xen/log.loop_cnt-extra-patch (one guest
with 4 VCPUS) and http://darnok.org/xen/loop_cnt-extra-patch.log (the guest with 16 VCPUs)
