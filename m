Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0CZTJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:09:15 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:50381 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab0CZTJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/az4z94W/9jKgJfrPPRK4BzG9EILL4M9yLNU2SmAgB3O8ECnmStM+oea3GAJxmZrA
         DueYMZQF4c1FsLUUowVFK5F9/2yy5aJTzKjteYcK0iHeDik25RaqdAje8mXEP0yBRfOC
         EZEMPF5zBHoQtvezQ4Xxnot+bmHfNo+sQduM0=
Date: Fri, 26 Mar 2010 20:09:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/18] Allow different tracers to be compiled
	independently
Message-ID: <20100326190907.GJ5188@nowhere>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <20100323010419.GA8292@nowhere> <20100326002029.GH3145@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326002029.GH3145@quack.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 01:20:29AM +0100, Jan Kara wrote:
> On Tue 23-03-10 02:04:21, Frederic Weisbecker wrote:
> > On Tue, Mar 23, 2010 at 01:32:02AM +0100, Jan Kara wrote:
> > > 
> > >   Hi,
> > > 
> > >   currently, when one tracer is selected, most of tracepoints for other
> > > tracers also gets pulled into the kernel. So for example it's not possible
> > > to enable BLK_DEV_IO_TRACE without polluting slab allocation paths with
> > > tracepoint checks (see changelog of patch 01). This patch set adds a
> > > possibility for each set of trace points to be compile-enabled separately.
> > >   The first patch contains the necessary magic in linux/tracepoint.h. Other
> > > patches just tell tracing framework about correspoding config options
> > > and possibly introduce them if they did not exist before.
> > >   The patches in this patch set are actually completely independent so 
> > > they can be merged via respective subsystem trees. But changes are rather
> > > tiny so I don't expect much conflicts...
> > > 
> > > 								Honza
> > 
> > (Adding more people in Cc)
> > 
> > I don't know. Yeah this first looks like a good idea but once
> > CONFIG_EVENT_TRACING is enabled, each tracepoint is a lightweight
> > thing and induce a tiny overhead, probably hard to notice, and
> > this is going to be even more the case after the jmp label
> > optimization patches.
>   Sorry for replying late, I was on vacation. My motivation was that we
> wanted BLK_DEV_IO_TRACE enabled in all our distro kernels but there is
> a concern that this could have some impact on performance especially
> in SLAB allocator due to more icache pressure or so. This is not completely
> bogus concern if you look at bloat-o-meter output. For example:
> function                                     old     new   delta
> kmem_cache_alloc                             542     768    +226
> 
>   But looking at the disassembly now, I can see that the difference in
> inline code is actually only ~40 bytes (on x86_64) - so that's about 7%.
> Not a huge deal but still noticeable. 
> 
> > I liked the fact we had a general tracing kernel once the above
> > config is selected. And we don't bother telling people that to
> > use tool X you need CONFIG_EVENT_Y, and you need to rebuild your
> > kernel, etc...
>   OK, I understand this. I guess I should go and measure whether disabling
> tracepoints really makes some performance difference or not.



If you do so, please try with with the jmp label patches:
http://lwn.net/Articles/379776/

