Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab2GLRJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:09:52 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:36066 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934147Ab2GLRJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:09:49 -0400
X-ASG-Debug-ID: 1342112988-03d6a50cb617b820001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 12 Jul 2012 13:09:45 -0400
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
Message-ID: <20120712170945.GJ32174@shiny>
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
 <alpine.LFD.2.02.1207121253170.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207121253170.32033@ionos>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1342112988
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0350 1.0000 -1.7950
X-Barracuda-Spam-Score: -1.19
X-Barracuda-Spam-Status: No, SCORE=-1.19 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.102498
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 05:07:58AM -0600, Thomas Gleixner wrote:
> On Thu, 12 Jul 2012, Mike Galbraith wrote:
> > crash> struct rt_mutex 0xffff8801770601c8
> > struct rt_mutex {
> >   wait_lock = {
> >     raw_lock = {
> >       slock = 7966
> >     }
> >   }, 
> >   wait_list = {
> >     node_list = {
> >       next = 0xffff880175eedbe0, 
> >       prev = 0xffff880175eedbe0
> >     }, 
> >     rawlock = 0xffff880175eedbd8, 
> 
> Urgh. Here is something completely wrong. That should point to
> wait_lock, i.e. the rt_mutex itself, but that points into lala land.

This is probably the memcpy you found later this morning, right?

>  
> > Reproducer2: dbench -t 30 8
> > 
> > [  692.857164] 
> > [  692.857165] ============================================
> > [  692.863963] [ BUG: circular locking deadlock detected! ]
> > [  692.869264] Not tainted
> > [  692.871708] --------------------------------------------
> > [  692.877008] btrfs-delayed-m/1404 is deadlocking current task dbench/7937
> > [  692.877009] 
> > [  692.885183] 
> > [  692.885184] 1) dbench/7937 is trying to acquire this lock:
> > [  692.892149]  [ffff88014d6aea80] {&(&eb->lock)->lock}
> > [  692.897102] .. ->owner: ffff880175808501
> > [  692.901018] .. held by:   btrfs-delayed-m: 1404 [ffff880175808500, 120]
> > [  692.907657] 
> > [  692.907657] 2) btrfs-delayed-m/1404 is blocked on this lock:
> > [  692.914797]  [ffff88014bf58d60] {&(&eb->lock)->lock}
> > [  692.919751] .. ->owner: ffff880175186101
> > [  692.923672] .. held by:            dbench: 7937 [ffff880175186100, 120]
> > [  692.930309] 
> > [  692.930309] btrfs-delayed-m/1404's [blocked] stackdump:
> 
> Hrmm. Both locks are rw_locks and we prevent multiple readers for the
> known reasons in RT. No idea how to deal with that one :(

The reader/writer part in btrfs is just an optimization.  If we need
them to be all writer locks for RT purposes, that's not a problem.

But, before we go down that road, we do annotations trying
to make sure lockdep doesn't get confused about lock classes.  Basically
the tree is locked level by level.  So its safe to take eb->lock while
holding eb->lock as long as you follow the rules.

Are additional annotations required for RT?

-chris

