Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0ELRAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:00:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34804 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0ELRAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:00:24 -0400
Message-ID: <4BEADD94.6080501@zytor.com>
Date: Wed, 12 May 2010 09:55:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <1273611585.1810.132.camel@laptop> <20100512102518.GA30767@linux.vnet.ibm.com> <1273666385.1626.96.camel@laptop> <20100512132708.GC13606@in.ibm.com> <1273671560.1626.114.camel@laptop> <20100512140433.GD13606@in.ibm.com> <20100512144629.GA16343@Krystal>
In-Reply-To: <20100512144629.GA16343@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 07:46 AM, Mathieu Desnoyers wrote:
> 
> Now the tricky case is the sequence: instruction A -> int3 -> instruction B,
> because a core can only see "instruction A -> instruction B" without any
> core synchronization whatsoever, and may not see the int3. That's where the
> djprobes logic (with IPIs to all cores) comes into play. But as long as we stick
> to "insn A -> int3 -> insn A", things can be done very simply.
> 
> By the way, kprobes rely on the assumption that it is OK to put a breakpoint
> atomically and to put back the original instruction afterward.
> 

Keep in mind the following corner case, though:

insnA -> int3@A -> insnA
insnB -> int3@B -> insnB

It is now possible for the core to hit int3@A, without the int3@B being
there.  The int3 handler *has* to be able to handle any of the int3's
put in place, quite possibly out of order, until a core serialization is
performed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

