Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2GPQCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:02:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2GPQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:02:30 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=IEFAe7w0650A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=S7-YJikAwGpXcs_Z--MA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342454547.5410.3.camel@gandalf.stny.rr.com>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 16 Jul 2012 12:02:27 -0400
In-Reply-To: <1342404140.7659.27.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 04:02 +0200, Mike Galbraith wrote:

> > Great, thanks!  I got stuck in bug land on Friday.  You mentioned
> > performance problems earlier on Saturday, did this improve performance?
> 
> Yeah, the read_trylock() seems to improve throughput.  That's not
> heavily tested, but it certainly looks like it does.  No idea why.

Ouch, you just turned the rt_read_lock() into a spin lock. If a higher
priority process preempted a lower priority process that holds the same
lock, it will deadlock.

I'm not sure why you would get a performance benefit from this, as the
mutex used is an adaptive one (failure to acquire the lock will only
sleep if preempted or if the owner is not running).

We should look at why this performs better (if it really does).

-- Steve

> 
> WRT performance, dbench isn't thrilled, but btrfs seems to work just
> fine for my routine usage, and spinning rust bucket is being all it can
> be.  I hope I don't have to care overly much about dbench's opinon.  It
> doesn't make happy multi-thread numbers with btrfs, but those numbers
> suddenly look great if you rebase relative to xfs -rt throughput :)
> 
> > One other question:
> > 
> > >  again:
> > > +#ifdef CONFIG_PREEMPT_RT_BASE
> > > +	while (atomic_read(&eb->blocking_readers))
> > > +		cpu_chill();
> > > +	while(!read_trylock(&eb->lock))
> > > +		cpu_chill();
> > > +	if (atomic_read(&eb->blocking_readers)) {
> > > +		read_unlock(&eb->lock);
> > > +		goto again;
> > > +	}
> > 
> > Why use read_trylock() in a loop instead of just trying to take the
> > lock?  Is this an RTism or are there other reasons?
> 
> First stab paranoia.  It worked, so I removed it.  It still worked but
> lost throughput, removed all my bits leaving only the lockdep bits, it
> still worked.
> 
> -Mike


