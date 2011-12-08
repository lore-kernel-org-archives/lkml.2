Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1LHBv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:51:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57978 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754350Ab1LHBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:51:55 -0500
Date: Wed, 7 Dec 2011 20:51:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: [RFC] Latched NMI handler
Message-ID: <20111208015152.GA8337@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:44:02 up 379 days,  6:47,  8 users,  load average: 0.05, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Given the recent interest for latched NMI handler providing the ability
to fault and take exception within NMI handlers, I thought it would be
good if I wrote down the pseudo-code I got stucked in my brain since
this last discussion with Linus on the topic about a year ago. Feedback
is welcome, and hopefully it will be useful to Steven who is starting to
work a solution.

variables used:

stack-local int nmi_nest_count;
stack-local int nmi_latch;
__nmi_epilogue_begin (pointer to text)
__nmi_epilogue_end (pointer to text)
REAL_NMI_STACK: beginning of the stack used for real nmi handler
LATCHED_NMI_STACK: beginning of the stack used for latched nmi handler

int in_nmi_epilogue(void)
{
  return (instruction_pointer() >= __nmi_epilogue_begin
		&& instruction_pointer() < __nmi_epilogue_end);
}

int in_nmi(void)
{
  return nmi_nest_count > 0;
}

/* Use REAL_NMI_STACK */
real_nmi_handler: /* always running with nmis disabled */
  /*
   * We disable interrupts to ensure we don't have to deal with IRQs
   * when NMIs get re-enabled due to an iret from a fault/exception.
   */
  local_irq_disable();
  if (in_nmi_epilogue()) {
    nmi_latch = 0;
    /* set stack pointer to start of LATCHED_NMI_STACK */
    goto latched_nmi_handler;
  }
  if (in_nmi()) {
     nmi_latch = 1;
     iret
  }
  nmi_nest_count++;
  /* set stack pointer to start of LATCHED_NMI_STACK */
  goto latched_nmi_handler;


/* Use LATCHED_NMI_STACK */
latched_nmi_handler:	/* Can fault and reenable NMIs. */

  [ execute actual system NMI handler, including faults, int3, ... ]

  /*
   * note: test nmi_latch and iret instruction are within the
   * epilogue range to deal with latch test vs iret non-atomicity. If a
   * real nmi nests over this range, it clears the nmi_latch flag and
   * just restarts the latched nmi handler.  No
   * faults/exceptions/interrupts are permitted in this region, except
   * for the real NMI and MCEs (TODO).
   */
__nmi_epilogue_begin:
  /*
   * here we are restarting the latched nmi handler if an nmi happened
   * while nested within the nmi nest count.
   */
  if (nmi_latch) {
    nmi_latch = 0;
    goto latched_nmi_handler;
  }
  nmi_nest_count--;
  iret  /* restores interrupts */
__nmi_epilogue_end:

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
