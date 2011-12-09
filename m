Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1LISUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:20:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1LISUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:20:24 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=zd2uoN0lAAAA:8 a=ZsL9fK4uVhyBSa2Z7w8A:9 a=IZXVeQmIhXTBA4iEO9cA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <20111209174911.GD14900@aftab>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org> <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo> <1323448478.1937.26.camel@frodo>
	 <1323451171.1937.33.camel@frodo>  <20111209174911.GD14900@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 13:20:20 -0500
Message-ID: <1323454820.1937.39.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 18:49 +0100, Borislav Petkov wrote:
> Hey Steve,
> 
> On Fri, Dec 09, 2011 at 12:19:31PM -0500, Steven Rostedt wrote:
> > Could you shed some light on this. Can an NMI interrupt an MCE in
> > progress?
> 
> Easy, http://support.amd.com/us/Processor_TechDocs/APM_V2_24593.pdf,
> section 8.5.
> 
> On amd64 #MC is along with processor reset the highest prio. Judging
> from the text, an NMI occurring during an #MC is held until we return
> from the #MC handler:
> 
> "When simultaneous interrupts occur, the processor transfers control
> to the highest-priority interrupt handler. Lower-priority interrupts
> from external sources are held pending by the processor, and they are
> handled after the higher-priority interrupt is handled. Lower-priority
> interrupts that result from internal sources are discarded. Those
> interrupts reoccur when the high-priority interrupt handler completes
> and transfers control back to the interrupted instruction."

Yeah, I read that too. It's just a little confusing because how the SMI
section talks about disabling NMIs, but nothing else does. And according
to that same table, SMIs are higher priority. So why mention that it
disables NMIs?

Ah, looking at that section again, I see:

"SMM is entered using the system-management interrupt (SMI).
SMI is an external non-maskable interrupt that operates
differently from and independently of other interrupts. SMI has
priority over all other external interrupts, including NMI (see
“Priorities” on page 269 for a list of the interrupt priorities)."

That 'See "Priorities" on page 269' help verify that this is indeed the
case.

Thanks!

-- Steve


