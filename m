Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1J2Mm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 08:42:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51357 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab1J2MmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 08:42:24 -0400
Date: Sat, 29 Oct 2011 08:42:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Earl Chew <earl_chew@agilent.com>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a
 signal
Message-ID: <20111029124208.GA2296@neilslaptop.think-freely.org>
References: <1319591228-20397-1-git-send-email-msb@chromium.org>
 <20111028162631.294c1f8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028162631.294c1f8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 04:26:31PM -0700, Andrew Morton wrote:
> On Tue, 25 Oct 2011 18:07:08 -0700
> Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > To allow coredump pipe readers to look at /proc/<pid> of the crashing
> > process, the kernel waits for the reader to exit. However, the wait
> > is silently aborted if the crashing process is signalled.
> > 
> > This patch, logs whenever wait_for_dump_helpers is aborted or in order
> > to assist in debugging cases where /proc/<pid> is gone.
> 
> You don't really describe what problem you're observing.  What's the
> use case?  What are you trying to do?  etc.
> 
> Because if that is known, we can perhaps find better solutions.
> 
> > Alternatively, we may want to consider not aborting on a signal. You
> > could always break the loop by killing the reader process.
> 
> Well.  Neil's changelog for 61be228a06dc6e8662 is quite nice and tells
> us everything we could possibly want to know, except for why it tests
> sgnal_pending() :(
> 
> Neil, Oleg: can you remember?
> 
I _think_ it was a way to detect if the helper was still running, or had become
stuck.  I.e. we send the process a SIGIO, and if on the next iteration its still
pending, we can assume something has gone wrong, and abort the dump.  Of course
my memory could be faulty, Oleg do you have better recollection than I?

I'm heading out for a long weekend, but when I get back, I'll dig through the
archives for a better answer.  I recall Oleg and I talking at length about this
code.

> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -2030,7 +2030,14 @@ static void wait_for_dump_helpers(struct file *file)
> >  	pipe->readers++;
> >  	pipe->writers--;
> >  
> > -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> > +	while (pipe->readers > 1) {
> > +		if (signal_pending(current)) {
> > +			pr_info("wait_for_dump_helpers[%d]: "
> > +				"aborted due to signal\n",
> > +				task_pid_nr(current));
> > +			break;
> > +		}
> > +
> 
> argh, printk("i screwed up").  Hopefully we can find a better solution
> to whatever-your-problem is than this!
> 
