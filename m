Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2GMOrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:47:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:45439 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2GMOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:47:31 -0400
Date: Fri, 13 Jul 2012 16:47:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <chris.mason@fusionio.com>
cc: Mike Galbraith <efault@gmx.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <20120713125043.GH30128@shiny>
Message-ID: <alpine.LFD.2.02.1207131636110.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net> <20120713125043.GH30128@shiny>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, 13 Jul 2012, Chris Mason wrote:
> On Wed, Jul 11, 2012 at 11:47:40PM -0600, Mike Galbraith wrote:
> > Greetings,
> 
> [ deadlocks with btrfs and the recent RT kernels ]
> 
> I talked with Thomas about this and I think the problem is the
> single-reader nature of the RW rwlocks.  The lockdep report below
> mentions that btrfs is calling:
> 
> > [  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
> 
> In this case, the task has a number of blocking read locks on the btrfs buffers,
> and we're trying to turn them back into spinning read locks.  Even
> though btrfs is taking the read rwlock, it doesn't think of this as a new
> lock operation because we were blocking out new writers.
> 
> If the second task has taken the spinning read lock, it is going to
> prevent that clear_path_blocking operation from progressing, even though
> it would have worked on a non-RT kernel.
> 
> The solution should be to make the blocking read locks in btrfs honor the
> single-reader semantics.  This means not allowing more than one blocking
> reader and not allowing a spinning reader when there is a blocking
> reader.  Strictly speaking btrfs shouldn't need recursive readers on a
> single lock, so I wouldn't worry about that part.
> 
> There is also a chunk of code in btrfs_clear_path_blocking that makes
> sure to strictly honor top down locking order during the conversion.  It
> only does this when lockdep is enabled because in non-RT kernels we
> don't need to worry about it.  For RT we'll want to enable that as well.

thanks for explaining this. I really got lost in that code completely.
 
> I'll give this a shot later today.

Cool.

Aside of that I'm still pondering to experiment with a non-pi variant
of rw locks which allows multiple readers. For such cases as btrfs I
think they would be well suited and avoid the performance overhead of
the single writer restriction. But that's not going to happen before
my vacation, so we'll stick with your workaround for now and let Mike
beat the hell out of it.

Thanks,

	Thomas
