Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2HMLfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:35:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37672 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2HMLfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:35:11 -0400
Message-ID: <1344857686.31459.25.camel@twins>
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Date: Mon, 13 Aug 2012 13:34:46 +0200
In-Reply-To: <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
	 <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 18:12 +0200, Sebastian Andrzej Siewior wrote:
> By setting an uprobe tracepoint, one learns whenever a certain point
> within a program is reached / passed. This is recorded and the
> application continues.
> This patch adds the ability to hold the program once this point has been
> passed and the user may attach to the program via ptrace.
> First, setup a global breakpoint which is very similar to a uprobe trace
> point:
> 
> |echo 'g /home/bigeasy/sample:0x0000044d %ip %ax' > uprobe_events
> 
> This is exactly what uprobe does except that it starts with the letter
> 'g' instead of 'p'.
> 
> Step two is to enable it:
> |echo 1 > events/uprobes/enable
> 
> Lets assume you execute ./sample and the breakpoint is hit. In ps you will
> see:
> |1938 pts/1    t+     0:00 ./sample

This seems particularly dangerous.. suppose you tag a frequent function
(say malloc) and the entire userspace freezes, including your shell.

> Now you can attach gdb via 'gdb -p 1938'. The gdb can now interact with
> the tracee and inspect its registers, its stack, single step, let it
> run…
> In case the process is not of great interest, the user may continue
> without gdb by writting its pid into the uprobe_gp_wakeup file
> 
> |echo 1938 > uprobe_gp_wakeup
> 
> What I miss right now is an interface to tell the user/gdb that there is a
> program that hit a global breakpoint and is waiting for further instructions.
> A "tail -f trace" does not work and may contain also a lot of other
> informations. I've been thinking about a poll()able file which returns pids of
> tasks which are put on hold. Other suggestions? 

I'm not really happy with any of this. I would suggest limiting this
stuff much further, like say only have it affect ptraced
processes/tasks. That way you cannot accidentally freeze the entire
system into oblivion.

GDB (and assorted stuff) can already track an entire process hierarchy
with fork follow stuffs.
