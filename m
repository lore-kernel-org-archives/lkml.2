Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0EYXHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:07:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0EYXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K1ZA6vgkpma+LyUQszY8b/ZGAHzf3kcDJB+R1N8pgSDs5VMvv9n6Qtel4CrKjCX/4V
         D8oUiSAm3GCJ5WjnYf2iNKUJKAlhvkw5QiA/W7k/qM6eItM6vQFVSPKWAMo2cshGaP1I
         Kn0DEr1VoV7ZFZZ5SgozJt6sbnFEk9Fc9ZxcU=
Date: Wed, 26 May 2010 01:06:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: Tracing configuration review
Message-ID: <20100525230656.GD5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <20100525201259.GA5370@nowhere> <1274821799.9346.17.camel@cndougla-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274821799.9346.17.camel@cndougla-ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 05:09:59PM -0400, Chase Douglas wrote:
> On Tue, 2010-05-25 at 22:13 +0200, Frederic Weisbecker wrote:
> > On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:
> > > The following options are what I am looking to set for our x86
> > > configurations. I've only included those that I am not 100% sure of.
> > > Comments are what I could gather from documentation and Kconfig, but
> > > they may not be accurate:
> 
> <snip>
> 
> > > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> > 
> > 
> > We want to deprecate it in the long term, but for now we
> > don't have any replacement. Cool for RT latency tracing.
> 
> I thought that the functionality is the same as what you get by:
> 
> echo 1 > (debufs)/tracing/events/sched/enable



No, enabling every sched events will simply dump every events related
to the scheduler. It's then up to the user to make sense of these
traces through post-processing.

The wakeup tracer hooks the scheduler events for the specific
purpose of tracing the scheduler latencies: it measures the time
between a task is woken up and its actual scheduling to a cpu.
If you have the function tracer built, you'll also have a function
trace of everything that happened in-between.

So the wakeup tracer brings a kind of brain on top of the sched
events, but for very specific purposes.

 
> > > CONFIG_KSYM_TRACER=y (no performance impact by default)
> > 
> > 
> > IMO, it is deprecated. The perf interface is much more powerful and flexible.
> > Prasad, do you agree if I remove this ftrace plugin?
> 
> If there isn't any use in enabling it due to perf's features, then we
> can turn it off. However, if there's any use to be gained by this over
> perf's features, then I'd prefer to leave it on. Thoughts?



No, perf does much more:

- stacktraces recording
- "top" alike view with perf top
- stat with perf stat, etc...
- userspace memory accesses


Here is a quick example:

$ cat test.c
int var;

void func_c(void)
{
	var++;
}

void func_b(void)
{
	func_c();
}


void func_a(void)
{
	func_c();
}


int main(int argc, char **argv)
{
	int i;

	for (i = 0; i < 1000; i++)
		if (i % 2)
			func_a();
		else
			func_b();

	return 0;
}
//end test.c

$ gcc test.c -fno-omit-frame-pointer -o test

$ readelf -s test | grep var
    74: 000000000060102c     4 OBJECT  GLOBAL DEFAULT   25 var

$ perf record -g -c 1 -e mem:0x000000000060102c:w ./test
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.069 MB perf.data (~3020 samples) ]

$ perf report

# Events: 1K cycles
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
    99.90%     test  test               [.] func_c
               |
               --- func_c
                  |          
                  |--49.95%-- func_a
                  |          |          
                  |          |--99.60%-- main
                  |          |          __libc_start_main
                  |           --0.40%-- [...]
                  |          
                  |--49.85%-- func_b
                  |          main
                  |          |          
                  |          |--99.60%-- __libc_start_main
                  |           --0.40%-- [...]
                   --0.20%-- [...]


To sum up, there is nothing the ksym tracer does that perf can't.

Well, may be perf doesn't offer the time ordered view of memory
accesses, I must confess. Although this is still something we can
easily provide if people want it.



> > > CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)
> > 
> > 
> > In the way for deprecation.
> 
> Is this like the KMEM_TRACER where trace events have superseded it?


It's a bit more complicated. This is a tracer that is able to produce
statistics on top of workqueue events. You'll get the number of events
queued and executed per workqueues. This gives some clues about their
load. Past patches brought the ground to get the average/max time of
execution, the works that took most time to complete, etc... But
they didn't make it because they were growing too much the size
and complexity of the code while a post processing in userspace would
be better suited for that.

So the current version only displays the very basic informations
of the number of works queued and executed.

This is something we could replace with a script in perf tools
that analyse the workqueue events, but I'm not even sure it's
worth now that the new cmwq workqueues may come upstream.
The workqueue tracing code was there to analyse the latencies
induced by works that block, which wouldn't be a problem anymore
with cmwq.

So, what I think I'm going to do is to remove this workqueue
statistics code from the kernel and if people complain for
the loss, I'll write this script for perf as a replacement.

So you can expect CONFIG_WORKQUEUE_TRACER will be removed
for 2.6.36 or so.

