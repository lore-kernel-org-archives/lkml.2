Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0LGUny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:43:54 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:42228 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753208Ab0LGUnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:43:52 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Wed, 8 Dec 2010 09:43:48 +1300
User-Agent: KMail/1.9.10
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201012071712.12772.manningc2@actrix.gen.nz> <1291733370.16223.242.camel@gandalf.stny.rr.com>
In-Reply-To: <1291733370.16223.242.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201012080943.48938.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 December 2010 03:49:30 Steven Rostedt wrote:
> [ Adding Ted to Cc ]
>
> On Tue, 2010-12-07 at 17:12 +1300, Charles Manning wrote:
> > On Tuesday 07 December 2010 13:47:43 Steven Rostedt wrote:
> > > On Tue, 2010-12-07 at 00:03 +0100, Arnd Bergmann wrote:
> > > > > > > yaffs_trace(YAFFS_TRACE_BUFFERS,
> > > > > > > 	"Out of temp buffers at line %d, other held by
> > > > > > > lines:",line_no); for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > > > > > 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ",
> > > > > > > dev->temp_buffer[i].line); yaffs_trace(YAFFS_TRACE_BUFFERS,
> > > > > > > "\n");
> > > > > > >
> > > > > > > Would that be OK?
> > > > > > >
> > > > > > > I am loath to have to pull out useful code then plug it back in
> > > > > > > again.
> > > > > >
> > > > > > I don't think the yaffs_trace() function would be much better
> > > > > > than the T() macro, I was talking more about the fact that you
> > > > > > have your own nonstandard tracing infrastructure than the
> > > > > > ugliness of the interface.
> > > > > >
> > > > > > The point of pulling it out now would be force you to rethink the
> > > > > > tracing. If you think that you'd arrive at the same conclusion,
> > > > > > just save the diff between the code with and without tracing so
> > > > > > you can submit that patch again later.
> > > > > >
> > > > > > Having some sort of tracing is clearly useful, but it's also not
> > > > > > essential for the basic yaffs2 operation. We want to keep a
> > > > > > consistent way of presenting trace points across the kernel, so
> > > > > > as long as you do it differently, your code is going to be viewed
> > > > > > with some suspicion.
> > > > > >
> > > > > > Please have a look at how ext4, gfs2 and xfs do tracing.
> > > > >
> > > > > Looking in Linus' tree, all of those contain custom tracing of the
> > > > > form I propose.
> > > >
> > > > Hmm, yes I guess that's right...
> > > >
> > > > I was specifically talking about the include/trace/* based trace
> > > > events as something to look at, not the random printk based tracing
> > > > stuff. Maybe Steven or Frederic can give some more insight on that.
> > >
> > > What are all those T() functions? Some look like they should be
> > > replaced with printk(KERN_* "") functions, some others for tracing (I
> > > guess the ones with YAFFS_TRACE_TRACING).
> >
> > Yes those are very ugly. That is why I proposed changing them to
> >
> > yaffs_trace(bit, "format", args).
> >
> > That gives printk tracing which I can select on the fly by enabling the
> > selected bits in the bitmask. eg. If I want to see the OS calls and the
> > mtd accesses then I enable YAFFS_TRACE_MTD and YAFFS_TRACE_OS and only
> > those grace groups get spat out.
> >
> > People find this very handy, especially during system integration, so I
> > am loath to lose it. It is simple and it works.
>
> Adding the TRACE_EVENT() code is also simple too ;)

For 500 traces?

Please remember that yaffs is typically used in embedded systems - not big 
iron servers . Typical kernel sizes are between 1 and 3MB. Pretty much all 
the big iron features get turned off.

>From your LWN article it would seem that adding TRACE_EVENT() would podge up 
the kernel somewhat.

>
> With TRACE_EVENT() you will get the advantage of jump_lables (with newer
> compilers). That is, there's no "if (bit & SOME_MASK) trace();" logic. A
> nop is placed in the code and no compares are needed. When tracing is
> enabled, the nop is changed to a jmp to the trace.
>
> If you still use your own tracer, you could still use the internal
> ring_buffer code.
>
> > Will it not be acceptable to just leave in the printk-style messages and
> > perhaps addTRACE_EVENT later?
> >
> > > ext4, gfs and xfs all have converted to the TRACE_EVENT() methods. When
> > > you have this, you get tracing for free. The work with both ftrace and
> > > perf. You can look at the samples/trace_events/ code for examples.
> > >
> > > Note, if you use TRACE_EVENT() and you want to debug even more, you can
> > > simply add trace_printk() and that will also appear in your tracing
> > > output.
> >
> > From what I see, ext4 uses both trace_event and wrapped printk tracing,
> > some right alongside eachother so it is a duplication - not a
> > replacement.
> >
> > YAFFS has approx 500 trace lines in it. Some of those would make sense to
> > attach to TRACE_EVENT() , but most not. trace/events/ext4.h has 1172
> > lines for around 28 events (== 40-odd lines per event).
> >
> > Still reading everything I can find on this  (inc, your LWN articles) to
> > get an understanding of what capabilities these give me and what
> > heuristic should be used to define trace points vs printks.
>
> Printks go to the console. You should not do that unless it is an error
> that the admin should notice. 

Yaffs is used in embedded systems (eg. phones). There is no operator. The only 
people that ever look at dmesg and the log are engineers during 
integration/testing.

> There's also levels of printks that you 
> can do:
>
> KERN_ERR, KERN_WARING, KERN_INFO, KERN_DEBUG, etc.
>
> But again, these go to the users console and into the message logs.
> If 
> it is something that is a high activity this can slow down the system as
> printk's are synchronous. That is, they don't continue work until they
> finished writing. If you have a serial console, that could really slow
> things down.

That is exactly why I use the bitmasks to be able to be able to select sets of 
messages to be enabled. [btw: Enabling sets of traces seems to be a feature 
that TRACE_EVENT() lacks, or perhaps I have not read enough].

The trace mask allows you to set up a test case very easily and delivers the 
output where it is readily available.

>
> printk's should not be used for real debugging anyway. But putting it
> into a tracepoint, then it opens up lots of options.
>
> Your T(YAFFS_TRACE_ALWAYS, ...) look like good candidates for printks.
>
> TRACE_EVENTS() are those that just want to analyze what is happening in
> the system.

All, well almost all, embedded systems have printk. Many don't have TRACE.

People using yaffs do not want to lose what they already have and like the way 
tracing is set up.

What I propose is just rewriting the current trace mechanism so the code looks 
cleaner.

-- Charles






