Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1DAMvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:51:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50067 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1DAMvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IoTUG6fx7RAiMpvmHmqN13YgGFVixdqDFFLQRL1dIU8fUZpeMOZQvHNDUzq8XI2SyF
         Q3kkFIdtR3/sq/ejf8QfbW29ut2chorCYcWvUMbSZ10Q9jLiEV+bvgzruVKjaZxr1f3a
         ooWGFA88F0j/E1wyQyLA9+5hEPTvA8DU0otPY=
Date: Fri, 1 Apr 2011 14:51:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, David Ahern <daahern@cisco.com>
Subject: Re: [PATCH -tip v3 0/6] perf: Introduce branch sub commands
Message-ID: <20110401125129.GA2335@nowhere>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
 <20110330144639.GA2204@nowhere>
 <4D95AF81.5050306@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95AF81.5050306@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 07:57:05PM +0900, Akihiro Nagai wrote:
> (2011/03/30 23:46), Frederic Weisbecker wrote:
> <snip>
> >>'perf branch trace' can parse and analyze recorded BTS log and print various
> >>information of execution path. This command can show address, pid, command name,
> >>function+offset, file path of elf.
> >>You can choose the printed information with option.
> >>
> >>Example: 'perf branch trace'
> >>function+offset
> >>irq_return+0x0  =>  _start+0x0
> >>irq_return+0x0  =>  _start+0x0
> >>_start+0x3      =>  _dl_start+0x0
> >>irq_return+0x0  =>  _dl_start+0x0
> >>irq_return+0x0  =>  _dl_start+0x26
> >>irq_return+0x0  =>  _dl_start+0x2d
> >
> >These results are a bit surprising. May be we can
> >jump once from irq_return to _start, in the first schedule()
> >of a new task perhaps, but thereafter I would expect
> >further jumps not to happen from irq_return, but rather
> >from _start. When we have x as a destination in line n, then
> >I would expect to have x as a source in n + 1.
> Agree with the opinion "irq_start" surprising users.
> However, I think it is not a better solution that uses a
> previous destination as a next source.
> Because, users want to know what happen in userspace and,
> do not want to know interrupts from kernel.
> 
> I think the better solution is to implement the filter that
> eliminate the record including kernel functions from output.

Yep.

> For example, leading example will be filtered like this.
> 
> _start+0x3      =>  _dl_start+0x0
> 
> In the future, I think the solution is available that using BTS records
> with trace event like irq:irq_handler_entry to analyze interrupt.
> However, to do it, we need to fix perf.

Right.
 
> >
> >Also we are supposed to only trace BTS in userspace, but
> >perhaps, if we are interrupted, after the execution of the iret instruction,
> >BTS considers the following jump "iret ->  interrupted inst" as a branch
> >in userspace. After all it makes sense, it is a jump in userspace.
> >
> >So BTS, because of the way it defines a jump inside userspace,
> >traces irq returns but not irq entries, that would explain the trace
> >you gave as an example.
> >
> >I suspect we want to filter irq returns. ie: if the source comes
> >from the kernel, then filter it by default. And then we can later
> >think about an option to enable interrupt return tracing if
> >people want them.
> Agree.
> I will implement the option that enable/disable the filter.

Cool, thanks!
