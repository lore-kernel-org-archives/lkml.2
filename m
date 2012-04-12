Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab2DLOt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:49:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39780 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab2DLOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:49:55 -0400
Date: Thu, 12 Apr 2012 20:11:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: Re: [PATCH] perf/probe: Provide perf interface for uprobes
Message-ID: <20120412144148.GA21587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com>
 <20120411144918.GD16257@infradead.org>
 <20120411170343.GB29831@linux.vnet.ibm.com>
 <20120411181727.GK16257@infradead.org>
 <4F864BB3.3090405@hitachi.com>
 <20120412140751.GM16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120412140751.GM16257@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041214-5518-0000-0000-0000039E3C47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> [2012-04-12 11:07:51]:

> Em Thu, Apr 12, 2012 at 12:27:47PM +0900, Masami Hiramatsu escreveu:
> > > * Arnaldo Carvalho de Melo <acme@infradead.org> [2012-04-11 11:49:18]:
> > > Yeah, if one needs to disambiguate, sure, use these keywords, but for
> > > things like:
> > > 
> > > $ perf probe /lib/libc.so.6 malloc
> > > 
> > > I think it is easy to figure out it is userspace. I.e. some regex would
> > > figure it out.
> > 
> > That's interessting to me too. Maybe it is also useful syntax for
> > module specifying too.
> > 
> > e.g.
> >   perf probe -m kvm kvm_timer_fn
> > 
> > can be
> > 
> >   perf probe kvm.ko kvm_timer_fn
> > 
> > (.ko is required) or if unloaded
> > 
> >   perf probe /lib/modules/XXX/kernel/virt/kvm.ko kvm_timer_fn
> 
> 	It may not even be required, since we can check in /proc/modules
> if "kvm" is there and as well if it has a function named "kvm_timer_fn".
> 
> 	Also probably there is no library or binary on the current
> directory with such a name :-)
> 

> 	Likewise, if we do:
> 
>  $ perf probe libc-2.12.so malloc
> 
> 	It should just figure out it is the /lib64/libc-2.12.so
> 
> 	Heck, even:
> 
>  $ perf probe libc malloc
> 
> 	Makes it even easier to use.
> 
> 	Its just when one asks for something that has ambiguities that
> the tool should ask the user to be a bit more precise to remove such
> ambiguity.
> 
> 	After all...
> 

I do understand/agree that the short form looks better. However each
user in the system might have different library /executable paths (and
different ordering of paths. The session in which perf is called may
find just one unique library or executable. But the used binary maynot
be the one that is being traced.

For example: I may have my perf in /home/srikar/bin/perf which may be
picked up. But when I use "perf probe perf cmd_probe" as a root user,
the root may only see /usr/bin/perf. It might look intuitive for us.
However it may not look so for ordinary users and system admins. 

The other choice would be to probe all executables/libraries by the give
name. Here also getting a exhaustive list is debatable.

So I think its okay for people to type a bit more than allow perf to guess
and make a wrong choice. After all we have bash history and tab
completion, command alias to lessen the typing.


> [acme@sandy linux]$ locate libc-2.12.so
> /home/acme/.debug/lib64/libc-2.12.so
> /home/acme/.debug/lib64/libc-2.12.so/293f8b6f5e6cea240d1bb0b47ec269ee91f31673
> /home/acme/.debug/lib64/libc-2.12.so/5a7fad9dfcbb67af098a258bc2a20137cc954424
> /lib64/libc-2.12.so
> /usr/lib/debug/lib64/libc-2.12.so.debug
> [acme@sandy linux]$
> 
> 	Only /lib64/libc-2.12.so is on the ld library path :-)
> 
> 	And after people really start depending on this tool for day to
> day use, they may do like me:

But what if the /lib/libc.so.6 is around on the same machine to cater for 32
bit apps and the user only wanted to trace 32 bit apps.

As you pointed out earlier, some user might have a text file by name
libc in the current directory which he inadvertently could have given
execute permissions. 

-- 
Thanks and Regards
Srikar

