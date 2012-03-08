Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2CHUKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:10:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2CHUKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:10:42 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OaAnv8gshtd9BMoxhDsA:9 a=KHQArOFeZWQghDc4s0gA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331237441.25686.469.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 15:10:41 -0500
In-Reply-To: <1331235579.11248.402.camel@twins>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 20:39 +0100, Peter Zijlstra wrote:

> > For example, we have:
> > 
> > @@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
> >         if (inode && !spin_trylock(&inode->i_lock)) {
> >  relock:
> >                 seq_spin_unlock(&dentry->d_lock);
> > -               cpu_relax();
> > +               cpu_chill();
> >                 return dentry; /* try again with same dentry */
> >         }
> > 
> > By doing the test at the trylock, we can easily hit the deadlock,
> > because we still hold dentry->d_lock. But by moving the block to the
> > cpu_chill(), then we are less likely to hit the deadlock.
> 
> Actually hitting the deadlock isn't a problem, and doing it in the place
> of the trylock has the distinct advantage that you can actually get the
> lock and continue like you want.

By doing a spin_trydeadlock() while still holding the d_lock, if the
holder of the i_lock was blocked on that d_lock then it would detect the
failure, and release the lock and continue the loop. This doesn't solve
anything. Just because we released the lock, we are still preempting the
holder of the d_lock, and if we are higher in priority, we will never
let the owner run.

That's why I recommended doing it after releasing the lock. Of course
the d_put() is so screwed up because it's not just two locks involved,
it's a reverse chain, where this probably wont help.

But just sleeping a tick sounds like a heuristic that may someday fail.

-- Steve


