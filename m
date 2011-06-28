Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1F1KnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:43:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40251 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1F1Klo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:41:44 -0400
Date: Tue, 28 Jun 2011 16:11:28 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com, linuxppc-dev@lists.ozlabs.org,
        galak@kernel.crashing.org
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
	lead to system crash/freeze
Message-ID: <20110628104128.GA4310@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com> <1308911347.531.56.camel@gandalf.stny.rr.com> <4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627100104.GA24705@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 03:31:05PM +0530, Ananth N Mavinakayanahalli wrote:
> On Sun, Jun 26, 2011 at 11:47:13PM +0900, Masami Hiramatsu wrote:
> > (2011/06/24 19:29), Steven Rostedt wrote:
> > > On Fri, 2011-06-24 at 17:21 +0800, Yong Zhang wrote:
> > >> Hi,
> > >>
> > >> When I use kprobe to do something, I found some wired thing.
> > >>
> > >> When CONFIG_FUNCTION_TRACER is disabled:
> > >> (gdb) disassemble do_fork
> > >> Dump of assembler code for function do_fork:
> > >>    0xc0037390 <+0>:	mflr    r0
> > >>    0xc0037394 <+4>:	stwu    r1,-64(r1)
> > >>    0xc0037398 <+8>:	mfcr    r12
> > >>    0xc003739c <+12>:	stmw    r27,44(r1)
> > >>
> > >> Then I:
> > >> modprobe kprobe_example func=do_fork offset=4
> > >> ls
> > >> Things works well.
> > >>
> > >> But when CONFIG_FUNCTION_TRACER is enabled:
> > >> (gdb) disassemble do_fork
> > >> Dump of assembler code for function do_fork:
> > >>    0xc0040334 <+0>:	mflr    r0
> > >>    0xc0040338 <+4>:	stw     r0,4(r1)
> > >>    0xc004033c <+8>:	bl      0xc00109d4 <mcount>
> > >>    0xc0040340 <+12>:	stwu    r1,-80(r1)
> > >>    0xc0040344 <+16>:	mflr    r0
> > >>    0xc0040348 <+20>:	stw     r0,84(r1)
> > >>    0xc004034c <+24>:	mfcr    r12
> > >> Then I:
> > >> modprobe kprobe_example func=do_fork offset=12
> > >> ls
> > >> 'ls' will never retrun. system freeze.

My access to a 32bit powerpc box is very limited. Also, embedded powerpc
has had issues with gcc-4.6 while gcc-4.5 worked fine.

> > > I'm not sure if x86 had a similar issue.
> > > 
> > > Masami, have any ideas to why this happened?
> > 
> > No, I don't familiar with ppc implementation. I guess
> > that single-step resume code failed to emulate the
> > instruction, but it strongly depends on ppc arch.
> > Maybe IBM people may know what happened.
> > 
> > Ananth, Jim, would you have any ideas?
> 
> On powerpc, we emulate sstep whenever possible. Only recently support to
> emulate loads and stores got added. I don't have access to a powerpc box
> today... but will try to recreate the problem ASAP and see what could be
> happening in the presence of mcount.

I tried to recreate this problem on a 64-bit pSeries box without
success. Every one of the instructions in the stream at .do_fork are
emulated and work fine there -- no hangs/crashes with or without
function tracer.

Yong,
I am copying Kumar to see if he knows of any issues with 32-bit kprobes
(he wrote it) or with the function tracer, or with the toolchain itself.

You may want to check if, in the failure case, the instruction in
question is single-stepped or emulated (print out the value of
kprobe->ainsn.boostable in the post_handler) and see if you can find a
pattern to the failure.

Ananth
