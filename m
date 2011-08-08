Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1HHPkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1HHPkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:40:46 -0400
Date: Mon, 8 Aug 2011 11:40:28 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: rostedt@goodmis.org, pjt@google.com, mingo@elte.hu, rth@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: Reduce the cycle count by changing the link
 order
Message-ID: <20110808154027.GA4336@redhat.com>
References: <20110805204040.GG2522@redhat.com>
 <1312582209.28695.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312582209.28695.51.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 12:10:09AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-05 at 16:40 -0400, Jason Baron wrote:
> > In the course of testing jump labels for use with the CFS bandwidth controller,
> > Paul Turner, discovered that using jump labels reduced the branch count and the
> > instruction count, but did not reduce the cycle count or wall time.
> > 
> > I noticed that having the jump_label.o included in the kernel but not used in
> > any way still caused this increase in cycle count and wall time. Thus, I moved
> > jump_label.o in the kernel/Makefile, thus changing the link order, and
> > presumably moving it out of hot icache areas. This brought down the cycle
> > count/time as expected.
> > 
> > In addition to Paul's testing,  I've tested the patch using a single
> > 'static_branch()' in the getppid() path, and basically running tight loops of
> > calls to getppid(). Here are my results for the branch disabled case:
> 
> Those numbers don't seem to be pre/post patch, but merely
> CONFIG_JUMP_LABEL=y/n so they don't tell us what the patch does.
> 

oops. I did record all that data, I just didn't include it :( So here it is:

jump label eanbled:

new makefile ordering:

  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     4,578,321,415 cycles                     ( +-   0.021% )
     3,969,511,833 instructions             #      0.867 IPC     ( +-   0.000% )
       751,633,846 branches                   ( +-   0.000% )

        1.717374497  seconds time elapsed   ( +-   0.021% )

old makefile ordering:

 Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     4,623,129,746 cycles                     ( +-   0.015% )
     3,969,600,140 instructions             #      0.859 IPC     ( +-   0.000% )
       751,648,318 branches                   ( +-   0.000% )

        1.734843587  seconds time elapsed   ( +-   0.028% )


jump label disabled:

new makefile ordering:

 Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     4,620,784,202 cycles                     ( +-   0.014% )
     4,009,564,429 instructions             #      0.868 IPC     ( +-   0.000% )
       771,654,211 branches                   ( +-   0.000% )

        1.733853839  seconds time elapsed   ( +-   0.031% )



old makefile ordering:

 Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     4,623,191,826 cycles                     ( +-   0.009% )
     4,009,561,402 instructions             #      0.867 IPC     ( +-   0.000% )
       771,655,250 branches                   ( +-   0.000% )

        1.734191186  seconds time elapsed   ( +-   0.009% )


So, with jump labels enabled we get instructions and branches to fall
even with the old Makefile ordering, but we don't get the corresponding
fall in cycles/wall time, without the new Makefile ordering. This
testing was done on a Kentsfield system.

> Anyway, should we put a comment in the Makefile telling us we should
> keep jump_label.o last?
> 

Yes, I think that would be a good idea. I can re-post with the complete
testing results and a Makefile comment, if we are ok with this change.


> Also, pjt mentioned on IRC that mucking about with link order is
> something google is not unfamiliar with.. could we use some sort of
> runtime feedback to generate linker layout maps or so? That seems like a
> more scalable version than randomly mucking about with Makefiles :-)

Agreed. Definitely a good area to research. However, until we have that done, I
think this patch makes sense.

Thanks,

-Jason
