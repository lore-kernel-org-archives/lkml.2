Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2BPKRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:17:24 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42979 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2BPKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:17:21 -0500
Date: Thu, 16 Feb 2012 11:17:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        tony.luck@intel.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcos.mage@gmail.com,
        prasad@linux.vnet.ibm.com
Subject: Re: [PATCH] x86, mce: Fix rcu splat in drain_mce_log_buffer()
Message-ID: <20120216101714.GA17412@aftab>
References: <20120111142213.16610.85866.stgit@srivatsabhat.in.ibm.com>
 <20120111161153.GA2925@linux.vnet.ibm.com>
 <4F102353.1040109@linux.vnet.ibm.com>
 <20120113214435.GC2909@linux.vnet.ibm.com>
 <20120206161802.GC31237@aftab>
 <20120212174133.GL3737@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120212174133.GL3737@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 09:41:33AM -0800, Paul E. McKenney wrote:
> On Mon, Feb 06, 2012 at 05:18:02PM +0100, Borislav Petkov wrote:
> > On Fri, Jan 13, 2012 at 01:44:35PM -0800, Paul E. McKenney wrote:
> > > Looks good to me, but I do need to defer to people who know this code
> > > better than do I.  The key thing that (from what I can see) makes
> > > rcu_dereference() unnecessary is that the smp_rmb() used in conjunction
> > > with polling the .finished field takes care of ordering.
> > 
> > Right, this was me trying hard not to screw up touching mcelog.next,
> > thus trying to use the rcu_dereference_index_check() primitive without
> > thinking it through too much. But you're right, I'm polling the
> > ->finished field 4 times (totally arbitrary, btw) which should suffice
> > while the mce_log() routine above writes those entries.
> > 
> > Although, the question still remains, since mce_log() accesses
> > mcelog.next through the rcu_dereference_index_check() primitive,
> > shouldn't I do it the same way?
> 
> I don't claim to be an mce_log() expert, but when I looked it over,
> I didn't see a need for rcu_dereference_index_check().  Unless I am
> confused (quite possible), the memory barriers are sufficient.
> 
> The rcu_read_lock() and rcu_read_unlock() seem to be needed to avoid
> premature freeing, though.

Looka ere:

commit f56e8a0765cc4374e02f4e3a79e2427b5096b075
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Fri Mar 5 15:03:27 2010 -0800

    x86/mce: Fix RCU lockdep splats

    Create an rcu_dereference_check_mce() that checks for RCU-sched
    read side and mce_read_mutex being held on update side.  Replace
    uses of rcu_dereference() in arch/x86/kernel/cpu/mcheck/mce.c
    with this new macro.

...

+#define rcu_dereference_check_mce(p) \
+       rcu_dereference_check((p), \
+                             rcu_read_lock_sched_held() || \
+                             lockdep_is_held(&mce_read_mutex))
+

So I guess the check is to see that we're rather holding the
mce_chrdev_read_mutex when accessing this from userspace (the mcelog
userspace thing).

I can't comment on the RCU-sched thing because I don't know it that
well. It has to do with extended CPU idle times but why do we require to
be in RCU read-side critical section when accessing the index? Hmmm, I
think a guy called Paul should know :-) ...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
