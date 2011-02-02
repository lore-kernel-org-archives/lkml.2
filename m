Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1BBS3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:29:51 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48364 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972Ab1BBS3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:29:50 -0500
Date: Wed, 2 Feb 2011 13:29:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] Tracepoints: fix section alignment using pointer
	array
Message-ID: <20110202182945.GA27022@Krystal>
References: <20110126222622.GA10794@Krystal> <201101311348.27501.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101311348.27501.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:21:22 up 70 days, 23:24,  3 users,  load average: 0.12, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thu, 27 Jan 2011 08:56:22 am Mathieu Desnoyers wrote:
> > Make the tracepoints more robust, making them solid enough to handle compiler
> > changes by not relying on anything based on compiler-specific behavior with
> > respect to structure alignment. Implement an approach proposed by David Miller:
> > use an array of const pointers to refer to the individual structures, and export
> > this pointer array through the linker script rather than the structures per se.
> > It will consume 32 extra bytes per tracepoint (24 for structure padding and 8
> > for the pointers), but are less likely to break due to compiler changes.
> > 
> > History:
> > 
> > commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> > variable attribute to the tracepoint structures to deal with gcc happily
> > aligning statically defined structures on 32-byte multiples.
> > 
> > commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
> > for tracepoint structures by applying both the variable and type attribute to
> > tracepoint structures definitions and declarations. It worked fine with gcc
> > 4.5.1, but broke with gcc 4.4.4 and 4.4.5.
> > 
> > The reason is that the "aligned" attribute only specify the _minimum_ alignment
> > for a structure, leaving both the compiler and the linker free to align on
> > larger multiples. Because tracepoint.c expects the structures to be placed as an
> > array within each section, up-alignment cause NULL-pointer exceptions due to the
> > extra unexpected padding.
> 
> Hmm, that assumption is used in module parameters too, so we already rely on 
> the toolchain not to over-pad.
> 
> Perhaps we should fix that too, or wait until it explodes?

Hrm, yeah, struct kernel_param seems to fit into the same category. I'd
recommend to fix it too. On 64-bit, this structure size is 28 bytes, but its
alignment is specified by:

__attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *))))

So AFAIU, if you declare __param sections in multiple different objects, that
you later link together to generate a module (or the kernel core), you might end
up with a whole caused by the realignment on 32-byte done by the linker.

In the past, tracepoints were 8-byte aligned, and I had to bump their structure
to a 32-byte alignment because of compiler behavior changes. I would personally
prefer not to wait for other things to break before introducing this fix for
struct kernel_param too.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
