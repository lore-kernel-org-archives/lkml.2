Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1GYLJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:09:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab1GYLJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:09:00 -0400
Date: Mon, 25 Jul 2011 13:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725110809.GO28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725103817.GA21683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725103817.GA21683@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> > > So, since we already have the lguest tool in the kernel tree, 
> > > why cannot we have the much more capable tools/kvm/ in the 
> > > tree?
> > 
> > Lguest is in Documentation/ for a reason. It's not meant as a 
> > user space tool that you take as-is and use. It's meant for 
> > documenting how lguest works in general. I admit though, that 
> > that's also the reason people don't use it :).
> 
> I'd also say it's rather misplaced there, and at least in the 
> storage area that I know most it didn't help it from totally 
> misunderstanding kernel concepts and taking them into protocols 
> (e.g. virtio barrier support).  That for me is a reason why you 
> don't want to couple thing too tightly, at least you'll have to 
> document and/or explain the protocol to someone.

It's funny that you bring up ABIs and virtio, as in my experience 
it's usually this pattern that creates bad ABIs in Linux:

 1) there's an out of tree user-space project, written by a group of 
    developers, proposing some new feature for which they'd need 
    kernel help

 2) they talk to another set of Linux kernel developers, who come up 
    with something that works - still out of tree

 3) they then talk to upstream Linux and the whole review process 
    starts. The ABI changes in some minor ways but often survives.

 4) nobody is risking any ABI changes because the distance from 
    upstream to the actual user-space project is 3 boundaries. 
    Whatever ad-hoc ABI was proposed initially is hammered through
    if possible, unless it's 100% unworkable.

 5) upstream often bends for pragmatic reasons, and it's at most 
    someone at the top of the maintenance hierarchy who says
    'hell NO!' and forces an (expensive!) reiteration of all 5 steps.

I've also seen a couple of good ABIs, which had a very natural 
development cycle:

 1) developers working both upstream and in a user-space project 
    propose an ABI and quickly iterate through several versions. Both 
    the kernel side and the user-space side changes frequently and 
    iteratively to perfect the ABI and the whole process is highly 
    visible on lkml and gets review at every stage of this work.

Do you recognize what i'm trying to point out?

While moving a user-space tool project to tools/ certainly does not 
*guarantee* good ABIs, it *does* guarantee friction-less iterations 
of ABIs - which are much harder to achieve with out of tree projects.

We've done this numerous times for the perf ABI and while the ABI is 
far from perfect it worked very well for us - far better than it 
would have worked as a separate project.

In such an integrated tool/kernel tree bugs are also much easier to 
debug: as we can cleanly bisect across interim versions of the ABI, 
as the tools and the kernel side ABI is developed in lock-step. We do 
not have to create cross-compatibility between every interim version 
of the ABI and any future (or past) version of the tool ...

So yes, my first hand experience shows that you are 100% wrong:

 - 'slow-play', out of tree, modularized, to-the-specification ABIs 
   tend to suck

 - 'quickly iterated', in tree, unified, specified-on-lkml ABIs tend 
   to work out much better

There's exceptions, but that's the general trend.

Fact is that developing ABIs within an integrated project is 
*amazingly* powerful. You should try it one day, instead of 
criticizing it :-)

Thanks,

	Ingo
