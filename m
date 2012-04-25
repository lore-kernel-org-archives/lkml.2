Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2DYNcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:32:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42917 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2DYNcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:32:43 -0400
Date: Wed, 25 Apr 2012 14:32:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425133238.GG6871@ZenIV.linux.org.uk>
References: <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120425030659.GE6871@ZenIV.linux.org.uk>
 <20120425123746.GA15560@redhat.com>
 <20120425125042.GF6871@ZenIV.linux.org.uk>
 <20120425130329.GA16413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425130329.GA16413@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 03:03:29PM +0200, Oleg Nesterov wrote:
> Yes, and it sets TIF_SIGPENDING, but unless I missed something this doesn't
> matter.
> 
> > So no,
> > it might have been blocked prior to sigsuspend().
> 
> If it was not blocked, then the next do_signal()->get_signal_to_deliver()
> returns 0 and clears TIF_SIGPENDING. After that we finally re-enter
> sys_sigsuspend() and (assuming it unblocks this sig) notice this pending
> signal again and return -EINTR eventually.

Point...  Still, since we are talking about an arbitrary wide window (the
damn thing is waiting for signals to arrive, after all) this doesn't
sound good; sure, we might have been hit by SIGSTOP just before entering
that sigsuspend() with SIGCONT arriving only when the signal in question
had, ending up with handler running before sigsuspend(), but...  IMO it's
a QoI problem at the very least.

As for SA_RESTART/!SA_RESTART mixes, if SA_RESTART comes first we should
just take that restart and pretend that the second signal has arrived at
the very beginning of handler, I think.  Assuming I understood you correctly,
that is.
