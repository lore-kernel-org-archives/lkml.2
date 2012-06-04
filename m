Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2FDOYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab2FDOYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:24:08 -0400
Date: Mon, 4 Jun 2012 10:23:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rja@americas.sgi.com
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on
 multi-processor systems
Message-ID: <20120604142353.GI32472@redhat.com>
References: <20120524144229.GA27713@sgi.com>
 <20120529175352.GA31524@redhat.com>
 <20120529191935.GB29726@sgi.com>
 <20120529223923.GF32472@redhat.com>
 <20120529231135.GD4592@sgi.com>
 <20120529235407.GH32472@redhat.com>
 <20120601225603.GD24318@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601225603.GD24318@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 05:56:03PM -0500, Russ Anderson wrote:
> > I am curious, your NMI handler has locking wrapped around dump_stack,
> > shouldn't that serialize the output the way you want it?  Why isn't that
> > working?
> 
> Yes, you're right, it does.  It is working.  I'd forgotten that 
> the community kernel has uv_nmi_lock in uv_handle_nmi.  Must 
> be working too much with distro kernels.  :-)  But that doesn't
> help for all the other code paths than call dump_stack.

Sure, I agree.  But not every caller of dump_stack needs to dump for all
cpus.  I was just trying to avoid the ugly complicated code of
cmp_xchange you were requesting.

> 
> 
> > > FWIW, "Wait for up to 10 seconds for all CPUs to do the backtrace" on
> > > a 4096 cpu system isn't long enough.  :-)
> > 
> > Good point. :-)
> > 
> > > 
> > > > Whereas the lock you are proposing can be called in a mixture of NMI and
> > > > IRQ which could cause deadlocks I believe.
> > > 
> > > Since this is a lock just around the dump_stack printk, would 
> > > checking for forward progress and a timeout to catch any possible
> > > deadlock be sufficient?  In the unlikely case of a deadlock the
> > > lock gets broken and some of the cpu backtraces get intermixed.
> > > That is still a huge improvement over the current case where 
> > > all of the backtraces get intermixed.
> > 
> > I saw your new patch based on Frederick's input.  It seems to take care of
> > deadlock situations though you run into the starving lock problem that
> > ticketed spinlocks solved.  Which is why I am curious why moving the
> > locking one layer up to the NMI handler (which is where it is currently),
> > didn't fix your problem.
> 
> Locking in dump_stack would remove the need for uv_nmi_lock.

I agree.  I was just wondering if the added complexities were worth it for
the normal case.

If the uv_nmi_lock works, then I feel comfortable that your second patch
based on Frederic's suggestion will work too.  I just feel uncomfortable
with locking on a stack dump that should be reliable.  It is one thing to
do the locking in only NMI space or only IRQ space, but now we are
traversing both.  I don't think there will be any deadlocks (based on the
else path).

It could just be an overhyped paranoia of mine.  But that was my biggest
hestitation.

Cheers,
Don
