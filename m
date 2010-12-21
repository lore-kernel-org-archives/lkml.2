Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab0LURgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:36:45 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:56481 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0LURgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aUBRM5EeEATI8+vMEeaiwTneYNTGNjD/oosQF71xhmp/gInSL9u/TEpp7fsh+ox3dl
         faCBWrpB+2pxoYhgPGVL0deKKPNoRu6UVKoLA3xuIz5f44FYwdL1wGswSle93vwWkekW
         FxUDsVHJtM2n9LMXSoPeMxiywPYBavXrt2VsA=
Date: Tue, 21 Dec 2010 18:36:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "akihiro.nagai.hw@hitachi.com"@sdl.hitachi.co.jp,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v2 0/6] perf: Introduce bts sub commands
Message-ID: <20101221173637.GN1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:05:27PM +0900, Akihiro Nagai wrote:
> Hi,
> 
> This patch series provides the commands 'perf bts record' and 'perf bts trace'
> version 2. These commands can record and analyze BTS (Branch Trace Store) log.
> And, provide the interface to use BTS log for application developers.
> 
> BTS is a facility of Intel x86 processors, which can record the address of
> 'branch to/from' on every branch/jump instruction and interrupt.
> This facility is very useful for developers to test their software.
> For example, coverage test, execution path analysis, dynamic step count ...etc.
> Also, those tools can have a very big advantage that they don't require any
> changes of the target executable binaries.
> 
> But, there are few applications using BTS. Reasons I guess are ...
>  - Few people know what BTS is.
>  - Few people know how to use BTS on Linux box.
>  - It's hard to analyze the BTS log because it includes just a series of addresses.

And I would add:

- It has a big overhead, probably because the CPU spends some time to record
the branches, but also because it generates a huge amount of traces to save
periodically.

- It seems it's only available on intel CPUs (and some of them)

- It can't do branch type filtering like LBR does on some intel CPUs.
  Like recording only call and ret branches and ignore jmp, je, etc...
  which would make lower overhead if our goal is to trace only the function
  graph for example.

OTOH it has a great potential.

> 
> So, I want to provide a user-friendly interface to BTS for application developers.
> 
> 
>  About new sub commands
> ========================
> 'perf bts record' provides the easy way to record bts log.

I would suggest to call it perf branch. Bts beeing only an
underlying backend feature that makes it working. An implementation
detail. For example, the function graph traces may join in the
future to provide some branch details of the kernel, only in
the function level of course.

> Usage is 'perf bts record <command>'.  This command is just an alias to
> 'perf record -e branches:u -c 1 <command>'. But, new one is more simple and
> more intuitive.
> 
> 'perf bts trace' can parse and analyze recorded bts log and print various
> information of execution path. This command can show address, pid, command name,
> function+offset, file path of elf.
> You can choose the printed information with option.
> 
> Example: 'perf bts trace'
> function+offset
> irq_return+0x0  => _start+0x0
> irq_return+0x0  => _start+0x0
> _start+0x3      => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x26
> irq_return+0x0  => _dl_start+0x2d
> _dl_start+0x71  => _dl_start+0x93
> _dl_start+0x97  => _dl_start+0x78
> ...
> 
> This is the default behavior of 'perf bts trace'. It prints function+offset.

That's a good start!

I suspect in the future, the default should be a function graph layout
and only dive into in-proc branch details if requested by means of
options.

But may be I'm biaised and in practice we need to output the branches
right away. That said I suspect a function graph should give the first desired
overview.

This can probably be done incrementally though, this output is already a
nice feature.


> Example2: 'perf bts -cas trace'
> command address            function+offset                  
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806200b20 _start+0x0
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806200b20 _start+0x0
> ls      0x0000003806200b23 _start+0x3      => ls   0x0000003806204910 _dl_start+0x0
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806204910 _dl_start+0x0
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806204936 _dl_start+0x26
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x000000380620493d _dl_start+0x2d
> ls      0x0000003806204981 _dl_start+0x71  => ls   0x00000038062049a3 _dl_start+0x93
> ls      0x00000038062049a7 _dl_start+0x97  => ls   0x0000003806204988 _dl_start+0x78

Cool!

> ...
> 
> In the future, I'd like to make this more informative. For example
>  - Show source file path
>  - Show line number
>  - Show inlined function name
>  - Draw call graph
>  - Browse source code and coloring
>  - Make bts record fast
> and more!

Very nice plans.

Thanks!
