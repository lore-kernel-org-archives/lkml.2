Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1HJPFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab1HJPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:04:08 -0400
Date: Wed, 10 Aug 2011 11:03:31 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110810150331.GD2566@zod.bos.redhat.com>
References: <20110805142245.GP2096@zod.bos.redhat.com>
 <20110805170805.GB22164@somewhere>
 <20110805222641.GB2245@linux.vnet.ibm.com>
 <20110805231216.GE22164@somewhere>
 <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
 <20110808031014.GE2385@linux.vnet.ibm.com>
 <20110809113514.GA27301@somewhere.redhat.com>
 <20110810124528.GC2566@zod.bos.redhat.com>
 <20110810145338.GB569@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810145338.GB569@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:53:41PM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 10, 2011 at 08:45:29AM -0400, Josh Boyer wrote:
> > On Tue, Aug 09, 2011 at 01:35:18PM +0200, Frederic Weisbecker wrote:
> > > > But setting rdp->qs_pending to 1 in rcu_init_percpu_data() has no effect
> > > > until a grace period starts.  So, if grace periods are prevented from
> > 
> > Er... really?  Because it gets set and __rcu_pending looks at it
> > unconditionally in the case that is calling set_need_resched.  It
> > doesn't check if there is anything about a grace period going on or not.
> 
> You mean this?
> 
> 	if (rdp->qs_pending && !rdp->passed_quiesc) {
> 
> 		/*
> 		 * If force_quiescent_state() coming soon and this CPU
> 		 * needs a quiescent state, and this is either RCU-sched
> 		 * or RCU-bh, force a local reschedule.
> 		 */
> 		rdp->n_rp_qs_pending++;
> 		if (!rdp->preemptible &&
> 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
> 				 jiffies))
> 			set_need_resched();
> 	}
> 

Yes.

> On boot, if we don't start a grace period, we don't schedule a grace period forcing,
> so rsp->jiffies_force_qs is 0.

Ok.  I missed that cpu_needs_another_gp() would somehow prevent
rsp->jiffies_force_qs from getting set.

> With ULONG_CMP_LT taking care of (-1 < jiffies) to be valid even with
> ulong, then we are fine I guess.

I'd be happy to test a patch to make sure :)

josh
