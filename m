Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab1CaOC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:02:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:49711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab1CaOC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:02:26 -0400
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <1301561155.14111.288.camel@minggr.sh.intel.com>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>
	 <1301561155.14111.288.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 16:01:57 +0200
Message-ID: <1301580117.4859.286.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 16:45 +0800, Lin Ming wrote:
> I am considering if it is possible to do "instruction unwind" to get a
> map from (temporarily used) register to a specific member of a data
> structure pointed by a pointer.
> 
> 4004a0:         movq    -8(%rbp), %rax    /* load foo arg from stack
> */
> 4004a4:         movq    24(%rax), %rax    /* load foo->bar */
> 4004a8:         movq    -16(%rbp), %rdx   /* load tmp arg from stack
> */
> 4004ac:         movl    32(%rdx), %edx    /* load tmp->blah */
> 4004af:         movl    %edx, 20(%rax)    /* store bar->fubar */ 
> 
> foo: -8(%rbp)
> tmp: -16(%rbp)
> 
> Assume we are now at ip 4004af, from the instruction decoder, we know
> it's a store operation, and we want to find out what %rax is.
> 
> 1. unwind to 4004ac
>    Ignore this, because it does not touch %rax
> 
> 2. unwind to 4004a8
>    Ignore this, because it does not touch %rax
> 
> 3. unwind to 4004a4
>    20(%rax) => 20(24(%rax)), continue to unwind because we still
>    have no idea what %rax is
> 
> 4. unwind to 4004a0
>    20(24(%rax)) => 20(24(-8(%rbp))), stop unwind, because we now know
>    -8(%rbp) is foo.
> 
> So the original 20(%rax) is replace as 20(24(-8(%rbp))), and it means
> foo->bar->fubar
> 
> Does this make sense? 

Yes and no, the problem is that you cannot unwind an x86 instruction
stream. Therefore its easier to start at the beginning of a function
where DWARF should be able to tell you everything you need and then do a
single fwd scan to propagate the information until you reach the point
of interest.
