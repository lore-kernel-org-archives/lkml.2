Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1C2AKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:10:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47801 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1C2AKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:10:47 -0400
Date: Mon, 28 Mar 2011 17:10:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for March 25 (Call trace:
 RCU|workqueues|block|VFS|ext4 related?)
Message-ID: <20110329001040.GT2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110327050720.GA31424@linux.vnet.ibm.com>
 <AANLkTimpbGGcxNJUDMjdg1wijYhvXQ3KySvRYnEsUYsy@mail.gmail.com>
 <20110327213220.GE2322@linux.vnet.ibm.com>
 <AANLkTi=ti+PVC8N-3Bt2fzuHHQz6kuMdUPeb3Gudn7EU@mail.gmail.com>
 <20110328040823.GG2322@linux.vnet.ibm.com>
 <AANLkTinQiDSXLP1o-HfdedYOMKtnsbBrcOfuqw9sFf2X@mail.gmail.com>
 <20110328132436.GL2322@linux.vnet.ibm.com>
 <20110328151143.GA4859@linux.vnet.ibm.com>
 <AANLkTikcX75FaFDcDnYFxMtaE03w7-UbNaeL6h-VeRPo@mail.gmail.com>
 <AANLkTimtKP9ypNzf4ZpLK-CvGnqY+UigJaALHbFzUwg+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimtKP9ypNzf4ZpLK-CvGnqY+UigJaALHbFzUwg+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 06:46:48PM +0200, Sedat Dilek wrote:
> On Mon, Mar 28, 2011 at 6:38 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > On Mon, Mar 28, 2011 at 5:11 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> >> On Mon, Mar 28, 2011 at 06:24:36AM -0700, Paul E. McKenney wrote:
> >>> On Mon, Mar 28, 2011 at 02:33:36PM +0200, Sedat Dilek wrote:

[ . . . ]

> >>> > Ah, before I forget...
> >>> >
> >>> > I used TREE_RCU (was the default before noticing RCU issue) for
> >>> > finding the culprit commit.
> >>> > If it is from your POV more helpful to switch to PREEMPT + PREEMPT_RCU
> >>> > + RCU_BOOST, please let me *now* know.
> >>> > ( Both RCU setups freaks up the system. )
> >>>
> >>> If TREE_RCU hits problems faster, it is probably best to stay with
> >>> TREE_RCU.
> >>
> >> And of course, one exception to this advice is if TREE_RCU hangs so hard
> >> and fast that you don't have time to get any diagnostics.  If this is the
> >> case, then TREE_PREEMPT_RCU might be more productive.
> >>
> >
> > OK, that would somehow explain why I could not really get some debug
> > infos when doing "my stress-test" and checking via:
> >
> > $ LC_ALL=C tail -f /sys/kernel/debug/rcu/rcudata
> >
> > Then I remembered I saw a snippet for a RCU torture script mentionned
> > in the kernel-docs (see Documentation/RCU/torture.txt).
> >
> > 189 The following script may be used to torture RCU:
> > 190
> > 191         #!/bin/sh
> > 192
> > 193         modprobe rcutorture
> > 194         sleep 100
> > 195         rmmod rcutorture
> > 196         dmesg | grep torture:
> >
> > So, I recompiled a new TREE_RC-based kernel and build with
> > CONFIG_RCU_TORTURE_TEST=m.
> >
> > Unfortunately, the rmmod (I prefer modprobe -r -v) hangs... the
> > messages in the logs look promising.
> >
> > - Sedat -
> >
> 
> Wrong attachment, correct attached.

And one stupid problem located thus far.  I can make a (tortured) case
for it resulting in the symptoms you see, but it does seem unlikely to
happen repeatedly, as it would require a burst of CPU just at the wrong
time.  But who knows?

In any case, I am still looking.

							Thanx, Paul

------------------------------------------------------------------------

Fix stupid typo.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5477764..f311228 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1618,7 +1618,7 @@ static int rcu_node_kthread(void *arg)
 		rnp->wakemask = 0;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		rcu_initiate_boost(rnp);
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
 				continue;
 			preempt_disable();
