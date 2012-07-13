Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2GMJw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:52:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:43762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2GMJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:52:55 -0400
Date: Fri, 13 Jul 2012 11:52:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <1342161072.7380.65.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207131142440.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>  <1342082648.7338.171.camel@marge.simpson.net>  <1342086792.7707.9.camel@marge.simpson.net>  <alpine.LFD.2.02.1207121310420.32033@ionos>  <1342094233.7707.12.camel@marge.simpson.net> 
 <alpine.LFD.2.02.1207121514240.32033@ionos> <1342161072.7380.65.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Mike Galbraith wrote:
> On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> > Bingo, that makes it more likely that this is caused by copying w/o
> > initializing the lock and then freeing the original structure.
> > 
> > A quick check for memcpy finds that __btrfs_close_devices() does a
> > memcpy of btrfs_device structs w/o initializing the lock in the new
> > copy, but I have no idea whether that's the place we are looking for.
> 
> Thanks a bunch Thomas.  I doubt I would have ever figured out that lala
> land resulted from _copying_ a lock.  That's one I won't be forgetting
> any time soon.  Box not only survived a few thousand xfstests 006 runs,
> dbench seemed disinterested in deadlocking virgin 3.0-rt.

Cute. It think that the lock copying caused the deadlock problem as
the list pointed to the wrong place, so we might have ended up with
following down the wrong chain when walking the list as long as the
original struct was not freed. That beast is freed under RCU so there
could be a rcu read side critical section fiddling with the old lock
and cause utter confusion.

/me goes and writes a nastigram^W proper changelog

> btrfs still locks up in my enterprise kernel, so I suppose I had better
> plug your fix into 3.4-rt and see what happens, and go beat hell out of
> virgin 3.0-rt again to be sure box really really survives dbench.

A test against 3.4-rt sans enterprise mess might be nice as well.

Thanks,

	tglx
