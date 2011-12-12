Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1LLTyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:54:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1LLTyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:54:09 -0500
Date: Mon, 12 Dec 2011 14:53:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com
Subject: Re: [PATCH 2/2] watchdog: Softlockup has regular windows where it is
 not armed
Message-ID: <20111212195346.GT1669@redhat.com>
References: <20111124145315.5d0c4686@kryten>
 <20111124145441.13d715bb@kryten>
 <20111128214704.GH3084@redhat.com>
 <20111205212822.0eaf65a7@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205212822.0eaf65a7@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:28:22PM +1100, Anton Blanchard wrote:
> 
> Hi Don,
> 
> > > There might be a reason for this two stage sync but I haven't been
> > > able to find it yet. Perhaps the unsynced versions of cpu_clock()
> > > and sched_clock_tick() are not safe to call from all contexts?
> > 
> > According to commit 8c2238eaaf0f774ca0f8d9daad7a616429bbb7f1 that was
> > the case, cpu_clock wasn't NMI-safe.  Now it is, thanks to Peter.
> 
> Thanks, that makes sense now.
> 
> > I have a couple of concerns about the patch.  I am wondering about the
> > overhead of getting the timestamp more often now as opposed to just
> > setting a boolean for later.  It makes sense to stamp it at the time
> > of the call, don't know what the cost is.
> 
> I had a similar concern since we do execute this quite a lot. The
> overhead of cpu_clock is quite low on powerpc, but not sure about the
> other architectures.

It seems like half of the users of touch_softlockup_watchdog is a slow
path (ie they are purposely spinning a long time).  The cpu_clock overhead
for those paths, we probably don't need to care about.

The other half seems to deal with long idle/suspend/kgdb paths, which may
not be that interesting in their own right, except for the fact they are
called all the time for short delays and long delays. :-/

Perhaps I can move the touch_softlockup_watchdog() calls closer to the
long path conditionals, minimize the calls a little bit.

> 
> > I am also concern about how this affects suspend/resume and kgdb. I
> > cc'd Jason above for kgdb.  I'll have to run some tests locally to
> > see what long periods of delay look like.  Oh and virt guests too.
> > You don't have any test results from that setup do you?
> 
> I haven't tested suspend resume, kgdb or virtual guests yet.

I'll try to setup a box and play with these paths to see what they look
like.

Cheers,
Don
