Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2KBUTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:19:09 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:30564 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544Ab2KBUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:19:07 -0400
Date: Fri, 2 Nov 2012 20:19:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <20121102181026.GY3027@linux.vnet.ibm.com>
Message-ID: <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com>
References: <5093EE6B.3070906@gmail.com> <20121102181026.GY3027@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Paul E. McKenney wrote:

> On Sat, Nov 03, 2012 at 12:01:47AM +0800, Shan Wei wrote:
> > From: Shan Wei <davidshan@tencent.com>
> >
> > Signed-off-by: Shan Wei <davidshan@tencent.com>
> > ---
> >  kernel/rcutree.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 74df86b..441b945 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
> >  	struct rcu_node *rnp_old = NULL;
> >
> >  	/* Funnel through hierarchy to reduce memory contention. */
> > -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> > +	rnp = __this_cpu_read(rsp->rda->mynode);
>
> OK, I'll bite...  Why this instead of:
>
> 	rnp = __this_cpu_read(rsp->rda)->mynode;

Because this_cpu_read fetches a data word from an address. The addres is
relocated using a segment prefix (which contains the offset of the
current per cpu area).

And the address needed here is the address of the field of mynode
within a structure that has a per cpu address.
