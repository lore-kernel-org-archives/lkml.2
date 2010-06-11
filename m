Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab0FKTuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0FKTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:50:01 -0400
Date: Fri, 11 Jun 2010 15:48:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Divyesh Shah <dpshah@google.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Message-ID: <20100611194849.GB20837@redhat.com>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
 <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
 <4C0F4872.7090909@fusionio.com>
 <20100611083249.GA11143@elte.hu>
 <4C11F661.3070604@fusionio.com>
 <20100611085520.GA20218@elte.hu>
 <4C11FF77.1000101@fusionio.com>
 <20100611190714.GA20837@redhat.com>
 <4C128A75.3030501@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C128A75.3030501@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:11:49PM +0200, Jens Axboe wrote:
> On 11/06/10 21.07, Vivek Goyal wrote:
> > On Fri, Jun 11, 2010 at 11:18:47AM +0200, Jens Axboe wrote:
> >> On 2010-06-11 10:55, Ingo Molnar wrote:
> >>>>> Caused by the same blkiocg_update_io_add_stats() function. Bootlog and config 
> >>>>> attached. Reproducible on that sha1 and with that config.
> >>>>
> >>>> I think I see it, the internal CFQ blkg groups are not properly
> >>>> initialized... Will send a patch shortly.
> >>>
> >>> Cool - can test it with a short turnaround, the bug is easy to reproduce.
> >>
> >> Here's a nasty patch that should fix it. Not optimal, since we really
> >> just want empty functions for these when cfq group scheduling is not
> >> defined.
> >>
> >> CC'ing the guilty parties to come up with a better patch that does NOT
> >> involve ifdefs in cfq-iosched.c. We want blk-cgroup.[ch] fixed up.
> >> And trimming the CC list a bit.
> > 
> > Jens, Ingo, I am sorry for this mess.
> > 
> > Jens,
> > 
> > How about introducing "block/cfq.h" and declaring additional set of wrapper
> > functions to update blkiocg stats and make these do nothing if
> > CFQ_GROUP_IOSCHED=n.
> > 
> > For example, in linux-2.6/block/cfq.h, we can define functions as follows.
> > 
> > #ifdef CONFIG_CFQ_GROUP_IOSCHED
> > cfq_blkiocg_update_dequeue_stats () {
> > 	blkiocg_update_dequeue_stats()
> > }
> > #else
> > cfq_blkiocg_update_dequeue_stats () {}
> > #endif
> > 
> > Fixing it blk-cgroup.[ch] might not be best as BLK_CGROUP is set.
> > Secondly, if there are other IO control policies later, they might
> > want to make use of BLK_CGROUP while cfq has disabled the group io 
> > scheduling.
> 
> I already tried such a patch, but it's not exactly pretty. How about
> splitting blk-cgroup.c into two parts, one that is built for
> BLK_CGROUP and an additional one that is also built for
> CFQ_GROUP_SCHED? Lets try and improve on the ifdef mess, not extend
> it.

Sorry, I did not understand your suggestion. Can you please throw some more
light on it.

blk-cgroup.c does not have any cfq specific parts. So I can't split it
out and build part of it based on CFQ_GROUP_SCHED.

Thanks
Vivek
