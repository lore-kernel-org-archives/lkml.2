Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1LMXP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:15:28 -0500
Received: from mail.openrapids.net ([64.15.138.104]:38719 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909Ab1LMXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:15:26 -0500
Date: Tue, 13 Dec 2011 18:15:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111213231523.GB19390@Krystal>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org> <1323812733-7520-2-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1112132336440.3020@ionos> <20111213225617.GC7633@tassilo.jf.intel.com> <1323817697.23971.5.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323817697.23971.5.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:11:12 up 385 days,  4:14,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-12-13 at 14:56 -0800, Andi Kleen wrote:
> >  
> > > > +struct debugfs_counter {
> > > > +	unsigned __percpu *ptr;
> > > > +	const char *fn;
> > > > +	const char *name;
> > > > +} __attribute__((aligned(sizeof(char *))));
> > > > +
> 
> > > 
> > > See commit 654986462 for details.
> > 
> > Doesn't give a lot of details actually. Which target?
> > 
> > Note that my structure only has pointers, so there is not a lot 
> > of potential for "evil" alignment.
> 
> We hit this with trace events as well, and your structure does have an
> evil alignment, it's 3 pointers, which is not a base 2 number. Thus,
> there were some compilers that liked to add padding to make the
> alignment a power of 2. That is, between two sections of files we ended
> up with something like:
> 
> 
> .section file1
> .ptra1
> .ptra2
> .ptra3
> .ptrb1
> .ptrb2
> .ptrb3
> .ptrc1
> .ptrc2
> .ptrc3
> .ptrd1
> .ptrd2
> .ptrd3
> .ptre1
> .ptre2
> .ptre3
> <space>
> .section file2
> .ptrf1
> .ptrf2
> .ptrf3
> [...]
> 
> 
> 
> It didn't happen often, heck, trace events and tracepoints were like
> this for sometime before this blew up in our faces.
> 
> From what I've seen is that 1 or 2 longs will pack nicely, but anything
> else (except for maybe 4, 8, 16, etc) will run a risk of crashing.

Yep. We changed our implementations to use an array of pointers to the
elements rather than creating a section of these elements per se to make
sure we would not trigger this problem anymore. Unless my memory fails
me, it started blowing up in our faces with new gcc versions. The thing
is that gcc is within its right to happily over-align those structures.
__attribute__((aligned())) is just a hint providing a minimum alignment
to respect, but the compiler can choose a higher alignment value as it
sees fit.

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
