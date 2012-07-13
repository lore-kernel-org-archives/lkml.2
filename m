Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2GMMzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:55:09 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:53563 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab2GMMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:55:07 -0400
X-ASG-Debug-ID: 1342183845-03d6a50cb618ccd0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 13 Jul 2012 08:50:43 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Mike Galbraith <efault@gmx.de>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Message-ID: <20120713125043.GH30128@shiny>
X-ASG-Orig-Subj: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Mike Galbraith <efault@gmx.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1342072060.7338.102.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342072060.7338.102.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1342183845
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0273 1.0000 -1.8440
X-Barracuda-Spam-Score: -1.24
X-Barracuda-Spam-Status: No, SCORE=-1.24 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.102578
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:47:40PM -0600, Mike Galbraith wrote:
> Greetings,

[ deadlocks with btrfs and the recent RT kernels ]

I talked with Thomas about this and I think the problem is the
single-reader nature of the RW rwlocks.  The lockdep report below
mentions that btrfs is calling:

> [  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70

In this case, the task has a number of blocking read locks on the btrfs buffers,
and we're trying to turn them back into spinning read locks.  Even
though btrfs is taking the read rwlock, it doesn't think of this as a new
lock operation because we were blocking out new writers.

If the second task has taken the spinning read lock, it is going to
prevent that clear_path_blocking operation from progressing, even though
it would have worked on a non-RT kernel.

The solution should be to make the blocking read locks in btrfs honor the
single-reader semantics.  This means not allowing more than one blocking
reader and not allowing a spinning reader when there is a blocking
reader.  Strictly speaking btrfs shouldn't need recursive readers on a
single lock, so I wouldn't worry about that part.

There is also a chunk of code in btrfs_clear_path_blocking that makes
sure to strictly honor top down locking order during the conversion.  It
only does this when lockdep is enabled because in non-RT kernels we
don't need to worry about it.  For RT we'll want to enable that as well.

I'll give this a shot later today.

-chris

