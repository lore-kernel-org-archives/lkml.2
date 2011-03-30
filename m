Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab1C3Oqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:46:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34431 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1C3Oqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GU9i0yNF5S/hGitMsGYp63p9t3VrT5KCEsSKqvZn/pg2wmAQuJFTPZhy2xBEhSU7aH
         9eG0ef7YHzG9rKkgFmW2znmv7YkDfL2K3iuS+aunMiOxjUsAH3jXp3gG6PdzJW4io8Cq
         RAwW3bHTlZ4Qy6Rfy/MVbT02ElPXggn60Df0A=
Date: Wed, 30 Mar 2011 16:46:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, David Ahern <daahern@cisco.com>
Subject: Re: [PATCH -tip v3 0/6] perf: Introduce branch sub commands
Message-ID: <20110330144639.GA2204@nowhere>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:31:37PM +0900, Akihiro Nagai wrote:
> Hi,
> 
> This patch series provides the commands 'perf branch record' and 'perf branch trace'
> version 3. These commands record and analyze a BTS (Branch Trace Store) log.
> And, they provide the interface to use BTS log for application developers.
> 
> BTS is a facility of Intel x86 processors, which records the address of
> 'branch to/from' on every branch/jump instruction and interrupt.
> This facility is very useful for developers to test their software,
> for example, coverage test, execution path analysis, dynamic step count ...etc.
> These test tools have a big advantage, which user doesn't have to modify target
> executable binaries, because the BTS is a hardware feauture.
> 
> But, there are few applications using BTS. Reasons I guess are ...
>  - Few people know what BTS is.
>  - Few people know how to use BTS on Linux box.
>  - It's hard to analyze the BTS log because it includes just a series of addresses.
> 
> So, I want to provide a user-friendly interface to BTS for application developers.
> 
> 
>  About new sub commands
> ========================
> 'perf branch record' provides an easy way to record BTS log.
> Usage is 'perf branch record <command>'.  This command is just an alias to
> 'perf record -e branches:u -c 1 <command>'. But, new one is more simple and
> more intuitive.
> 
> 'perf branch trace' can parse and analyze recorded BTS log and print various
> information of execution path. This command can show address, pid, command name,
> function+offset, file path of elf.
> You can choose the printed information with option.
> 
> Example: 'perf branch trace'
> function+offset
> irq_return+0x0  => _start+0x0
> irq_return+0x0  => _start+0x0
> _start+0x3      => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x26
> irq_return+0x0  => _dl_start+0x2d

These results are a bit surprising. May be we can
jump once from irq_return to _start, in the first schedule()
of a new task perhaps, but thereafter I would expect
further jumps not to happen from irq_return, but rather
from _start. When we have x as a destination in line n, then
I would expect to have x as a source in n + 1.

Also we are supposed to only trace BTS in userspace, but
perhaps, if we are interrupted, after the execution of the iret instruction,
BTS considers the following jump "iret -> interrupted inst" as a branch
in userspace. After all it makes sense, it is a jump in userspace.

So BTS, because of the way it defines a jump inside userspace,
traces irq returns but not irq entries, that would explain the trace
you gave as an example.

I suspect we want to filter irq returns. ie: if the source comes
from the kernel, then filter it by default. And then we can later
think about an option to enable interrupt return tracing if
people want them.

Thanks.
