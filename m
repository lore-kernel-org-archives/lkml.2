Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1ITPqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:46:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42745 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498Ab1ITPqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:46:13 -0400
Date: Tue, 20 Sep 2011 11:46:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
	this_cpu_read/write()
Message-ID: <20110920154610.GB28952@Krystal>
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home> <1316487977.29966.32.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316487977.29966.32.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:36:39 up 300 days, 20:39,  7 users,  load average: 0.63, 0.35,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> [ Added Mathieu as I've been discussing this with him on IRC ]
[...]
> My suggestion is to nuke the __this_cpu*() functions and have them
> called this_cpu*(). And change the locations that allow for preemption
> enabled to be called preemptsafe_cpu_*() just like the irqsafe_cpu*()
> are used.
> 
> Thoughts?

I fully agreed with this proposal.

this_cpu_*() should be a sane default, which is cases that require
preemption to be disabled. Warning about use without preemption disabled
is important, because most users will _assume_ that they stay on the
same CPU across multiple calls.

preemptsafe_cpu_*() is an optimisation made for those who know that
they don't care about having consistent view of the variables across
multiple operations, e.g. statistics, or deal with this explicitly, like
SLUB. Typical use require either add_return or cmpxchg for validation.

In the past, we used to have something like raw_smp_processor_id()
though, for sites where racy use does not matter. So probably having a
raw_this_cpu_*() that behaves like "this_cpu_*()" proposed here, but
does not check for preemption disabled would also be useful.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
