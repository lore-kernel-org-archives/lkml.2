Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0IUS3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:29:37 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:42912 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab0IUS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:29:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKCVmExGGN6i/2dsb2JhbACiKXLEb4VBBA
Date: Tue, 21 Sep 2010 14:24:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921182431.GA30075@Krystal>
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com> <20100921131232.GA3024@one.firstfloor.org> <20100921143555.GA2873@redhat.com> <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org> <1285082049.23122.1930.camel@gandalf.stny.rr.com> <140ee1c060f22286fe2f4d81170f76be.squirrel@www.firstfloor.org> <1285092337.26872.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1285092337.26872.12.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:14:36 up 167 days,  4:05,  2 users,  load average: 0.08, 0.04,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-09-21 at 19:36 +0200, Andi Kleen wrote:
> > > On Tue, 2010-09-21 at 16:41 +0200, Andi Kleen wrote:
> > >> >
> > >> > So there are ~150 tracepoints, but this code is also being proposed
> > >> for
> > >> > use with 'dynamic debug' of which there are > 1000, and I'm hoping for
> > >> > more users moving forward.
> > >>
> > >> Even 1000 is fine to walk, but if it was sorted a binary search
> > >> would be much faster anyways. That is then you would still
> > >> need to search for each module, but that is a relatively small
> > >> number (< 100)
> > >
> > > xfs has > 100 tracepoints
> > 
> > Doesn
> 
> I suppose you were missing a 't'.
> 
> Anyway:
> 
>  $ find fs/xfs/ -name "*.c" ! -type d | xargs grep "[ ^I]trace_" | wc -l
>  313
> 
> The jump label occurs at the calling sight, not for defined tracepoints
> (which can be used in multiple places).
> 
> Also take a look at fs/xfs/linux-2.6/xfs_trace.h, you will be surprised.

Yep, I'd be surprised to see how many tracepoints we can end up having
with stuff like kmem tracing (trace_kmalloc). Each instance of the
inline function will generate an entry. (!)

> 
> 
> > >
> > >>
> > >> > Also, I think the hash table deals nicely with modules.
> > >>
> > >> Maybe but it's also a lot of code. And it seems to me
> > >> that it is optimizing the wrong thing. Simpler is nicer.
> > >
> > > I guess simplicity is in the eye of the beholder. I find hashes easier
> > > to deal with than binary searching sorted lists. Every time you add a
> > > tracepoint, you need to resort the list.
> > 
> > The only time you add one is when you load a module, right? When you do
> > that you only sort the section of the new module.
> 
> And on removing a module.
> 
> > 
> > > Hashes are much easier to deal with and scale nicely. I don't think
> > > there's enough rational to switch this to a binary list.
> > 
> > Well problem is that the code is very complicated today. I suspect
> > this could be done much simpler if it wasn't so overengin
> > 
> 
> Perhaps it can be cleaned up. But I have no issues with it now, and
> using a hash (basic data structures 101) is not where the complexity
> comes in.

I agree with Steven, Peter and Jason: due to the large amount of
tracepoints we can end up patching, we should keep the hash tables. This
code is very similar to what I have in the tracepoints already and in
the immediate values. So this code is solid and has been tested over a
large user base for quite some time already.

One change I would recommend is to use a separate memory pool to
allocate the struct jump_label_entry, to favor better locality. I did
not do it in tracepoints and markers because each entry have a variable
length, but given that struct jump_label_entry seems to be fixed-size,
then we should definitely go for a kmem_cache_alloc().

Thanks,

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
