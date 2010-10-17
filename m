Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab0JQORd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab0JQORc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:17:32 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Eric Paris <eparis@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <1287323960.1998.360.camel@laptop>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
	 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
	 <1287323960.1998.360.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 10:16:23 -0400
Message-ID: <1287324983.2530.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 15:59 +0200, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 09:12 -0400, Eric Paris wrote:
> > We could split this into 2 structures, thus greatly shrinking the size
> > of the structure needed for the default/disabled case,
> 
> Well, it does suck it needs to bloat data and code when its effectively
> disabled. Isn't there a way to gather this data before we enable it, eg.
> scan the files list on enable or somesuch?

I'll think about it, but I think (without having looked) that it's
hard/impossible given an inode to backtrack to all of the files which
have it open.

If instead you attack the problem from the other side and start with all
of the files we'd need some kind of freezer to so we could get the
atomicity required.  We'd have to review every single file on the system
before we could be certain that the inode was correct.  Maybe I'm wrong
and someone else can help me see how to solve it this way....

> I mean, if you mandate an external storage you might as well extend
> struct inode, that's cheaper in each respect.

I personally think the cheapest would be to move the counters into the
inode and leave the rest of it, which would only ever exist for measured
inodes, in external storage.  On a 'CONFIG=Y but disabled by non-use'
your impact would be sruct inode grows by a long and when opening and
closing a struct file write perms a counter would be inc/dec....

> Me, I'm henceforth making sure to have CONFIG_IMA disabled...
> 
> >  but it doesn't
> > help the fact that the suggested structure for storage (the radix
> > tree) is apparently quite inefficient.  I'd love to hear other
> > suggestions for a better structure.... 
> 
> radix tree is efficient for dense sets, not sparse sets.

I didn't mean to imply that I thought radix trees were inefficient in an
of themselves and hope it didn't come across that way, I recognize that
IMA is apparently using the wrong data structure for the job.  Any
suggestions other than hand rolling a hashtable?  I know that SELinux
has some pretty generic hashtable code, maybe I should move it into
lib/ ?  Do any other subsystems have generic hashtable code?  Maybe this
is a time I'm forced to do some consolidation...

-Eric

