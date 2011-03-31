Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1CaOeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:34:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:63367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab1CaOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:34:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,275,1299484800"; 
   d="scan'208";a="727489584"
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <1301580117.4859.286.camel@twins>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>
	 <1301561155.14111.288.camel@minggr.sh.intel.com>
	 <1301580117.4859.286.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 22:34:16 +0800
Message-Id: <1301582056.2271.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 22:01 +0800, Peter Zijlstra wrote:
> On Thu, 2011-03-31 at 16:45 +0800, Lin Ming wrote:
> > I am considering if it is possible to do "instruction unwind" to get a
> > map from (temporarily used) register to a specific member of a data
> > structure pointed by a pointer.
> > 
> > 4004a0:         movq    -8(%rbp), %rax    /* load foo arg from stack
> > */
> > 4004a4:         movq    24(%rax), %rax    /* load foo->bar */
> > 4004a8:         movq    -16(%rbp), %rdx   /* load tmp arg from stack
> > */
> > 4004ac:         movl    32(%rdx), %edx    /* load tmp->blah */
> > 4004af:         movl    %edx, 20(%rax)    /* store bar->fubar */ 
> > 
> > foo: -8(%rbp)
> > tmp: -16(%rbp)
> > 
> > Assume we are now at ip 4004af, from the instruction decoder, we know
> > it's a store operation, and we want to find out what %rax is.
> > 
> > 1. unwind to 4004ac
> >    Ignore this, because it does not touch %rax
> > 
> > 2. unwind to 4004a8
> >    Ignore this, because it does not touch %rax
> > 
> > 3. unwind to 4004a4
> >    20(%rax) => 20(24(%rax)), continue to unwind because we still
> >    have no idea what %rax is
> > 
> > 4. unwind to 4004a0
> >    20(24(%rax)) => 20(24(-8(%rbp))), stop unwind, because we now know
> >    -8(%rbp) is foo.
> > 
> > So the original 20(%rax) is replace as 20(24(-8(%rbp))), and it means
> > foo->bar->fubar
> > 
> > Does this make sense? 
> 
> Yes and no, the problem is that you cannot unwind an x86 instruction
> stream. Therefore its easier to start at the beginning of a function
> where DWARF should be able to tell you everything you need and then do a
> single fwd scan to propagate the information until you reach the point
> of interest.

I'm afraid that fwd scan may not work, because of branch instruction.

void foo(struct foo *foo, struct tmp *tmp, int flag)
{ 
        if (flag)
                foo->bar->fubar = tmp->blah;   
        else    
                tmp->blah = foo->bar->fubar;
}

===>

void foo(struct foo *foo, struct tmp *tmp, int flag)
{
  400494:       55                      push   %rbp
  400495:       48 89 e5                mov    %rsp,%rbp
  400498:       48 89 7d f8             mov    %rdi,-0x8(%rbp)
  40049c:       48 89 75 f0             mov    %rsi,-0x10(%rbp)
  4004a0:       89 55 ec                mov    %edx,-0x14(%rbp)
        if (flag)
  4004a3:       83 7d ec 00             cmpl   $0x0,-0x14(%rbp)
  4004a7:       74 14                   je     4004bd <foo+0x29>
                foo->bar->fubar = tmp->blah;
  4004a9:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  4004ad:       48 8b 40 18             mov    0x18(%rax),%rax
  4004b1:       48 8b 55 f0             mov    -0x10(%rbp),%rdx
  4004b5:       8b 52 20                mov    0x20(%rdx),%edx
  4004b8:       89 50 14                mov    %edx,0x14(%rax)
  4004bb:       eb 12                   jmp    4004cf <foo+0x3b>
        else
                tmp->blah = foo->bar->fubar;
  4004bd:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  4004c1:       48 8b 40 18             mov    0x18(%rax),%rax
  4004c5:       8b 50 14                mov    0x14(%rax),%edx
  4004c8:       48 8b 45 f0             mov    -0x10(%rbp),%rax
  4004cc:       89 50 20                mov    %edx,0x20(%rax)
}
  4004cf:       c9                      leaveq
  4004d0:       c3                      retq

Assume we are at ip 4004c5, the fwd scan from the beginning of
function(400494) to 4004c5 will not get what we want about %rax.

Lin Ming

