Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937549Ab0CPIQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:16:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936515Ab0CPIQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:16:33 -0400
Date: Tue, 16 Mar 2010 09:16:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100316081623.GF18448@elte.hu>
References: <4B990496.4020002@kernel.org>
 <4B9F08AC.9030904@kernel.org>
 <20100316061718.GA22651@elte.hu>
 <b6fcc0a1003160014h79098b50t87a448285350b3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a1003160014h79098b50t87a448285350b3e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Mar 16, 2010 at 8:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Also, why should we make this opt-in and expose a wide range of configs to
> > build breakages?
> 
> Because we want to #include less, not the same amount.
> 
> > A more gradual approach would be to write a simple script
> > that adds a slab.h include to all .c's that include percpu.h, directly or
> > indirectly.
> 
> As a defensive measure, one can explicitly add slab.h to every file which 
> uses kmalloc/kfree.
> 
> But, who cares, since one still has to compile test regardless.

Firstly, generating #include slab.h lines in .c files based on actual API 
usage is _good_, pretty much unconditionally so. See my previous mail for the 
list of advantages. Even if it increases the number of #include lines 
temporarily.

Secondly, the point in scripting is to intentionally over-shoot the target, as 
compile testing (especially if it's only modconfig), will only cover so much 
and _if we can_ we should avoid breakage.

That way the over-shooting will cover cases you are not able (or did not 
happen to) build-test. It's much better to have temporarily more include lines 
than have fewer and break the build. We'll need a #include line reduction 
mechanism in any case as APIs frequently get unused and #include lines get 
amassed in .c files.

Thirdly, as for build testing only, see for example a sched.h include file 
cleanup _you_ did in the past, which, despite your build testing, broke quite 
some code:

 commit 86ae13b006e48959981248493efd3ff4b2828b3d
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Mon Oct 12 16:22:46 2009 +0200

    headers: Fix build after <linux/sched.h> removal
    
    Commit d43c36dc6b357fa1806800f18aa30123c747a6d1 ("headers: remove
    sched.h from interrupt.h") left some build errors in some configurations
    due to drivers having depended on getting header files "accidentally".
    

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    [ Combined several one-liners from Ingo into one single patch  - Linus ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

 drivers/char/genrtc.c        |    1 +
 drivers/char/rtc.c           |    1 +
 drivers/char/sonypi.c        |    1 +
 drivers/net/wan/c101.c       |    1 +
 drivers/net/wan/n2.c         |    1 +
 drivers/net/wan/pci200syn.c  |    1 +
 drivers/pci/hotplug/cpqphp.h |    1 +
 7 files changed, 7 insertions(+), 0 deletions(-)

I dont mind the occasional breakage, but avoidable bugs spread out in the tree 
can be a real PITA to testers.

I remember it, that imperfect conversion kept me busy chasing trivial build 
bugs for most of the day, because they would pop up with different config 
dependencies so they had to be addressed separately. (so i created 7 separate 
fixes as the day progressed - and that in a busy period of the cycle so i 
certainly didnt have a day to waste voluntarily)

Note that that d43c36dc patch of yours wasnt in linux-next IIRC, so you didnt 
even get basic build coverage. I have no problem with fixing more difficult 
bugs or with fixing the occasional silly oversight (that's the _point_ of 
developing the kernel after all), but i have a problem with reasonably 
avoidable bugs.

Thanks,

	Ingo
