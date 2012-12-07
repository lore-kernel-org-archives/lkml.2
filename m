Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2LGJWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:22:34 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.1.3]:48896 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637Ab2LGJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:22:29 -0500
Message-ID: <1354872138.3176.15.camel@computer5.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 09:22:18 +0000
In-Reply-To: <1354821581.17101.17.camel@gandalf.local.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 14:19 -0500, Steven Rostedt wrote:
> Hmm, your use of "may or may not" seems as you may not know this answer.
> I wonder if you can use the break point method as x86 does now, and
> remove the stop machine completely. Basically this is how it works:
> 
> add sw breakpoints to all locations to modify (the bp handler just does
> a nop over the instruction).
> 
> send an IPI to all CPUs to flush their icache.
> 
> Modify the non breakpoint part of the instruction with the new
> instruction.
> 
> send an IPI to all CPUs to flush their icache
> 
> Replace the breakpoint with the finished instruction.

If I understand correctly then this method can't work on ARM because a
'software breakpoint' is 'replace an instruction with a known undefined
instruction _of the same size_'. It haa to be the same size because code
like this:

	it eq       /* If condition code 'eq' true */
        insA        /* then execute this instruction */
        insB        /* Always execute this */

if we replace insA with a breakpoint which is shorter, then we have

	it eq       /* If condition code 'eq' true */
        bkpt        /* then execute the breakpoint */
        insA-part2  /* Always execute this garbage */
        insB        /* Always execute this */

and to complicate matters more, the 'it' instruction can make up to the
next four instructions conditional, so you can't reverse decode the
instruction stream reliably to even detect such code.

And further, it's implementation defined (up to who every creates the
silicon) whether an undefined instructions actually causes an abort when
it occurs in such an 'it' block, it may just execute as a nop.

Welcome to the work of ARM :-)

-- 
Tixy


