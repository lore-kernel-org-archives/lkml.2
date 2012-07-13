Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513Ab2GMKrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:47:49 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:37051 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030482Ab2GMKrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:47:45 -0400
X-ASG-Debug-ID: 1342176464-03d6a50cb618bee0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 13 Jul 2012 06:47:41 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mike Galbraith <efault@gmx.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
Message-ID: <20120713104741.GF30128@shiny>
X-ASG-Orig-Subj: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <1342072060.7338.102.camel@marge.simpson.net>
 <1342082648.7338.171.camel@marge.simpson.net>
 <1342086792.7707.9.camel@marge.simpson.net>
 <alpine.LFD.2.02.1207121310420.32033@ionos>
 <1342094233.7707.12.camel@marge.simpson.net>
 <alpine.LFD.2.02.1207121514240.32033@ionos>
 <1342161072.7380.65.camel@marge.simpson.net>
 <alpine.LFD.2.02.1207131142440.32033@ionos>
 <1342174485.7380.103.camel@marge.simpson.net>
 <alpine.LFD.2.02.1207131223240.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207131223240.32033@ionos>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1342176464
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0777 1.0000 -1.5278
X-Barracuda-Spam-Score: -0.93
X-Barracuda-Spam-Status: No, SCORE=-0.93 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.102568
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:26:26AM -0600, Thomas Gleixner wrote:
> On Fri, 13 Jul 2012, Mike Galbraith wrote:
> > On Fri, 2012-07-13 at 11:52 +0200, Thomas Gleixner wrote: 
> > > On Fri, 13 Jul 2012, Mike Galbraith wrote:
> > > > On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> > > > > Bingo, that makes it more likely that this is caused by copying w/o
> > > > > initializing the lock and then freeing the original structure.
> > > > > 
> > > > > A quick check for memcpy finds that __btrfs_close_devices() does a
> > > > > memcpy of btrfs_device structs w/o initializing the lock in the new
> > > > > copy, but I have no idea whether that's the place we are looking for.
> > > > 
> > > > Thanks a bunch Thomas.  I doubt I would have ever figured out that lala
> > > > land resulted from _copying_ a lock.  That's one I won't be forgetting
> > > > any time soon.  Box not only survived a few thousand xfstests 006 runs,
> > > > dbench seemed disinterested in deadlocking virgin 3.0-rt.
> > > 
> > > Cute. It think that the lock copying caused the deadlock problem as
> > > the list pointed to the wrong place, so we might have ended up with
> > > following down the wrong chain when walking the list as long as the
> > > original struct was not freed. That beast is freed under RCU so there
> > > could be a rcu read side critical section fiddling with the old lock
> > > and cause utter confusion.
> > 
> > Virgin 3.0-rt appears to really be solid.  But then it doesn't have
> > pesky rwlocks.
> 
> Ah. So 3.0 is not having those rwlock thingies. Bummer.
>  
> > > /me goes and writes a nastigram^W proper changelog
> > > 
> > > > btrfs still locks up in my enterprise kernel, so I suppose I had better
> > > > plug your fix into 3.4-rt and see what happens, and go beat hell out of
> > > > virgin 3.0-rt again to be sure box really really survives dbench.
> > > 
> > > A test against 3.4-rt sans enterprise mess might be nice as well.
> > 
> > Enterprise is 3.0-stable with um 555 btrfs patches (oh dear).
> > 
> > Virgin 3.4-rt and 3.2-rt deadlock gripe.  Enterprise doesn't gripe, but
> > deadlocks, so I have another adventure in my future even if I figure out
> > wth to do about rwlocks.
> 
> Hrmpf. /me goes to stare into fs/btrfs/ some more.

Please post the deadlocks here, I'll help ;)

-chris

