Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0LFCmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:42:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43773 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0LFCmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uZP1+KBi/m7DC3rilN7IklNqyGWL/IJ9NT+368JrgtK7N9jcuwx9n0RapinnUA6nf5
         8zo9OhluWzoUvrwcd+E0DPa+UcvmPZCHWFpRgBZzfwXiWWbb/MNCqALA8RYJSUTNbWWh
         3ivjZq3zDjV0dCtPfGsU9c3fJt07+ADJvFd1s=
Date: Mon, 6 Dec 2010 03:42:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  6/7] perf bts trace: print function+offset
Message-ID: <20101206024244.GA2418@nowhere>
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6>
 <20101203040015.7827.38870.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203040015.7827.38870.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 01:00:15PM +0900, Akihiro Nagai wrote:
> Provide the function to print function+offset.
> And, set it as the default behavior of 'perf bts trace'.
> To use this function, users can also specify the option '-s' or '--symbol'.
> 
> Example: 'perf bts -as trace'
> This command prints address and function+offset.
> 
> Output sample:
> address            function+offset
> 0xffffffff8146fe0e irq_return+0x0         => 0x00007fd4038e3b20 _start+0x0
> ...
> 0x000000380661ee79 __libc_start_main+0xf9 => 0x00000000004035c3 main+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x00000000004035c3 main+0x0
> 0x00000000004035e8 main+0x25              => 0x000000000040bca0 set_program_name+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x000000000040bca0 set_program_name+0x0
> 0x000000000040bcae set_program_name+0xe   => 0x00000000004023d0 strrchr@plt+0x0
> 0x00000000004023d0 strrchr@plt+0x0        => 0x00000000004023d6 strrchr@plt+0x6
> ...
> 0x0000000000403e0c main+0x849             => 0x00000000004021f0 exit@plt+0x0
> 0x00000000004021f0 exit@plt+0x0           => 0x00000000004021f6 exit@plt+0x6
> 0x00000000004021fb exit@plt+0xb           => 0x00000000004020d0 _init+0x18
> 0x00000000004020d6 _init+0x1e             => 0x00000038062149d0 _dl_runtime_resolve+0x0
> ...

There is another kind of mode that I suspect would be very useful: something like
a userspace function graph tracer (you can have a look into the kernel function
graph tracer we have in ftrace to get an overview).

So, the idea would be to rebuild the whole function call flow:

main() {
	func1()
	func2() {
		func3()
	}
}


This would require to deref the instructions into the dso addresses from
the bts trace, keep only the "call" and the "ret" (there would be a small arch
backend for this mode) and rebuild the whole tree of calls.
We already have all the dso address mapping API in place with perf.

I really think this could be a very useful tool. Also we can even later
expand this to the branches, as Peter suggested. But starting with calls
would a very great start already.

Thanks.
