Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab2DLOJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:09:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934163Ab2DLOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:09:03 -0400
Date: Thu, 12 Apr 2012 11:07:51 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
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
Message-ID: <20120412140751.GM16257@infradead.org>
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com>
 <20120411144918.GD16257@infradead.org>
 <20120411170343.GB29831@linux.vnet.ibm.com>
 <20120411181727.GK16257@infradead.org>
 <4F864BB3.3090405@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F864BB3.3090405@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 12, 2012 at 12:27:47PM +0900, Masami Hiramatsu escreveu:
> > * Arnaldo Carvalho de Melo <acme@infradead.org> [2012-04-11 11:49:18]:
> > Yeah, if one needs to disambiguate, sure, use these keywords, but for
> > things like:
> > 
> > $ perf probe /lib/libc.so.6 malloc
> > 
> > I think it is easy to figure out it is userspace. I.e. some regex would
> > figure it out.
> 
> That's interessting to me too. Maybe it is also useful syntax for
> module specifying too.
> 
> e.g.
>   perf probe -m kvm kvm_timer_fn
> 
> can be
> 
>   perf probe kvm.ko kvm_timer_fn
> 
> (.ko is required) or if unloaded
> 
>   perf probe /lib/modules/XXX/kernel/virt/kvm.ko kvm_timer_fn

	It may not even be required, since we can check in /proc/modules
if "kvm" is there and as well if it has a function named "kvm_timer_fn".

	Also probably there is no library or binary on the current
directory with such a name :-)

	Likewise, if we do:

 $ perf probe libc-2.12.so malloc

	It should just figure out it is the /lib64/libc-2.12.so

	Heck, even:

 $ perf probe libc malloc

	Makes it even easier to use.

	Its just when one asks for something that has ambiguities that
the tool should ask the user to be a bit more precise to remove such
ambiguity.

	After all...

[acme@sandy linux]$ locate libc-2.12.so
/home/acme/.debug/lib64/libc-2.12.so
/home/acme/.debug/lib64/libc-2.12.so/293f8b6f5e6cea240d1bb0b47ec269ee91f31673
/home/acme/.debug/lib64/libc-2.12.so/5a7fad9dfcbb67af098a258bc2a20137cc954424
/lib64/libc-2.12.so
/usr/lib/debug/lib64/libc-2.12.so.debug
[acme@sandy linux]$

	Only /lib64/libc-2.12.so is on the ld library path :-)

	And after people really start depending on this tool for day to
day use, they may do like me:

[root@sandy ~]# alias probe="perf probe"
[root@sandy ~]# probe -F | grep skb_queue
skb_queue_head
skb_queue_purge
skb_queue_tail
[root@sandy ~]#

	Which gets it to the shortest possible form:

	$ probe libc malloc

	:-)

	Git has this nice feature that is on the same line of making
things easier for the user:

[acme@sandy linux]$ git fack
git: 'fack' is not a git command. See 'git --help'.

Did you mean this?
	fsck
[acme@sandy linux]$

	Hell, yes, fsck is what I meant! :-)

- Arnaldo
