Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0GNQmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:42:24 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35850 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0GNQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:42:22 -0400
Date: Wed, 14 Jul 2010 17:42:21 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
In-Reply-To: <20100714155804.252253097@efficios.com>
Message-ID: <alpine.LFD.2.00.1007141732200.11778@eddie.linux-mips.org>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Mathieu Desnoyers wrote:

> This patch makes all faults, traps and exception safe to be called from NMI
> context *except* single-stepping, which requires iret to restore the TF (trap
> flag) and jump to the return address in a single instruction. Sorry, no kprobes

 Watch out for the RF flag too, that is not set correctly by POPFD -- that 
may be important for faulting instructions that also have a hardware 
breakpoint set at their address.

> support in NMI handlers because of this limitation. This cannot be emulated
> with popf/lret, because lret would be single-stepped. It does not apply to
> "immediate values" because they do not use single-stepping. This code detects if
> the TF flag is set and uses the iret path for single-stepping, even if it
> reactivates NMIs prematurely.

 What about the VM flag for VM86 tasks?  It cannot be changed by POPFD 
either.

 How about only using the special return path when a nested exception is 
about to return to the NMI handler?  You'd avoid all the odd cases then 
that do not happen in the NMI context.

  Maciej
