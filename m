Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1LIPAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:00:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1LIPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:00:31 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=lWGEjhAU5bKHkncPFsAA:9 a=7Kq-5wNRwYH6YWvhsVoA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1323422521.17673.47.camel@twins>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>  <1323422521.17673.47.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 10:00:28 -0500
Message-ID: <1323442828.1937.17.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 10:22 +0100, Peter Zijlstra wrote:

> Its was definitely tongue in cheek, also I did say this'll be a massive
> pain with paravirt since I doubt paravirt calls are NMI safe. 

But does paravirt simulate NMIs? Does a guest ever take an NMI? I can
enable paravirt to see if it breaks.

> 
> But yeah, it might all be slightly less painful than trying to teach the
> INT3 handler about this recursion.

That's my goal. Yes, I agree this is all just an ugly hack, but I'm
trying hard to keep the ugly hack contained in the NMI handling. Once
you start letting this hack spread, it will grow like a virus, and
resistance will be futile. And we will end up with nasty dependencies
that will become a horror show to maintain.

Right now, I've quarantined the NMI code, and I'm keeping the infection
at bay. The NMI code will grow warts and nasty appendages, but the NMI
code was ugly to begin with, and maybe these mutations might even make
it prettier. That's the nature of NMI. It's an ugly beast in all its
incarnations.

This is why I like my patches. It contains the damage to only the NMI
code. If something breaks from this code, it will be easy to find it. If
anything, a bisect should show exactly what caused change caused the
problem. But if we add hacks in other places, it will be much more
difficult to figure out.

> 
> This all started with wanting to do pagefaults from NMI context, those
> too will have this recursion, although for faults we'll end up in the
> double fault handler, which seems to allow a slightly saner way out.

It didn't start with the pagefaults. That discussion only brought the
issue to LKML. This has been a pain in our side or breakpoints from day
one.

-- Steve


