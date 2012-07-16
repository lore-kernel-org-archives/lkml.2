Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2GPRDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:03:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2GPRDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:03:41 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=M1TwID2Q0fYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=7RgU5aBSEs_yOgrXDLAA:9 a=QEXdDO2ut3YA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus
 rt_mutex deadlock report for absolutely free!
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1342456567.7659.97.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
	 <1342455968.7659.93.camel@marge.simpson.net>
	 <1342456567.7659.97.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 13:03:15 -0400
Message-ID: <1342458195.2783.5.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 18:36 +0200, Mike Galbraith wrote:
>  
> > > Ouch, you just turned the rt_read_lock() into a spin lock. If a higher
> > > priority process preempted a lower priority process that holds the same
> > > lock, it will deadlock.
> > 
> > Hm, how, it's doing cpu_chill()?
> 
> 'course PI is toast, so *poof*.  Since just enabling the lockdep bits
> seems to fix it up, maybe that's the patchlet to submit (less is more).

There's that too. But the issue I was talking about is with all trylock
loops. As holding an rt-mutex now disables migration, if a high priority
process preempts a task that holds the lock, and then the high prio task
starts spinning waiting for that lock to release, the lower priority
process will never get to run to release it. The cpu_chill() doesn't
help.

-- Steve


