Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161225Ab2CORx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:53:56 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60199 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031933Ab2CORxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:53:52 -0400
Date: Thu, 15 Mar 2012 10:48:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Chris Boot <bootc@bootc.net>, linux1394-devel@lists.sourceforge.net,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        agrover@redhat.com, clemens@ladisch.de, nab@linux-iscsi.org
Subject: Re: [PATCH v2 08/11] firewire-sbp-target: Add sbp_login.{c,h}
Message-ID: <20120315174837.GH2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-9-git-send-email-bootc@bootc.net>
 <20120215220052.040e680a@stein>
 <4F3CE6A1.9050602@bootc.net>
 <20120303183722.04cdbfee@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303183722.04cdbfee@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031517-8974-0000-0000-00000748B2DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 06:37:22PM +0100, Stefan Richter wrote:
> On Feb 16 Chris Boot wrote:

[ . . . ]

> > I guess I need to protect access to 
> > the entire session really. Possibly even rwlocks due to only the 
> > management processes ever changing anything, but lots of reads during 
> > command handling.
> 
> The use case for rwlocks is not really the case where infrequent write
> access meets frequent read access.  Rather, the use case is when it is
> important to reduce or prevent contention between readers.
> 
> Rwlocks come with their own downsides though.  I guess the somewhat
> costlier lock implementation could counter the benefit of allowing
> concurrent readers.  Or maybe latency spikes around a write access could be
> an issue.
> 
> I believe I have read somewhere that one should rather use a simple
> spinlock unless exhaustive tests prove that an rwlock really performs
> better.  Furthermore, in many if not all use cases of rwlocks, RCU is
> available as another alternative.  RCU comes with its own set of downsides
> though, for example not being as well and widely understood by programmers
> compared to locking, being less easy to debug (may have improved
> recently), and posing some challenges to RT-PREEMPT kernels.

The preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
handle the -rt tree.

> AFAIU the above considerations cannot be applied 100 % to able-to-sleep
> reader-writer locks, i.e. the kernel's rwsem.  Still, the use case of an
> rwsem (in contrast to a mutex) is not particularly where a datum is rarely
> written and often read, but where it is desirable to let multiple readers
> not block each other.
> 
> [Somebody correct me where I'm wrong.]

And you can use SRCU if readers need to block.

That said, even I agree that RCU is not always the right tool for the job.

							;-), Paul

> PS, I cloned your git tree not long ago, but again various distractions
> kept me from having a broader look at your code...
> -- 
> Stefan Richter
> -=====-===-- --== ---==
> http://arcgraph.de/sr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

