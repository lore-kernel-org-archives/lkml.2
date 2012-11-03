Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2KCJTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:19:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53195 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KCJTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:19:13 -0400
Date: Sat, 3 Nov 2012 02:19:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121103091909.GI3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5093EE6B.3070906@gmail.com>
 <20121102181026.GY3027@linux.vnet.ibm.com>
 <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110309-7408-0000-0000-000009ED839F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 08:19:04PM +0000, Christoph Lameter wrote:
> On Fri, 2 Nov 2012, Paul E. McKenney wrote:
> 
> > On Sat, Nov 03, 2012 at 12:01:47AM +0800, Shan Wei wrote:
> > > From: Shan Wei <davidshan@tencent.com>
> > >
> > > Signed-off-by: Shan Wei <davidshan@tencent.com>
> > > ---
> > >  kernel/rcutree.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > index 74df86b..441b945 100644
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
> > >  	struct rcu_node *rnp_old = NULL;
> > >
> > >  	/* Funnel through hierarchy to reduce memory contention. */
> > > -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> > > +	rnp = __this_cpu_read(rsp->rda->mynode);
> >
> > OK, I'll bite...  Why this instead of:
> >
> > 	rnp = __this_cpu_read(rsp->rda)->mynode;
> 
> Because this_cpu_read fetches a data word from an address. The addres is
> relocated using a segment prefix (which contains the offset of the
> current per cpu area).
> 
> And the address needed here is the address of the field of mynode
> within a structure that has a per cpu address.

OK, I do understand why it happens to work.  My question is instead why
it is considered a good idea.  After all, it is the ->rda field that is
marked __percpu, not the ->mynode field.  So in the interest of
mechanical checking and general readability, it seems to me that it
would be way better to apply __this_cpu_read() to rsp->rda rather than
to rsp->rda->mynode.

							Thanx, Paul

