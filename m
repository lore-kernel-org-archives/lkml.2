Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0LGOth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:49:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0LGOte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:49:34 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=WT7wE6qrmEcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=U1kxxBHnwcNocHNaNtcA:9 a=QhP0nCsKHsDvp8Ivk_wA:7 a=DVhHCrPIJU8SNHVSezbjvnGdskwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
From: Steven Rostedt <rostedt@goodmis.org>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <201012071712.12772.manningc2@actrix.gen.nz>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
	 <201012070003.42224.arnd@arndb.de>
	 <1291682864.16223.37.camel@gandalf.stny.rr.com>
	 <201012071712.12772.manningc2@actrix.gen.nz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 09:49:30 -0500
Message-ID: <1291733370.16223.242.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding Ted to Cc ]

On Tue, 2010-12-07 at 17:12 +1300, Charles Manning wrote:
> On Tuesday 07 December 2010 13:47:43 Steven Rostedt wrote:
> > On Tue, 2010-12-07 at 00:03 +0100, Arnd Bergmann wrote:
> > > > > > yaffs_trace(YAFFS_TRACE_BUFFERS,
> > > > > > 	"Out of temp buffers at line %d, other held by lines:",line_no);
> > > > > > for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > > > > 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
> > > > > > yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");
> > > > > >
> > > > > > Would that be OK?
> > > > > >
> > > > > > I am loath to have to pull out useful code then plug it back in
> > > > > > again.
> > > > >
> > > > > I don't think the yaffs_trace() function would be much better than
> > > > > the T() macro, I was talking more about the fact that you have your
> > > > > own nonstandard tracing infrastructure than the ugliness of the
> > > > > interface.
> > > > >
> > > > > The point of pulling it out now would be force you to rethink the
> > > > > tracing. If you think that you'd arrive at the same conclusion, just
> > > > > save the diff between the code with and without tracing so you can
> > > > > submit that patch again later.
> > > > >
> > > > > Having some sort of tracing is clearly useful, but it's also not
> > > > > essential for the basic yaffs2 operation. We want to keep a
> > > > > consistent way of presenting trace points across the kernel, so as
> > > > > long as you do it differently, your code is going to be viewed with
> > > > > some suspicion.
> > > > >
> > > > > Please have a look at how ext4, gfs2 and xfs do tracing.
> > > >
> > > > Looking in Linus' tree, all of those contain custom tracing of the form
> > > > I propose.
> > >
> > > Hmm, yes I guess that's right...
> > >
> > > I was specifically talking about the include/trace/* based trace events
> > > as something to look at, not the random printk based tracing stuff.
> > > Maybe Steven or Frederic can give some more insight on that.
> >
> > What are all those T() functions? Some look like they should be replaced
> > with printk(KERN_* "") functions, some others for tracing (I guess the
> > ones with YAFFS_TRACE_TRACING).
> 
> Yes those are very ugly. That is why I proposed changing them to 
> 
> yaffs_trace(bit, "format", args).
> 
> That gives printk tracing which I can select on the fly by enabling the 
> selected bits in the bitmask. eg. If I want to see the OS calls and the mtd 
> accesses then I enable YAFFS_TRACE_MTD and YAFFS_TRACE_OS and only those 
> grace groups get spat out.
> 
> People find this very handy, especially during system integration, so I am 
> loath to lose it. It is simple and it works.

Adding the TRACE_EVENT() code is also simple too ;)

With TRACE_EVENT() you will get the advantage of jump_lables (with newer
compilers). That is, there's no "if (bit & SOME_MASK) trace();" logic. A
nop is placed in the code and no compares are needed. When tracing is
enabled, the nop is changed to a jmp to the trace.

If you still use your own tracer, you could still use the internal
ring_buffer code.

> 
> Will it not be acceptable to just leave in the printk-style messages and 
> perhaps addTRACE_EVENT later?
> 
> >
> > ext4, gfs and xfs all have converted to the TRACE_EVENT() methods. When
> > you have this, you get tracing for free. The work with both ftrace and
> > perf. You can look at the samples/trace_events/ code for examples.
> >
> > Note, if you use TRACE_EVENT() and you want to debug even more, you can
> > simply add trace_printk() and that will also appear in your tracing
> > output.
> 
> From what I see, ext4 uses both trace_event and wrapped printk tracing, some 
> right alongside eachother so it is a duplication - not a replacement.
> 
> YAFFS has approx 500 trace lines in it. Some of those would make sense to 
> attach to TRACE_EVENT() , but most not. trace/events/ext4.h has 1172 lines 
> for around 28 events (== 40-odd lines per event).
> 
> Still reading everything I can find on this  (inc, your LWN articles) to get 
> an understanding of what capabilities these give me and what heuristic should 
> be used to define trace points vs printks.

Printks go to the console. You should not do that unless it is an error
that the admin should notice. There's also levels of printks that you
can do:

KERN_ERR, KERN_WARING, KERN_INFO, KERN_DEBUG, etc.

But again, these go to the users console and into the message logs. If
it is something that is a high activity this can slow down the system as
printk's are synchronous. That is, they don't continue work until they
finished writing. If you have a serial console, that could really slow
things down.

printk's should not be used for real debugging anyway. But putting it
into a tracepoint, then it opens up lots of options.

Your T(YAFFS_TRACE_ALWAYS, ...) look like good candidates for printks.

TRACE_EVENTS() are those that just want to analyze what is happening in
the system.

-- Steve
 

