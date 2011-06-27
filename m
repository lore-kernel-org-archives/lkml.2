Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab1F0KCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:02:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54584 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab1F0KBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:01:22 -0400
Date: Mon, 27 Jun 2011 15:31:05 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        galak@kernel.crashing.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
	lead to system crash/freeze
Message-ID: <20110627100104.GA24705@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com> <1308911347.531.56.camel@gandalf.stny.rr.com> <4E074671.7060100@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E074671.7060100@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 11:47:13PM +0900, Masami Hiramatsu wrote:
> (2011/06/24 19:29), Steven Rostedt wrote:
> > On Fri, 2011-06-24 at 17:21 +0800, Yong Zhang wrote:
> >> Hi,
> >>
> >> When I use kprobe to do something, I found some wired thing.
> >>
> >> When CONFIG_FUNCTION_TRACER is disabled:
> >> (gdb) disassemble do_fork
> >> Dump of assembler code for function do_fork:
> >>    0xc0037390 <+0>:	mflr    r0
> >>    0xc0037394 <+4>:	stwu    r1,-64(r1)
> >>    0xc0037398 <+8>:	mfcr    r12
> >>    0xc003739c <+12>:	stmw    r27,44(r1)
> >>
> >> Then I:
> >> modprobe kprobe_example func=do_fork offset=4
> >> ls
> >> Things works well.
> >>
> >> But when CONFIG_FUNCTION_TRACER is enabled:
> >> (gdb) disassemble do_fork
> >> Dump of assembler code for function do_fork:
> >>    0xc0040334 <+0>:	mflr    r0
> >>    0xc0040338 <+4>:	stw     r0,4(r1)
> >>    0xc004033c <+8>:	bl      0xc00109d4 <mcount>
> >>    0xc0040340 <+12>:	stwu    r1,-80(r1)
> >>    0xc0040344 <+16>:	mflr    r0
> >>    0xc0040348 <+20>:	stw     r0,84(r1)
> >>    0xc004034c <+24>:	mfcr    r12
> >> Then I:
> >> modprobe kprobe_example func=do_fork offset=12
> >> ls
> >> 'ls' will never retrun. system freeze.
> > 
> > I'm not sure if x86 had a similar issue.
> > 
> > Masami, have any ideas to why this happened?
> 
> No, I don't familiar with ppc implementation. I guess
> that single-step resume code failed to emulate the
> instruction, but it strongly depends on ppc arch.
> Maybe IBM people may know what happened.
> 
> Ananth, Jim, would you have any ideas?

On powerpc, we emulate sstep whenever possible. Only recently support to
emulate loads and stores got added. I don't have access to a powerpc box
today... but will try to recreate the problem ASAP and see what could be
happening in the presence of mcount.

Ananth
